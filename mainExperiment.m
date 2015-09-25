% main Experiment


%% This is for experimenting with mainTurtles

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
predLen = 5;
day = 500;

if FAKER == 1
    A = [0.5, 1, 1.5, 2, 4, 7]/4;
    P = [24, 31, 52, 84, 122, 543];
elseif REALER == 1
    A = [0.09 0.09 0.2 0.15 0.20 0.35 0.43 0.67];
    %     P = [18 25 31 43 62 99 142 178];
    P = [18 25 34 43 62 99 142 178];
    
end
ph = [1.5, 2.4, 0.4, 1.2 , .9, 1.2, 1.3, 4.5];

%% Initialize
SigObj = SignalGenerator(stock, present, signal_length, RANSTEP, FAKER, REALER, ph, A, P);

%% Run

ix = [];

%% Testing recalculator


ix = [];

totals = [];


daz = 230;

day = daz;

show = [];

signal = SigObj.getSignal();

parfor day = daz : daz+25
    
    sigPredUnfilt = signal(day : day  + modLen+predLen);
    sigMod = signal(day : day  + modLen);
    sigPred = signal(day : day  + modLen+predLen);
    
    dc_offset = mean(sigMod);
    sigMod = getFiltered(sigMod, filt, 'high');
    sigMod = getFiltered(sigMod, 0.123, 'low')+dc_offset;
    
    dc_offset = mean(sigPred);
    sigPred = getFiltered(sigPred, filt, 'high');
    sigPred = getFiltered(sigPred, 0.123, 'low')+dc_offset;
    
    sigPredUnfilt = sigPredUnfilt;
    sigMod = sigMod;
    sigPred = sigPred;
    
    pred1 = Turtle(sigMod, sigPred, modLen, A, P);
    pred1.type = 2;
    pred1.sigPredUnfilt = sigPredUnfilt;
    
    evalBF1 = pred1.predictTurtle('BF');
    evalBF1.Total;
    evalBF1.DVE();
    std(evalBF1.sigPred)/mean(evalBF1.sigPred);
    
    % slope = diff(evalBF1.model_predict);
    % day
    % slope = abs(slope(end))%%/mean(evalBF1.model_predict)
    
    totals = [totals; evalBF1.Total];
    
    
end


totals

sum(totals)




