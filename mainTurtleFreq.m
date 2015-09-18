clear all; close all; clc;


%% Declare

stock = 'ABT';

RANSTEP = 0;
FAKER = 1;
REALER = 0;


filt = 0.15;
present = 2100;
signal_length = 2000;
modLen = 500;
predLen = 100;
day = 1;

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

signalFilt = getFiltered(signal, filt, 'low');
sigMod  = signalFilt(day : day  + modLen);
sigPred = signalFilt(day : day  + modLen+predLen);
sigUnFiltPred = signal(day : day  + modLen+predLen);


pred = Turtle(sigMod, sigPred, modLen, A, P);

evalGD = pred.predictTurtle('GD');
evalBF = pred.predictTurtle('BF');






% HeatMapofTurtles(signalFilt);
% [totalX] = twoDMapOfTurtles(signal);

%% Thoughts

% Find best method for determining phases
% test against a control
% creat evaluator
