

clc; clear all; close all;

stock = 'JPM';

sFFT = SignalGenerator(stock, 2502, 2500);
[sig, sigHL, sigH, sigL] = sFFT.getSignal('ac');

filtH = 0.0065
filtL = 0.0110

sigH = getFiltered(sig, filtH, 'high');
sigL = getFiltered(sig, filtL, 'low');
sigHL = getFiltered(sigH, filtL, 'low');

% sigHL = [1:2500]';
sigHL = (sigHL-min(sigHL))/ range(sigHL);


sigH = (sigH-min(sigH))/ range(sigH);

sigPro = sigH;
sigPro = getFiltered(sigPro, 0.1, 'low');

% sigHL = sigHL/1000;


dmm = diff(sigHL);
           
dsm = diff(sigPro);


figure()
plot(dmm,'k')
hold on;
plot(dsm,'r')

modDVElist = (dmm-dsm).^2;
figure()
plot(modDVElist)

modDVE = sum(modDVElist)

figure()
plot(sigHL)
hold on;
plot(sigPro,'r')

% e = Evaluator(sigPro, sigHL', 1);
% 
% 
% [modDVE, modDVElist] = e.DVE();
% 
% modDVE
% 
% plot(sigH,'r')
% hold on;
% plot(sigHL,'k')
% 
% 
% %%
% 
% y2 = 10*cos(2*pi*1/100*(0:99))+100;
% y2 = (y2-min(y2))/ range(y2);
% 
% x2 = 10*cos(2*pi*1/80*(0:99))+100;
% x2 = (x2-min(x2))/ range(x2);
% 
% e2 = Evaluator(x2, y2', 1);
% 
% 
% [modDVE2, modDVElist2] = e2.DVE();
% modDVE2
% 
% figure()
% plot(x2,'r')
% hold on;
% plot(y2,'k')
% 
% 
% 
% 
% 
% 
% 
