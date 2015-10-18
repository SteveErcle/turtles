
clear all; close all; clc;

stock = 'MENT'
present = 1200

filtH = 0.0065;
filtL = 0.0110;




sMod = SignalGenerator(stock, present+2, 1000);
[sig, sigHL, sigH, sigL] = sMod.getSignal('ac', filtH, filtL);

sigMod = sigHL;



sPro = SignalGenerator(stock, present+2+200, 1000+200);
[sig, sigHL, sigH, sigL] = sPro.getSignal('ac', filtH, filtL);

cheaterSigTrend = sigL(1:end-200);
cheaterSigMod = sigHL(1:end-200);

filtL = 0.0500
sDerv = SignalGenerator(stock, present+2, 1000);
[sig, sigHL, sigH, sigL] = sDerv.getSignal('ac', filtH, filtL);



trendLen = 50; 
sigTrend = sigL;
sigTrend(end-49:end) = linspace(sig(end-49), sig(end), 50);
derv = diff(sigTrend(end-49:end))


sigGreen = sigHL;


sDerv = SignalGenerator(stock, present+2+200, 1000+200);
[sig, sigHL, sigH, sigL] = sDerv.getSignal('ac', filtH, filtL);

sigMagent = sigHL;

% cheaterSigMod = tsmovavg(cheaterSigMod,'s',25,1);


figure()
hold on
% plot(sigMod)
% hold on
% plot(cheaterSigMod,'r')
% plot(sigGreen,'g')
% plot(sigMagent, 'm')
plot(cheaterSigTrend,'c')
plot(sigTrend,'k')
plot(sig)

% plot(sig-mean(sig),'k')



% 
% figure()
% plot(sigMod,'k')
% hold on;
% plot(sig(1:end-200))
% plot(sigL)
% plot(cheaterSigMod,'r')

% hold on
% plot(cheaterSigMod,'r')
% 





% 
% sigModMA = tsmovavg(sigMod,'s',12,1);
% sigProMA = tsmovavg(sigPro,'s',12,1);

% plot(simple)



% end


% y = cos(2*pi*1/100*([1:100])) + rand(1,100)*15;
% 
% window_size = 10


