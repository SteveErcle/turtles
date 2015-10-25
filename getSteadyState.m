% getSteadyState

clear all
close all
clc

addpath('/Users/Roccotepper/Documents/turtles/TurtleData');

stock = 'JPM'

A = 1;
P = 30;

day = 1040;
futer = 400;
interval = 10


predLen = 10;
sampLen = 50;
dc_offset = 15;

steadaliousMajoralis= [];


parfor i = 0:futer/interval
    
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
%     c.plotPro(projection, sigPro)
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
hold on
plot(dve,'r')
figure()
plot(pr,'k')
hold on
plot(zeros(length(pr),1),'r')
figure()
plot(theta,'b')
% legend('modDVE', 'PR', 'theta')


[pkt it] = findpeaks(theta);
diferThet = [];

e = Evaluator(1,1,1);

% tagged = e.peakAndTrough(theta);

for i = 1:length(it)-1
   diferThet = [diferThet; it(i+1)-it(i)];
end


figure()
plot((1:length(diferThet))*30,diferThet)
hold on
x = (1:length(diferThet))*30;
y = ones(1,length(x))*P/(interval);
plot(x, y, 'k')






