% getSteadyState

clear all
close all
clc

addpath('/Users/Roccotepper/Documents/turtles/TurtleData');

stock = 'JPM'

A = 1;
P = 316;

day = 1000;
futer = 1000;
interval = 10


predLen = P/4;
sampLen = P*3;
dc_offset = 15;

steadaliousMajoralis= [];


for i = 0:futer/interval
    
    present = day + i*interval;
    
    filtL = 0.0550;
    filtH = 0.0065;
    sMod = SignalGenerator(stock, present+2, sampLen);
    [sig, sigHL, sigH, sigL] = sMod.getSignal('ac', filtH, filtL);
    sigMod = sig;
    
    sPro = SignalGenerator(stock, present+2+predLen, sampLen+predLen);
    [sig, sigHL, sigH, sigL] = sPro.getSignal('ac', filtH, filtL);
    sigPro = sig;
    
    %     [X1 Pds] = getFFT(sigMod');
    t = TideFinder(sigMod, A, P);
    theta = t.BFtideFinder();
    c = Construction(A, P, theta, predLen, sigMod);
    [model, prediction, projection] = c.constructPro();
    c.plotPro(projection, sigPro)
    e = Evaluator(sigMod, model, prediction);
    pr = e.percentReturn(sigPro)
    [modDVE, modList] = e.DVE();
    
    
    data = [i, present, modDVE, pr, theta];
    steadaliousMajoralis = [steadaliousMajoralis; data];
    
end


% dve = normalizer(steadaliousMajoralis(:,3));
% pr = normalizer(steadaliousMajoralis(:,4));
% theta = normalizer(steadaliousMajoralis(:,5));
 

dve = (steadaliousMajoralis(:,3));
pr = (steadaliousMajoralis(:,4));
theta = (steadaliousMajoralis(:,5));
% [theta] = getFiltered(theta, 0.1, 'low');

% 
figure()
plot(pr,'k')
hold on
plot(zeros(length(pr),1),'r')

zoneStart = input('Where does steady state zone start? ')
zoneEnd = input('Where does steady state zone end? ')



plot(pr,'k')
hold on
plot(zeros(length(pr),1),'r')
hold on
plot(zoneStart:zoneEnd, pr(zoneStart:zoneEnd), 'g');

figure()
plot(theta,'b')
hold on
plot(zoneStart:zoneEnd, theta(zoneStart:zoneEnd), 'g');

figure()
plot(dve,'r')
hold on
plot(zoneStart:zoneEnd, dve(zoneStart:zoneEnd), 'g');




% legend('modDVE', 'PR', 'theta')


[pkt it] = findpeaks(theta);
diferThet = [];

e = Evaluator(1,1,1);

% tagged = e.peakAndTrough(theta);

% for i = 1:length(it)-1
%    diferThet = [diferThet; it(i+1)-it(i)];
% end
% 
% diferThet = [0; diferThet];
% 
% figure()
% plot(diferThet)
% % (1:length(diferThet))*P,
% hold on
% x = (1:length(diferThet))*P;
% y = ones(1,length(x))*P/(interval);
% plot(y, 'k')






