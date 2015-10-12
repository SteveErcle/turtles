

clc; clear all; close all;

% stock = 'PG';
% 
% sFFT = SignalGenerator(stock, 2502, 2500);
% [sig, sigHL, sigH, sigL] = sFFT.getSignal('ac');




P = [200] %200 60 45 91];
A = [1]% 2 2 0.2 .4];
ph = [0.0]% 2 0.4 2.3 0 1]
RANSTEP = 1;

t = 0 : 2499;

x1 = 0;

for i = 1:length(A)
    x1 = x1 + A(i)*cos(2*pi*1/P(i)*t + ph(i));
end

x1 = 1;
stepper = zeros(length(t),1);

sSizee = [1975, 1930, 1857, 1332, 1000,900, 740, 600, 450, 180, 140, 50];
sAmp =  [7, 10, 3, -15, -5, -2, 8 ,3, 0, 4, 9, 7];

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


sig = x1' ;
sig = sig-mean(sig)


plot(sig)



filtH = 0.0065
filtL = 0.0110



sigH = getFiltered(sig, filtH, 'high');
sigL = getFiltered(sig, filtL, 'low');
sigHL = getFiltered(sigH, filtL, 'low');


hold on;
plot(sigHL,'r')


% plot(sig)
% 
% figure()
% 
% sample = sigHL';
% 
% fs = 1;
% x1 = sample;
% ss = length(x1);
% x1 = x1.*hanning(length(x1))';
% x1 = [x1 zeros(1, 20000)];
% angles = angle(fft(x1));
% X1 = abs(fft(x1));
% X1 = X1(1:ceil(length(X1)/2));
% X1 = X1/(ss/4);
% Xt = 0:length(X1)-1;
% P = fs./ (Xt*(fs/length(x1)));
% [pkt It] = findpeaks(X1);
% 
% 
% plot(P,X1)
% 
% 
% sum(X1)
