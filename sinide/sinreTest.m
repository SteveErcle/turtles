
clear all
close all
clc


stock = 'JPM'

filtL = 0.0550;
filtH = 0.0065;
sMod = SignalGenerator(stock, 2000+2, 2000);
[sig, sigHL, sigH, sigL] = sMod.getSignal('ac', filtH, filtL);


predLen = 25;
dc_offset = 15;

dataliousMajor = [];

for day = 1000:predLen:1800

sigPro = sig(day-500:day+predLen);
sigMod = sigHL(day-500:day);


[frq,amp,phi,ave,ssq,cnt] = sinide(sigMod,1,0);

P = 1/frq;
A = amp;
theta = phi - pi/2;
ssq/1000;



c = Construction(A, P, theta, predLen, sigMod);
[model, prediction, projection] = c.constructPro();
c.plotPro(projection, sigPro-mean(sigPro));


e = Evaluator(sigMod, model, prediction);
pr = e.percentReturn(sigPro)
[modDVE, modList] = e.DVE();

plot(modList*100)

pause


data = [P, A, theta, ssq/1000, pr, modDVE, sum(modList(end-50:end))];
dataliousMajor = [dataliousMajor; data];

 
end

mL = dataliousMajor(:, end);
mD = dataliousMajor(:,end-1);
pR = dataliousMajor(:, end-2);

figure()
plot(mL, pR, 'ko')
title('mL')
figure()
plot(mD, pR, 'ko')
title('mD')


% y = A*sin(2*pi*1/P*(1:length(sig))+phi);
% plot(y,'m')
% hold on
% plot(sig)
% x = A*cos(2*pi*1/P*(1:length(sig))+theta);




