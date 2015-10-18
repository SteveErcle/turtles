
clear all; close all; clc;

stock = 'MENT'
present = 1500

filtH = 0.0065;
filtL = 0.0110;



% for filtL = 0.0005:0.0010:0.0500

sMod = SignalGenerator(stock, present+2, 1000);
[sig, sigHL, sigH, sigL] = sMod.getSignal('ac', filtH, filtL);

sigMod = sigHL;

sigModMA = tsmovavg(sig,'s',25,1);

sPro = SignalGenerator(stock, present+2+200, 1000+200);
[sig, sigHL, sigH, sigL] = sPro.getSignal('ac', filtH, filtL);

% cheaterSigMod = sigH;
cheaterSigMod = sigHL(1:end-200);

filtL = 0.0500
sDerv = SignalGenerator(stock, present+2, 1000);
[sig, sigHL, sigH, sigL] = sDerv.getSignal('ac', filtH, filtL);


% cheaterSigMod = tsmovavg(cheaterSigMod,'s',25,1);

sumoCumo = 25   
sigMod(end-(sumoCumo-1):end) = linspace(sigHL(end-(sumoCumo-1)), sigHL(end), sumoCumo);

figure()
plot(sigMod)
hold on
plot(cheaterSigMod,'r')
plot(sigHL,'g')

% end

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


