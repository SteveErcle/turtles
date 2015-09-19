clear all; close all; clc;


%% Declare

stock = 'ABT';

RANSTEP = 0;
FAKER   = 0;
REALER  = 1;

filt = 0.005;
present = 2100;
signal_length = 2000;
modLen = 1000;
predLen = 100;
day = 250;

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
% signalFilt = signal


plot(signalFilt)
hold on;
plot(signal)

sigMod  = signalFilt(day : day  + modLen);
sigPred = signalFilt(day : day  + modLen+predLen);
sigUnFiltPred = signal(day : day  + modLen+predLen);


pred = Turtle(sigMod, sigPred, modLen, A, P);


% evalGD = pred.predictTurtle('GD');
evalBF = pred.predictTurtle('BF');

mm = evalBF.model_predict(1:modLen);
mp = evalBF.model_predict(modLen:end);
sm = sigPred(1:modLen);
sp = sigPred(modLen:end);



lse1 = sum((mm-sm).^2)
lse2 = sum((mp-sp).^2)

dmm = diff(mm);
dmp = diff(mp);
dsm = diff(sm);
dsp = diff(sp); 

% figure()
% plot(dmm,'k')
% hold on;
% plot(dmp,'b')
% hold on;
% plot(dsm, 'r');
% hold on;
% plot(dsp, 'r');

lse1 = sum((dmm-dsm).^2)

lse2 = sum((dmp-dsp).^2)

evalBF.Total

%% Peak Tester
% close all
clc
EadStock = evalBF.sigPred;
EadModel = evalBF.model_predict;

[Modindex,Modindexpeak,Modindextrough] = evalBF.peakAndTrough(EadModel);
[Sigindex,Sigindexpeak,Sigindextrough] = evalBF.peakAndTrough(EadStock);
length(Modindex)
length(Sigindex)
length(Modindexpeak)
length(Sigindexpeak)
length(Modindextrough)
length(Sigindextrough)

figure()
plot(Modindexpeak,ones(length(Modindexpeak)),'k*')
hold on
plot(Sigindexpeak,ones(length(Sigindexpeak)), 'r*')
plot(Modindextrough,0.99*ones(length(Modindextrough)),'ko')
plot(Sigindextrough,0.99*ones(length(Sigindextrough)), 'ro')
axis([0,1150,0.95,1])

indices = [];
for s = Modindexpeak
    [c index] = min(abs(Sigindexpeak-s));
    indices = [indices; s-Sigindexpeak(index)];
end

% Wrapped MME into Evaluator class. There were some problems with the edges
% of the data so some pre processing was necessary (always finding first
% and last data point as a max or min when they were just the end of the
% data

sigPred = evalBF.sigPred;
model_predict = evalBF.model_predict;


 for i = 1:2
               
               if i == 1
                   [Modindex,Modindexpeak,Modindextrough] = evalBF.peakAndTrough(model_predict(1:modLen));
                   [Sigindex,Sigindexpeak,Sigindextrough] = evalBF.peakAndTrough(sigPred(1:modLen));
               else
                   [Modindex,Modindexpeak,Modindextrough] = evalBF.peakAndTrough(model_predict(modLen:end));
                   [Sigindex,Sigindexpeak,Sigindextrough] = evalBF.peakAndTrough(sigPred(modLen:end));
               end
               
               MME1 = [];
               MME2 = [];
               
               if Modindexpeak(1) > Modindextrough(1)
                   Modindextrough(1) = [];
               else
                   Modindexpeak(1) = [];
               end
               
               if Modindexpeak(end) < Modindextrough(end)
                   Modindextrough(end) = [];
               else
                   Modindexpeak(end) = [];
               end
               
               if Sigindexpeak(1) > Sigindextrough(1)
                   Sigindextrough(1) = [];
               else
                   Sigindexpeak(1) = [];
               end
               
               if Sigindexpeak(end) < Sigindextrough(end)
                   Sigindextrough(end) = [];
               else
                   Sigindexpeak(end) = [];
               end
               
     
               for m = Modindexpeak
                   MME1 = [MME1; (min(abs((m - Sigindexpeak))))];
               end
               
               for m = Modindextrough
                   MME2 = [MME2; (min(abs((m - Sigindextrough))))];
               end
               
               if i == 1
                   modMME1 = MME1;
                   modMME2 = MME2;
               else
                   predMME1 = MME1;
                   predMME2 = MME2;
               end
 end 
 
 % Wrapped version below. evalBF.MME() returns the model MME and the
 % predMME (squared error).

 [evalBF.modMME, evalBF.predMME] = evalBF.MME()
 
 
 % Answer not correlating to good answer because sometimes the
 % signal has more or less peaks. Maybe we have to filter the answer one
 % more time to get equal number of peaks and troughs



%%


%  HeatMapofTurtles(signalFilt);
% [totalX] = twoDMapOfTurtles(signal);

%% Thoughts

% Find best method for determining phases
% test against a control
% creat evaluator
