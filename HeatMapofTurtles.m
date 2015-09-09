clear all; close all; clc;








% X = [-3:3]
% Y = [-3:3]
%
% [XX, YY] = meshgrid(X,Y)
% 
% ZZ = XX.^2 - YY.^2
% 
% surf(XX,YY,ZZ)
% 
% axis tight
% shading interp
% colorbar


prds = [];
%
% % for i = 10:-1:1

stock = 'ABC';

present  = 2100
past = present+1-2000


yMtxAll = csvread(strcat(stock,'.csv'),2,1);
yMtxAll = yMtxAll(past-2:present-2,:);

yc = yMtxAll(:,6);
figure()
plot(yc)

%     deg_filt = 5;
%     norm_freqz = 0.3;
%     [b a] = butter(deg_filt,norm_freqz, 'low');
%
%     ycFilt = filtfilt(b,a,yc);
%
%     ycFilt = yc;
%
%
%     x1 = ycFilt';
%     ss = length(x1);


fs = 1;

A = [0.5, 1, 1.5, 2, 4, 7]/4
% A = [1, 2, .1, 5, 4, 0.9]/3
% P = [24, 31, 52, 84, 122, 543]
P = [24, 31, 52, 84, 122, 543].* (rand(6,1)).'
ph = [1.5, 2.4, 0.4, 1.2 , .9, 1.2]
y = 12;


t = 0 : 2000;

for i = 1:length(A)
    y = y + A(i)*cos(2*pi*1/P(i)*t + ph(i));
end

% hold on;
% plot(y,'r')

x1 = y;

red = 1;



stepper = zeros(length(t),1);
sSizee = [1920, 1802, 1403, 1332, 1000,900, 740, 600, 450, 325, 230, 100];
sAmp =  [7, 10, 3, -15, -5, -2, 8 ,3, 0, 4, 9, 7]/4;

for i = 1:length(sSizee)
    stepper(end-(sSizee(i)-1):end) = sAmp(i)*ones(sSizee(i),1);

end

rander = zeros(length(t),1);

for i = 1:length(rander)

    if mod(i,4) == 0
        rander(i) = (-0.5+rand(1,1))*1.2;
    end
end

y1 = x1;

x1 = x1+stepper'+rander';

FAKER = 0;
REALER = 1;

if FAKER == 1
    x1ph = x1;
end

if REALER == 1
    x1ph = yc';
end

hold on;
% figure()
plot(x1,'r')
% hold on
% plot(stepper,'g')


if red == 1

%     figure()
%     plot(x1)
%     hold on;
%     plot(stepper,'r')
%     figure()

    color  = .10;

    theOneDefFive = 1;

    hsverToSelectTheColerNumber = 1000/theOneDefFive;

    col = hsv(hsverToSelectTheColerNumber);
    icl = 1;

    counterr = 1;

    for k = 1:theOneDefFive:1000

        x1 = x1ph(k:1000+k);
        ss = length(x1);

%         figure()
%         plot(x1)
%         hold on;
%         plot(stepper,'r')
        x1 = x1.*hanning(length(x1))';
        x1 = [x1 zeros(1, 20000)];
        X1 = abs(fft(x1));
        X1 = X1(1:ceil(length(X1)/2));

        Xt = 0:length(X1)-1;
        P = fs./ (Xt*(fs/length(x1)));
        [pkt It] = findpeaks(X1);

%         figure()

%         plot3( P(1000:1850), X1(1000:1850), counterr*ones(length(X1(1000:1850))), 'color',col(icl,:));

%         counterr = counterr+.1;

%         plot(P(100:1850), X1(100:1850), 'color',col(icl,:))
% 
% %         scatter(It,pkt)
%         hold on;

       icl = icl + 1;

          surfer = [surfer; X1(300:1200)];
          


%         for j = 1:length(It)
%             if It(j) < 1650
%                 text( P(It(j)), X1(It(j)), [num2str(P(It(j)))] );
%             end
%         end

%         axis([8 100 0 1000])
        title(num2str(k));

%         pause;

%         x1 = y1;
%
% %         x1 = x1ph(1:i);
%         ss = length(x1);
%
% %         x1 = x1.*hanning(length(x1))';
% %         x1 = [x1 zeros(1, 20000)];
%         X1 = abs(fft(x1));
%         X1 = X1(1:ceil(length(X1)/2));
%
%         Xt = 0:length(X1)-1;
%         P = fs./ (Xt*(fs/length(x1)));
%         [pkt It] = findpeaks(X1);
%
%         hold on;
%         plot(P, X1,'r')
%
%         for i = 1:length(It)
%             if It(i) < 100
%                 text( P(It(i)), X1(It(i)), [num2str(P(It(i)))] );
%             end
%         end
%
%         axis([8 600 0 1500])
%


    end

