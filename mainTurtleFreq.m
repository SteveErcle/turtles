clear all; close all; clc;

fprintf('i like boys\n') %Ead's contribution

stock = 'ABT';


RANSTEP = 0;
FAKER = 0;
REALER = 1;
PLOT = 1;

filt = 0.15;
modLen = 500;
predLen = 100;
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


%% ----

deg_filt = 5;                   % Enter order of filter
norm_freqz = 0.005;  % Enter strength of filter

[b a] = butter(deg_filt,norm_freqz, 'high');
signalHIGH = filtfilt(b,a,signal);

% signalFilt = signalHIGH;

signalFilt = getFiltered(signalHIGH, filt);

% plot(signalHIGH)
% 
% hold on;
% 
% plot(signal,'r')


%%




sigMod  = signalFilt(day : day  + modLen);
sigPred = signalFilt(day : day  + modLen+predLen);
sigUnFilt = signal(day : day  + modLen+predLen);





figure()
plot(signal)
hold on;
plot(signalFilt,'k')

figure()
[theta] = GDtideFinder(sigMod, A, P);
[model_predict] = modelConstruction(sigPred, modLen, theta, A, P);
plotPred(sigPred, modLen, model_predict);
title('GD')

evalGD = Evaluator(sigPred, modLen, model_predict);
evalGD.Total = evalGD.percentReturn()

% hold on;
% plot(sigUnFilt,'color',[0,0.65,0]);



% figure(10)
% plot(diff(sigPred),'r');
% hold on;
% plot(diff(model_predict),'k');



    




figure()
[theta] = BFtideFinder(sigMod, A, P);
[model_predict] = modelConstruction(sigPred, modLen, theta, A, P);
plotPred(sigPred, modLen, model_predict);
title('BF')

evalBF = Evaluator(sigPred, modLen, model_predict);
evalBF.Total = evalBF.percentReturn()

% hold on;
% plot(sigUnFilt,'color',[0,0.65,0]);

% 
% figure(11)
% plot(diff(sigPred),'r');
% hold on;
% plot(diff(model_predict),'k');
% 
% 


% B = [];
% 
% sigPred;
% model_predict;
% 
% A = sigPred
% Z = model_predict
% newB = [];
% for i = 2:length(sigPred)
%     B =  [B; (A(i) - A(i-1))];
%     newB = [newB; (Z(i) - Z(i-1))];
%     
% end 
% 
% figure()
% plot(B,'r')
% hold on;
% plot(newB,'b');





HeatMapofTurtles(signalFilt);
% [totalX] = twoDMapOfTurtles(signal);
% [theta] = BFtideFinder(signal, modLen, PLOT,  A, P);
