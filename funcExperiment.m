
% getConstructInter()
% getSteadyState()


clear all
clc
close all


presentH = 2510;
sigLen = 1000;
predLen = 100;

% stock = 'ABT';
% A = [0.09 0.09 0.2 0.15 0.20 0.35 0.43 0.67];
% P = [18 25 34 43 62 99 142 178];

stock = 'JPM'
A = [0.23, 0.3, 0.53, 0.35, 0.3, 0.8, 0.56,  1.07, 1.16, 2.43];
P = [  19,  24,   35,   40,  48,  63,   81,   103, 123,   221];


totals = [];
sosals = [];
founder = [];


lps = [1956;1776;2036;1796;2116;1656];

hps = [2090;1390;1550;1680;1360;1380;1370];

% parfor i = 0:1:0
% 
% present = presentH+i*predLen;

% % for i = 1:length(lps)
% %
% %     present = lps(i)


ticker = 2;

for present = presentH:ticker:presentH+100;
    
    sMod = SignalGenerator(stock, present, sigLen);
    [sig, sigHL] = sMod.getSignal('ac');
    sigMod = sigHL + mean(sig(end-100:end));
    
    t = TideFinder(sigMod, A, P);
    t.type = 1;
    [theta] = t.getTheta('BF');
    
    c = Construction(A, P, theta, predLen, sigMod);
    [model, prediction, projection] = c.constructPro();
    
    conInt = [];
    for ci = 1:length(P)
        
        cDays = length(model) + theta(ci)/(2*pi)*P(ci);
        cDays =  mod(cDays, P(ci));
        if cDays > P(ci)/2
            cDays = P(ci) - cDays;
        end
        
        %     cPer  = 2*abs( 0.5 - (cDays/ P(ci)) );
        conInt = [conInt; cDays];
    end
    CItotal = sum(conInt(:,1)) / (sum(P)/2)
    
    sPro = SignalGenerator(stock, present+predLen, sigLen+predLen);
    [sig, sigHL] = sPro.getSignal('ac');
    sigPro = sigHL + mean(sig(end-100:end));
    

%     c.plotPlay(projection, sig, ticker);
%     ePlay = Evaluator(sigMod, model, prediction(1:ticker+1));
%     totalPlay = ePlay.percentReturn(sig(1:length(sigMod)+ticker))

    c.plotPro(projection, sigPro);
    
    e = Evaluator(sigMod, model, prediction);
    
    total0 = e.percentReturn(prediction);
    total1 = e.percentReturn(sigPro);
    total2 = e.percentReturn(sig);
    [modDVE modDVEList] = e.DVE();
    
    loadErUp = [present, CItotal, total0, total1, total2];
    founder = [founder; loadErUp];
    
    present
    
%     close all
    
end


sfd = sortrows(founder,2)