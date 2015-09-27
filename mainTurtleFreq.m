clear all
clc
close all

stock = 'JPM';



present = 2000;
sigLen = 1000;
predLen = 100;
ticker = 10;


totals = [];
sosals = [];
founder = [];

% sFFT = SignalGenerator(stock, 2400, 2398);
% [signal_pure] = sFFT.getSignal('ac');
% 
% m = MoonFinder(signal_pure);
% m.getAandP();


P = [  19,  24,   35,   40,  48,  63,   81,   103, 123,   221];

A = [0.23, 0.3, 0.53, 0.35, 0.3, 0.8, 0.56,  1.07, 1.16, 2.43];


sMod = SignalGenerator(stock, present, sigLen);
[sig, sigHL] = sMod.getSignal('ac');
sigMod = sigHL + mean(sig(end-100:end));

t = TideFinder(sigMod, A, P);
t.type = 2;
[theta] = t.getTheta('BF');

c = Construction(A, P, theta, predLen, sigMod);
[model, prediction, projection] = c.constructPro();

conInt = [];
for ci = 1:length(P)
    
    cDays = length(model) + theta(ci)/(2*pi)*P(ci);
    cDays =  mod(cDays, P(ci));
    if cDays > P(ci)/2
        cDays = P(ci) - cDays;
    end
    
    %     cPer  = 2*abs( 0.5 - (cDays/ P(ci)) );
    conInt = [conInt; cDays];
end
CItotal = sum(conInt(:,1)) / (sum(P)/2)

sPro = SignalGenerator(stock, present+predLen, sigLen+predLen);
[sig, sigHL] = sPro.getSignal('ac');
sigPro = sigHL + mean(sig(end-100:end));


% c.plotPlay(projection, sig, ticker);
% ePlay = Evaluator(sigMod, model, prediction(1:ticker+1));
% totalPlay = ePlay.percentReturn(sig(1:length(sigMod)+ticker))

c.plotPro(projection, sig);

e = Evaluator(sigMod, model, prediction);

total0 = e.percentReturn(prediction)
total1 = e.percentReturn(sigPro)
total2 = e.percentReturn(sig)
[modDVE modDVEList] = e.DVE();