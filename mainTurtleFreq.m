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


% good @ 230
% ok @ 1050
% bad @ 1100

% load('evalBFtest.mat')


for i = 1:3
    
if i == 1
    day = 230
elseif i == 2
    day = 1050
elseif i == 3
    day = 1100 
end

    
signal = SigObj.getSignal();

% plot(signal)

signalFilt = getFiltered(signal, filt, 'high');
signalFilt = getFiltered(signalFilt, 0.123, 'low')+15;

sigMod = signal(day : day  + modLen);
sigPred = signalFilt(day : day  + modLen+predLen);
sigPredUnfilt = signal(day : day  + modLen+predLen);

pred1 = Turtle(sigMod, sigPred, modLen, A, P);
pred1.type = 1;
evalBF = pred1.predictTurtle('BF');
evalBF.Total
evalBF.DVE()
std(evalBF.sigPred)/mean(evalBF.sigPred);

if i == 1
    evalBFgood = evalBF;
elseif i == 2
    evalBFok = evalBF;
elseif i == 3
    evalBFbad = evalBF; 
end

end 


close all

trackAll = [];
trackmodDVElist = [];
trackpredDVElist = [];
trackPnatlist = [];

LowX1 = 100;
HighX1 = 1850;
fs = 1;

col = hsv(3);
icl = 1;

for i = 1:3

    if i == 1
        eval = evalBFgood;
    elseif i == 2
        eval = evalBFok;
    elseif i == 3
        eval = evalBFbad;
    end
    
    
Total = eval.Total
Std = std(eval.sigPred)/mean(eval.sigPred);
[modDVE, predDVE, modDVElist, predDVElist] = eval.DVE;



track = [Total; Std; modDVE; predDVE]

trackAll = [trackAll, track];

trackmodDVElist = [trackmodDVElist; modDVElist];
trackpredDVElist = [trackpredDVElist; predDVElist];


x1 = eval.sigPred(1:eval.modLen);
ss = length(x1);
x1 = x1.*hanning(length(x1))';
x1 = [x1 zeros(1, 20000)];
X1 = abs(fft(x1));
X1 = X1(1:ceil(length(X1)/2));

X1 = X1/(ss/4);
Xt = 0:length(X1)-1;
P = fs./ (Xt*(fs/length(x1)));
[pkt It] = findpeaks(X1);
It = It-1;

pktItsort = [pkt', It'];
pktItsort = sortrows(pktItsort,-1);

Itk = pktItsort(:,2).';

Pnatlist = fs./ (Itk*(fs/length(x1)));
trackPnatlist = [trackPnatlist; Pnatlist(1:25)];



plot(P(LowX1:HighX1), X1(LowX1:HighX1), 'color',col(icl,:))
hold on;


        for j = 1:length(It)
            if It(j) < 1650
                text( P(It(j)), X1(It(j)), [num2str(P(It(j)))] );
            end
        end

icl = icl + 1;

axis([8 150 0 0.75])




end 

P = [18 25 34 43 62 99 142 178];


plot(P, ones(length(P),1)*0.5, '*');

trackErrorPnatlist = [];
errorPnat = [];

for k = 1:3
    for i = P
        pm = abs(trackPnatlist(k,:)-i);
        [mn ix] = min(pm);
        errorPnat = [errorPnat; abs(i - trackPnatlist(k,ix))];
    end
    
    trackErrorPnatlist = [trackErrorPnatlist; errorPnat'];
    errorPnat = [];
end



t = trackmodDVElist';
figure();
plot(t);
title('modDVE');
legend('good','ok','bad');

t = trackpredDVElist';
figure();
plot(t);
title('predDVE');
legend('good','ok','bad');

% t = trackPnatlist';
% figure();
% plot(t);
% title('Pnat');
% legend('good','ok','bad');

t = trackErrorPnatlist';
figure();
plot(P,t);
title('ErrorPnat');
legend('good','ok','bad');


% [modMME, predMME, modMMElist, predMMElist] = evalBFgood.MME();

% predGood = Turtle(1, evalBFgood.sigPred, evalBFgood.modLen, 1,1);

% predGood.plotPred(evalBFgood.model_predict)

% evalBFgood.peakAndTrough(evalBFgood.sigPred(evalBFgood.modLen:end))


% Bug with MME found, peak or trough before prediction 




%% Thoughts

% Find best method for determining phases
% BF finder parfor and w = 1:3 or 1:2

% test against a control

