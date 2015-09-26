
% getConstructInter()
% getSteadyState()


% clear all; close all; clc;
%
% P = [80 120];
% theta = [pi/4 pi/2];
% t = 1:270;
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
% CItotal = sum(conInt(:,1))/ (sum(P)/2)


clear all
clc
close all

stock = 'ABT';
presentH = 1656;
sigLen = 1000;
predLen = 20;

A = [0.09 0.09 0.2 0.15 0.20 0.35 0.43 0.67];
P = [18 25 34 43 62 99 142 178];

totals = [];
sosals = [];
founder = [];


lps = [1956;1776;2036;1796;2116;1656]

hps = [2090;1390;1550;1680;1360;1380;1370]

% parfor i = 0:1:25
%
% present = presentH+i*predLen;

for i = 1:length(lps)
    
    present = lps(i)
    
    % for present = presentH:3:presentH+100;
    
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
    CItotal = sum(conInt(:,1)) / (sum(P)/2);
    
    sPro = SignalGenerator(stock, present+predLen, sigLen+predLen);
    [sig, sigHL] = sPro.getSignal('ac');
    sigPro = sigHL + mean(sig(end-100:end));
    
        ticker = 3;
        c.plotPlay(projection, sig, ticker);
    
    %     c.plotPro(projection, sig);
    
    e = Evaluator(sigMod, model, prediction);
    
    total0 = e.percentReturn(prediction);
    total1 = e.percentReturn(sigPro);
    total2 = e.percentReturn(sig);
    [modDVE modDVEList] = e.DVE();
    
    loadErUp = [present, CItotal, total0, total1, total2];
    founder = [founder; loadErUp];
    
        close all
    
end


sfd = sortrows(founder,2)