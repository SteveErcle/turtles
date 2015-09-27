
function [] = getAandP(obj)

signal = obj.signal_pure;

x1ph = signal';
sampleSize = 1500;
leftOver = length(signal)-sampleSize;
fs = 1;
surfer = [];

LowX1 = 50;
HighX1 = 1650;

shifterSize = 1;


for k = 1:shifterSize:leftOver
    
    x1 = x1ph(k:sampleSize+k);
    ss = length(x1);
    x1 = x1.*hanning(length(x1))';
    x1 = [x1 zeros(1, 20000)];
    X1 = abs(fft(x1));
    X1 = X1(1:ceil(length(X1)/2));
    
    X1 = X1/(ss/4);
    
    Xt = 0:length(X1)-1;
    P = fs./ (Xt*(fs/length(x1)));
    [pkt It] = findpeaks(X1);
    
    surfer = [surfer; X1(LowX1:HighX1)];
    
end


axisP = [50, 125, 200];
I = [0,0,0];
maxerP = [0, 0 ,0];


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
surf( P(LowX1:HighX1) , y , surfer )
shading interp;
colorbar;
az = 0;
el = 90;
view(az, el);


ax1 = figure()%subplot(3,1,1);
surf( P(LowX1:HighX1) , y , surfer )
set(gca,'xlim',[10 axisP(1)])
set(gca,'zlim',[0, maxerP(1)*1.1])
caxis([0, maxerP(1)*1.1])
shading interp;
colorbar;
az = 0;
el = 90;
view(az, el);

ax2 = figure()%subplot(3,1,2);
surf( P(LowX1:HighX1) , y , surfer )
set(gca,'xlim',[axisP(1) axisP(2)])
set(gca,'zlim',[0, maxerP(2)*1.1])
caxis([0, maxerP(2)]*1.1)
shading interp;
colorbar;
az = 0;
el = 90;
view(az, el);

ax3 = figure()%subplot(3,1,3);
surf( P(LowX1:HighX1) , y , surfer )
set(gca,'xlim',[axisP(2) axisP(3)])
set(gca,'zlim',[0, maxerP(3)*1.1])
caxis([0, maxerP(3)]*1.1)
shading interp;
colorbar;
az = 0;
el = 90;
view(az, el);
