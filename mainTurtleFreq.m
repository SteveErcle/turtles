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

evalBF = pred.predictTurtle('BF');
evalBF.Total


FindFiltIntensity = Evaluator(1,1,evalBF.model_predict);

[tag1] = FindFiltIntensity.peakAndTrough(FindFiltIntensity.model_predict);
target_num_of_extrema = length(tag1)

signal = SigObj.getSignal();
signalHighPass = getFiltered(signal, filt, 'high');
sigHigh = signalHighPass(day : day  + modLen+predLen)+15;


for filt_intensity = 0.075: 0.001:0.175
    sigHighLow = getFiltered(sigHigh, filt_intensity, 'low');
    [tag1, max1, min1] = FindFiltIntensity.peakAndTrough(sigHighLow);
    if abs(length(tag1) - target_num_of_extrema) <= 1
        found_filt_intensity = filt_intensity;
        break
    end
end

found_filt_intensity

% HeatMapofTurtles(signalFilt);
% [totalX] = twoDMapOfTurtles(signal);

%% Thoughts

% Find best method for determining phases
% test against a control
% creat evaluator
