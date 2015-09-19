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

A = [1 2 3 2 1 5 2 10 3 5 4 5 3 2 2 6 7  2 2 1 4 5]


spacing = linspace(0,1,length(A));

logGrowth = (-log(1-spacing.^4))

logGrowth(end) = logGrowth(end-1)


offset = 1;
scale  = 0.1;

adjuster = offset + scale*(logGrowth-min(logGrowth))/(range(logGrowth))

plot(adjuster)

B = A.*adjuster

figure()
plot(A,'r')
hold on;
plot(B)

