clear all
clc
close all


% AEE
% AEP
% AES
% AA
% ABX

<<<<<<< HEAD
filt = 0.005;
present = 2400;
signal_length = 2300;



modLen = 1000;
=======
present = 1700;
sigLen = 1000;
>>>>>>> de984d8d5c0249a6a34548f9a547200075924dcb
predLen = 100;
ticker = 10;


totals = [];
sosals = [];
founder = [];

sFFT = SignalGenerator(stock, 2002, 2000);
[signal_pure, sigHL] = sFFT.getSignal('ac');


<<<<<<< HEAD
for i = 1:1
    
if i == 1
    day = 230
elseif i == 2
    day = 1050
elseif i == 3
    day = 1100 
end


SigObj.presentp = 1330;
SigObj.sigLenp = 1001;
sigMod = SigObj.getSignal();


SigObj.presentp = 1430;
SigObj.sigLenp = 1101;
sigPred = SigObj.getSignal();

tm = 1330-1000:1330;
tp = 1430-1100:1430;

plot(tm,sigMod,'r')
hold on;
plot(tp, sigPred+1,'b');


% sigMod(1)
% sigMod(end)
% sigPred(1)
% sigPred(end)

% signal = SigObj.getSignal();

% plot(signal)


% sigMod = signal(day : day  + modLen);
sigMod = getFiltered(sigMod, filt, 'high');
sigMod = getFiltered(sigMod, 0.123, 'low')+15;



% sigPred = signal(day : day  + modLen+predLen);
sigPred = getFiltered(sigPred, filt, 'high');
sigPred = getFiltered(sigPred, 0.123, 'low')+15;







% sigPredUnfilt = signal(day : day  + modLen+predLen);


% sigMod = SigObj.getSignal()
% 
% SigFutObj = SignalGenerator(stock, present+predLen, 100, RANSTEP, FAKER, REALER, ph, A, P);
% 
% sigPred = SigFutObj.getSignal();


pred1 = Turtle(sigMod, sigPred, modLen, A, P);
pred1.type = 1;
evalBF = pred1.predictTurtle('BF');
evalBF.Total
evalBF.DVE()
std(evalBF.sigPred)/mean(evalBF.sigPred);

if i == 1
    evalBFgood = evalBF;
elseif i == 2
    evalBFok = evalBF;
elseif i == 3
    evalBFbad = evalBF; 
end

end 
=======
>>>>>>> de984d8d5c0249a6a34548f9a547200075924dcb

m = MoonFinder(signal_pure);
m.getAandP();

<<<<<<< HEAD

pause


close all
=======
plot(signal_pure)
figure()
plot(sigHL)
>>>>>>> de984d8d5c0249a6a34548f9a547200075924dcb

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






saValues = [];

values = [];

for i = 1:length(cursor_info3)

value = getfield(cursor_info3, {i},'Position')
values = [values;value];

end 

saValues = [saValues;values];

P = saValues(:,1);
A = saValues(:,3);