% Percent Return

% Cost using LSE -- standardize signals before LSE

% Percent Differnce of deriative

% amplitude thats wrong but period is right --> error 
% in deriv compared to signal


% 6 dof system = model
% x dof system = signal x--> filter intensity


% LSE on position
% LSE on derivative
% Scale amplitude

% MME

% standarize signal about 0; standarize model to signal about 0;



% 1 --> 20

% 1.1 --> mean at 0

% 21 --> mean at 0


% Filtering --> Standard Deviation --> HIGH PASS
% Filtering bad model and passing on prediction
% Probability of prediction being accurate
%     Backing testing
%     FFT of back test and finding cycles
%         of positive result
% Using multiple sets of periods, period refinment
% Optimizing model length
% Optimizing filter params



clear all
close all
clc


stock = 'ABT';


RANSTEP = 0;
FAKER = 0;
REALER = 1;
PLOT = 1;

filt = 0.3;
modLen = 200;
predLen = 50;
day = 1600;

if FAKER == 1
    A = [0.5, 1, 1.5, 2, 4, 7]/4;
    P = [24, 31, 52, 84, 122, 543];
elseif REALER == 1
    A = [0.09 0.09 0.2 0.15 0.20 0.35 0.43 0.67]
    P = [18 25 34 43 62 99 142 178]
end
ph = [1.5, 2.4, 0.4, 1.2 , .9, 1.2, 1.3, 4.5];


signal = signalGenerator(stock, RANSTEP, FAKER, REALER, 0, A, P, ph);



deg_filt = 5;                   % Enter order of filter
norm_freqz = 0.005;  % Enter strength of filter

[b a] = butter(deg_filt,norm_freqz, 'high');
signalHIGH = filtfilt(b,a,signal);

plot(signalHIGH)

hold on;

plot(signal,'r')

