clear all; close all; clc;


%% Declare

stock = 'ABT';

RANSTEP = 0;
FAKER   = 0;
REALER  = 1;

filt = 0.005;
present = 2400;
signal_length = 2300;
modLen = 1000;
predLen = 25;
day = 1000;

if FAKER == 1
    A = [0.5, 1, 1.5, 2, 4, 7]/4
    P = [24, 31, 52, 84, 122, 543]
elseif REALER == 1
    A = [0.09 0.09 0.2 0.15 0.20 0.35 0.43 0.67]
    P = [18 25 34 43 62 99 142 178]
end
ph = [1.5, 2.4, 0.4, 1.2 , .9, 1.2, 1.3, 4.5];

%% Initialize
SigObj = SignalGenerator(stock, present, signal_length, RANSTEP, FAKER, REALER, ph, A, P);

%% Run

signal = SigObj.getSignal();

signalFilt = getFiltered(signal, filt, 'high');
signalFilt = getFiltered(signalFilt, 0.123, 'low')+15;



plot(signalFilt)
hold on;
plot(signal)

sigMod  = signalFilt(day : day  + modLen);
sigPred = signalFilt(day : day  + modLen+predLen);
sigUnFiltPred = signal(day : day  + modLen+predLen);


pred = Turtle(sigMod, sigPred, modLen, A, P);

% evalGD = pred.predictTurtle('GD');
evalBF = pred.predictTurtle('BF');

evalBF.Total

mm = evalBF.model_predict(1:modLen);
mp = evalBF.model_predict(modLen:end);
sm = sigPred(1:modLen);
sp = sigPred(modLen:end);



% EADstock = evalBF.sigPred;
% EADmodel = evalBF.model_predict;
% 
% [tag1, max1, min1] = evalBF.peakAndTrough(EADstock);
% [tag2, max2, min2] = evalBF.peakAndTrough(EADmodel);
% 
% % arrery = [];
% % 
% % for i = 1:length(max1)
% % apple = abs(max1(i)-max2)
% % 
% % s = abs(i-find(min(apple) == apple))
% % 
% % arrery = [arrery; min(s)]
% % end
% % 
% % sum(arrery)
% 
% 
% 
% % countSignal = SigObj.getSignal();
% % countSignalFilt = getFiltered(signal, filt, 'high');
% % countSigFilt = countSignalFilt(day : day  + modLen+predLen)+15;
% % 
% % 
% % for i = 0.10: 0.001:0.15
% % EADstock = getFiltered(countSigFilt, i, 'low');
% % [tag1, max1, min1] = evalBF.peakAndTrough(EADstock);
% % if abs(length(tag1) - 75) <= 1
% %     i
% %     break
% % end 
% %     
% % 
% % end
% 
% 
% 
% 
% 
% lse1 = sum((mm-sm).^2)
% 
% lse2 = sum((mp-sp).^2)
% 
% dmm = diff(mm);
% dmp = diff(mp);
% dsm = diff(sm);
% dsp = diff(sp); 

hold on;
plot(sigUnFiltPred-8,'c')
% % figure()
% % plot(dmm,'k')
% % hold on;
% % plot(dmp,'b')
% % hold on;
% % plot(dsm, 'r');
% % hold on;
% % plot(dsp, 'r');
% 
% lse1 = sum((dmm-dsm).^2)
% 
% lse2 = sum((dmp-dsp).^2)
% 
% evalBF.Total






% HeatMapofTurtles(signalFilt);
% [totalX] = twoDMapOfTurtles(signal);

%% Thoughts

% Find best method for determining phases
% test against a control
% creat evaluator
