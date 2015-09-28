clear all
clc
close all

stock = 'PG';
% AEE
% AEP
% AES
% AA
% ABX

present = 2005;
sigLen = 1000;
predLen = 100;
ticker = 10;


totals = [];
sosals = [];
founder = [];

sFFT = SignalGenerator(stock, 2002, 2000);
[signal_pure, sigHL] = sFFT.getSignal('ac');

m = MoonFinder(sigHL);
m.getAandP();

pause;

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






% saValues = [];

% values = [];
% 
% for i = 1:length(cursor_info4)
% 
% value = getfield(cursor_info4, {i},'Position')
% values = [values;value];
% 
% end 
% 
% saValues = [saValues;values];
% 
% P = saValues(:,1);
% A = saValues(:,3);