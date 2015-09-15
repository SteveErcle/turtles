clear all; close all; clc;


stock = 'ABT';

RANSTEP = 0;
FAKER = 0;
REALER = 1;
PLOT = 1;

filt = 0.3;
modLen = 200;
predLen = 50;
day = 1;

if FAKER == 1
    A = [0.5, 1, 1.5, 2, 4, 7]/4;
    P = [24, 31, 52, 84, 122, 543];
elseif REALER == 1
    A = [0.09 0.09 0.2 0.15 0.20 0.35 0.43 0.67]
    P = [18 25 34 43 62 99 142 178]
end
ph = [1.5, 2.4, 0.4, 1.2 , .9, 1.2, 1.3, 4.5];



% Find best method for determining phases
% test against a control
% creat evaluator


signal = signalGenerator(stock, RANSTEP, FAKER, REALER, 0, A, P, ph);

signalFilt = getFiltered(signal, filt);


sigMod  = signalFilt(day : day  + modLen);
sigPred = signalFilt(day : day  + modLen+predLen);

figure()
plot(signal)

figure()
[theta] = GDtideFinder(sigMod, A, P);
[model_predict] = modelConstruction(sigPred, modLen, theta, A, P);
plotPred(sigPred, modLen, model_predict);
title('GD')

figure()
[theta] = BFtideFinder(sigMod, A, P);
[model_predict] = modelConstruction(sigPred, modLen, theta, A, P);
plotPred(sigPred, modLen, model_predict);
title('BF')



% HeatMapofTurtles(signal);
% [totalX] = twoDMapOfTurtles(signal);
% [theta] = BFtideFinder(signal, modLen, PLOT,  A, P);
