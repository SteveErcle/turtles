% main Experiment

%% This is for experimenting with mainTurtles

clear all; close all; clc;


stock = 'ABT';

RANSTEP = 0;
FAKER = 0;
REALER = 1;
PLOT = 1;


filt = 0.3;
modLen = 178;
predLen = 1;

surfer = [];


if FAKER == 1
    A = [0.5, 1, 1.5, 2, 4, 7]/4;
    P = [24, 31, 52, 84, 122, 543];
elseif REALER == 1
    A = [0.09 0.09 0.2 0.15 0.20 0.35 0.43 0.67]
    P = [18 25 34 43 62 99 142 178]
end
ph = [1.5, 2.4, 0.4, 1.2 , .9, 1.2, 1.3, 4.5];

% How do we get percent return on this heat map?

signal = signalGenerator(stock, RANSTEP, FAKER, REALER, 0, A, P, ph);

signalFilt = getFiltered(signal, filt);


figure()
plot(signal)

figure()

col = hsv(100);
icl = 1;

perRet = [];


parfor day = 601:1:700


sigMod  = signalFilt(day : day  + modLen);
sigPred = signalFilt(day : day  + modLen+predLen);


% HeatMapofTurtles(signalFilt);

% figure()
% [theta] = GDtideFinder(sigMod, A, P);
% [model_predict] = modelConstruction(sigPred, modLen, theta, A, P);
% plotPred(sigPred, modLen, model_predict);
% title('GD')
% 
% 
[theta] = BFtideFinder(sigMod, A, P);
[model_predict] = modelConstruction(sigPred, modLen, theta, A, P);
% plotPred(sigPred, modLen, model_predict);

% t = 1:length(model_predict);
% 
% plot(day+t, sigPred, 'k')
% hold on;
% plot(day+t(1:modLen),model_predict(1:modLen), 'color',col(icl,:))
% hold on;
% plot(day+t(modLen:end),model_predict(modLen:end), 'color',col(icl,:))
% hold on;
% icl = icl + 1;


title('BF')
hold on;

surfer = [surfer; model_predict];

Total = percentReturn(sigPred, modLen, model_predict, 1, 0)

perRet = [perRet; Total];


    

end 


[m,n] = size(surfer)
x = 1:n;
y = 1:m;

ax0 = figure()%subplot(3,1,1);
surf( x , y , surfer )
shading interp;
colorbar;
az = 0;
el = 90;
view(az, el);

figure()
plot(perRet)


% [totalX] = twoDMapOfTurtles(signal);
% [theta] = BFtideFinder(signal, modLen, PLOT,  A, P);





