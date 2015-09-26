
% getConstructInter()
% getSteadyState()

% 
% clear all; close all; clc;
% 
% P = [80 120];
% theta = [pi/3 pi/2];
% t = 1:300;
% model = cos(2*pi*1/P(1)*t + theta(1)) + 2*cos(2*pi*1/P(2)*t + theta(2)) ;
% 
% 
% plot(model)
% 
% 
% 
% conInt = [];
% for ci = 1:length(P)
%     
%     cDays = length(model) + theta(ci)/(2*pi)*P(ci);
%     cDays =  mod(cDays, P(ci))
%     if cDays > P(ci)/2
%         cDays = P(ci) - cDays
%     end
%     
%     cPer  = 2*abs( 0.5 - (cDays/ P(ci)) );
%     conInt = [conInt; cDays, cPer];
% end
% 
% CItotal = sum(conInt(:,1))
% 
% 
% 
% pause

clear all
clc
close all

stock = 'ABT';
presentH = 1900;
sigLen = 1000;
predLen = 50;

A = [0.09 0.09 0.2 0.15 0.20 0.35 0.43 0.67];
P = [18 25 34 43 62 99 142 178];

totals = [];
sosals = [];
founder = [];

% for present = presentH %: presentH+100;
%

lps = [1450;1300;1600]

hps = [1400;1700;1550]

parfor i = 0:1:10

present = presentH+i*predLen;

% for i = 1:length(lps)
%     
%     present = lps(i)
   
    
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
        cDays =  mod(cDays, P(ci))
        if cDays > P(ci)/2
            cDays = P(ci) - cDays
        end
        
        %     cPer  = 2*abs( 0.5 - (cDays/ P(ci)) );
        conInt = [conInt; cDays];
    end
    
    CItotal = sum(conInt(:,1));
    
    diffMod = diff(model);
    
    sPro = SignalGenerator(stock, present+predLen, sigLen+predLen);
    [sig, sigHL] = sPro.getSignal('ac');
    sigPro = sigHL + mean(sig(end-100:end));
    
    c.plotPro(projection, sigPro);
    c.plotPro(projection, sig);
    
    e = Evaluator(sigMod, model, prediction);
    
    nextInflection = e.peakAndTrough(prediction);
    nextInflection = nextInflection(2);
    
    percDiff = abs((prediction(nextInflection) - model(end-1))/model(end-1))
    nextInflection
    
    total0 = e.percentReturn(prediction)
    total1 = e.percentReturn(sigPro)
    total2 = e.percentReturn(sig)
    [modDVE modDVEList] = e.DVE();
    
    loadErUp = [present, CItotal, total0, total1, total2];
    
    founder = [founder; loadErUp];
    
    
end


sfd = sortrows(founder,2)