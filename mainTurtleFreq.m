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
predLen = 100;
day = 1050;

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
ix = [];


% good @ 230
% ok @ 1050
% bad @ 1100

load('evalBFtest.mat')

evalBFgood.sigPred;

goodStd = std(evalBFgood.sigPred)/mean(evalBFgood.sigPred)

[modMME, predMME, modMMElist, predMMElist] = evalBFgood.MME()

predGood = Turtle(1, evalBFgood.sigPred, evalBFgood.modLen, 1,1);

predGood.plotPred(evalBFgood.model_predict)
 
% for i = 1:3
%     
% if i == 1
%     day = 230
% elseif i == 2
%     day = 1050
% elseif i == 3
%     day = 1100 
% end
% 
%     
% signal = SigObj.getSignal();
% 
% plot(signal)
% 
% signalFilt = getFiltered(signal, filt, 'high');
% signalFilt = getFiltered(signalFilt, 0.123, 'low')+15;
% 
% sigMod = signal(day : day  + modLen);
% 
% sigPred = signalFilt(day : day  + modLen+predLen);
% 
% pred1 = Turtle(sigMod, sigPred, modLen, A, P);
% pred1.type = 1;
% evalBF = pred1.predictTurtle('BF');
% evalBF.Total
% evalBF.DVE()
% std(evalBF.sigPred)/mean(evalBF.sigPred);
% 
% if i == 1
%     evalBFgood = evalBF;
% elseif i == 2
%     evalBFok = evalBF;
% elseif i == 3
%     evalBFbad = evalBF; 
% end
% 
% end 
% 



%% Thoughts

% Find best method for determining phases
% BF finder parfor and w = 1:3 or 1:2

% test against a control


