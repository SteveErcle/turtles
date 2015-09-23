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
clc
close all

stock = 'ABT';
present = 2200;
signalLen = 2000;
sigLen = 1000;
predLen = 100;

A = [0.09 0.09 0.2 0.15 0.20 0.35 0.43 0.67];
P = [18 25 34 43 62 99 142 178];

s = SignalGenerator(stock, present, signalLen, sigLen);
[signal_pure, sig_pure, sigHL, sigH, sigL] = s.getSignal('ac');


%% Sig to model against
sigMod = sigHL;

sigMod = sigMod + 15;

t = TideFinder(sigMod, A, P)
t.type = 1;
[theta] = t.getTheta('BF');

%% Sig to plot against
sigPlt = sig_pure;

c = Construction(A, P, theta, predLen, sigMod);
[model, prediction, projection] = c.constructPro();
c.plotPro(projection, sigPlt);


%% Sig to plot against
[signalFut, sigFut, sigHLFut, sigH, sigL] = s.getFutureSignal(predLen, 'ac');
sigPlt = sigFut;
c.plotPro(projection, sigHLFut+15);

sigCmp = sigHLFut + 15;

e = Evaluator(sigMod, sigFut, model, prediction);

e.percentReturn(prediction, sigHLFut);

figure()
plot(signal_pure)


% plot(sig_pure)
% hold on;
% plot(sigHL,'r')
% hold on;
% plot(sigH,'g')
% hold on;
% plot(sigL,'c')





