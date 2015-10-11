% anotherExperiment3

clear all; close all; clc;

% stock = 'ABT';

% sFFT = SignalGenerator(stock, 2502, 2500);
% [sig, sigHL, sigH, sigL] = sFFT.getSignal('ac');


% filtL = 0.0110;
% filtH = 0.0065;
% sigH = getFiltered(sig, filtH, 'high');
% sigL = getFiltered(sig, filtL, 'low');
% sigHL = getFiltered(sigH, filtL, 'low');

% plot(sigHL+mean(sig));
% hold on;
% plot(sig,'r');


% m = MoonFinder(sig);
% m.getAandP();


figure()


x1 = 12;

signalLen = 2000

P = [300 200 20 45 91];
A = [3 2 2 0.2 .4];
ph = [0.1 2 0.4 2.3 0 1]
FAKER = 1;
RANSTEP = 1;

t = 1 : signalLen;

for i = 1:length(A)
    x1 = x1 + A(i)*cos(2*pi*1/P(i)*t + ph(i));
end


stepper = zeros(length(t),1);

sSizee = [1975, 1930, 1857, 1332, 1000,900, 740, 600, 450, 180, 140, 50];
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

if RANSTEP == 1
    x1 = x1+stepper'+rander';
end

if FAKER == 1
    signal = x1;
end



sig = x1' ;

plot(x1)


m = MoonFinder(sig);
m.getAandP();

% plot(signal)
% 
% sigHL = signal';
% 
% % hsvNum = 21;
% % col = hsv(hsvNum);
% % icl = 1;
% % plot(sigHL+mean(sig), 'color',col(icl,:));
% % hold on;
% % plot(sig);
% % hold on;
% 
% predLen = 0;
% 
% fs = 1;
% x1 = sigHL';
% ss = length(x1);
% % x1 = x1.*hanning(length(x1))';
% % x1 = [x1 zeros(1, 20000)];
% X1 = abs(fft(x1));
% X1 = X1(1:ceil(length(X1)/2));
% X1 = X1/(ss/4);
% Xt = 0:length(X1)-1;
% P = fs./ (Xt*(fs/length(x1)));
% [pkt It] = findpeaks(X1);
% 
% figure()
% % plot(X1)
% 
% 
% LowX1 = 10;
% HighX1 = 4000;
% % plot(P(LowX1:HighX1) ,X1(LowX1:HighX1) )
% plot(P,X1)






