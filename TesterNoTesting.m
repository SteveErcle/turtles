% anotherExperiment

clc; clear all; close all;

stock = 'ABT';

sFFT = SignalGenerator(stock, 2502, 2500);
[sig, sigHL, sigH, sigL] = sFFT.getSignal('ac');



filtH = 0.01;
filtL = 0.007;

sigH = getFiltered(sig, filtH, 'high');
sigL = getFiltered(sig, filtL, 'low');
sigHL = getFiltered(sigH, filtL, 'low');

hsvNum = 21;
col = hsv(hsvNum);
icl = 1;
plot(sigL+mean(sig), 'color',col(icl,:));
hold on;
plot(sig);
plot(sigH+mean(sig), 'color',col(icl,:));


hsvNum = 21;
col = hsv(hsvNum);
icl = 1;

% for filtL = 0.0010:0.0005:0.0110
%     figure()
%     icl = 1;
%     
%     for filtH = 0.0010:0.0005:0.0110
%         
%         sigH = getFiltered(sig, filtH, 'high');
%         sigL = getFiltered(sig, filtL, 'low');
%         sigHL = getFiltered(sigH, filtL, 'low');
%         
%         
%         plot(sigHL+mean(sig), 'color',col(icl,:));
%         hold on;
% %         plot(sig);
% %         hold on;  
%         
%       % axis([0 2000 20 25]);
%         
%         icl = icl + 1;
%       
%     end
%     
% end


pause;

figure()
filtL = 0.0110;
filtH = 0.0065;
sigH = getFiltered(sig, filtH, 'high');
sigL = getFiltered(sig, filtL, 'low');
sigHL = getFiltered(sigH, filtL, 'low');

hsvNum = 21;
col = hsv(hsvNum);
icl = 1;
plot(sigHL+mean(sig), 'color',col(icl,:));
hold on;
plot(sig);
hold on;

predLen = 0;

fs = 1;
x1 = sigHL';
ss = length(x1);
% x1 = x1.*hanning(length(x1))';
% x1 = [x1 zeros(1, 20000)];
X1 = abs(fft(x1));
X1 = X1(1:ceil(length(X1)/2));
X1 = X1/(ss/4);
Xt = 0:length(X1)-1;
P = fs./ (Xt*(fs/length(x1)));
[pkt It] = findpeaks(X1);

figure()
plot(P,X1)



% P = [176.000000000000;132.530120481928;100];
% A = [0.254756663686452;0.597430320133110;0.912870423280075];
 

% P = [143.790849673203;173.228346456693;222.222222222222;101.382488479263];
% A = [0.339427104715820;0.263888332732101;0.0314977986819783;0.248803629417075];

% sigMod = sigHL;
% t = TideFinder(sigMod, A, P);
% t.type = 1;
% [theta] = t.getTheta('BF');
% c = Construction(A, P, theta, predLen, sigMod);
% [model, prediction, projection] = c.constructPro();
% c.plotPro(projection, sigHL);




% saValues = [];
% values = [];
% for i = 1:length(cursor_info)
% 
% value = getfield(cursor_info, {i},'Position')
% values = [values;value];
% 
% end 
% saValues = [saValues;values];
% P = saValues(:,1);
% A = saValues(:,2);



% for filtH = 0.001:0.001:0.005
%
%     sigH = getFiltered(sig, filtH, 'high');
%     sigH = sigH + filtL*10;
%
%
%     plot(sigH, 'color',col(icl,:));
%     hold on;
%
%     icl = icl + 1
%
% end

% for filtL = 0.01:0.01:0.3
%
%     sigL = getFiltered(sig, filtL, 'low');
%     sigL = sigL + filtL*10;
%
%
%     plot(sigL, 'color',col(icl,:));
%     hold on;
%
%     icl = icl + 1;
%
% end