end



I = [0,0,0]
axisP = [60, 100, 200];
maxerP = [0, 0 ,0]


for ac = 1:3
    
    min = 10;
    
    for i = 1:length(P)
        if abs((P(i) - axisP(ac))) < min
            min = P(i)-axisP(ac);
            I(ac) = i;
        end
    end
 
    maxerP(ac) = (max(max(surfer(:,I(ac):end))))
    
end


[m,n] = size(surfer)

x = 1:n;
y = 1:m;


ax0 = figure()%subplot(3,1,1);
surf( P(300:1200) , y , surfer )
shading interp;
colorbar;
az = 0;
el = 90;
view(az, el);


ax1 = figure()%subplot(3,1,1);
surf( P(300:1200) , y , surfer )
set(gca,'xlim',[10 axisP(1)])
set(gca,'zlim',[0, maxerP(1)*1.1])
caxis([0, maxerP(1)])
shading interp;
colorbar;
az = 0;
el = 90;
view(az, el);

ax2 = figure()%subplot(3,1,2);
surf( P(300:1200) , y , surfer )
set(gca,'xlim',[axisP(1) axisP(2)])
set(gca,'zlim',[0, maxerP(2)*1.1])
caxis([0, maxerP(2)])
shading interp;
colorbar;
az = 0;
el = 90;
view(az, el);

ax3 = figure()%subplot(3,1,3);
surf( P(300:1200) , y , surfer )
set(gca,'xlim',[axisP(2) axisP(3)])
set(gca,'zlim',[0, maxerP(3)*1.1])
caxis([0, maxerP(3)])
shading interp;
colorbar;
az = 0;
el = 90;
view(az, el);

% hlink = linkprop([ax1, ax2, ax3],{'CameraPosition','CameraUpVector'});
% rotate3d on
% addprop(hlink,'PlotBoxAspectRatio')



% axis tight;

% ax1 = subplot(1, 2, 1);
% pcolor(rand(10));
% ax2 = subplot(1, 2, 2);
% pcolor(rand(10));
% Link = linkprop([ax1, ax2], ...
%   {'CameraUpVector', 'CameraPosition', 'CameraTarget'}
% setappdata(gcf, 'StoreTheLink', Link);


% axis([8 100 0 1000 0 1000])










% % F_mag = X1;
% %
% % [pks, I]= findpeaks(F_mag');
% % I = I-1;
% %
% % peakrs = sortrows([pks, I,],-1);
% % A_nat = peakrs(:,1)/(ss/4);
% % B_nat = peakrs(:,2);
% % F_nat = peakrs(:,2)*(fs/length(x1));
% % P_nat = fs./F_nat;
% %
% % peakrs(1:5,2);
% % F_nat(1:5);
% % P_nat(1:5,1);
% %
% % numPrds = 40
% % thisPrds = [B_nat(1:numPrds), A_nat(1:numPrds), P_nat(1:numPrds), F_nat(1:numPrds)];
% % prds = [prds; thisPrds];
%
%
% % end
%
%
%
%
%
% %     scatter(thisPrds(:,3),y)
% %     hold on;
%
% % end
%
%
%
% %     subplot(2,1,1)
% %     plot(x1)
% %     xlabel('Samples');
% %     ylabel('Amplitude');
%
% %     angle(X1(3));
% %     X1(31)/(1000/4)
% %     angle(a1(31))
%
% %     subplot(2,1,2);
% %     plot([0:length(X1)-1], X1)
% %     ylabel('Magnitude');
% %     xlabel('Bins');
%
%
% % x1 = 0.5*cos(2*pi*f1*t + 0.2) + 0.85*cos(2*pi*f2*t + 1.8);
% % x1 = 0.5*cos(2*pi*1/p1*t + 0.2) + 0.85*cos(2*pi*1/p2*t + 1.8);
% % x1 = [x1,x1,x1,x1];
% %
% % for i = 1:100:length(t)
% %
%
%
% % for i = 1:20
% % % i = 9
% % t = 1:200;
% % dayer = i*10;
% % n = 9;
% % x = ((n+(log(dayer./t)/log(2)))/n)-1+0.01;
% %
% %
% %
% % if i == 1
% %     plot(x,'r')
% % else
% % plot(x)
% % end
% % hold on;
% % end
%
%
%
