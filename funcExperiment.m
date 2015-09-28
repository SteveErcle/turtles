
% getConstructInter()
% getSteadyState()


clear all
clc
close all


presentH = 2005;  
sigLen = 1000;
predLen = 5;

stock = 'CAH'
% P = [13.9345430978613;12.1956891661940;10.1900473933649;8.54231227651967;41.4277456647399;44.7006237006237;35.8350000000000;30.5411931818182;26.2207317073171;87.4024390243903;100.943661971831;75.9752650176679;151.415492957747];
% A = [0.137136683876066;0.123831167726794;0.132663319123462;0.0914383459565271;0.292900759541032;0.206356368228370;0.216910237574574;0.225765205524527;0.209293408261134;0.552741568314335;0.607976332759956;0.629707239267716;1.07071985289660];

P = [13.9345430978613;41.4277456647399;35.8350000000000;30.5411931818182;87.4024390243903;100.943661971831;75.9752650176679;151.415492957747];
A = [0.137136683876066;0.292900759541032;0.216910237574574;0.225765205524527;0.552741568314335;0.607976332759956;0.629707239267716;1.07071985289660];



% stock = 'ABT';
% A = [0.09 0.09 0.2 0.15 0.20 0.35 0.43 0.67];
% P = [18 25 34 43 62 99 142 178];

% stock = 'JPM'
% A = [0.23, 0.3, 0.53, 0.35, 0.3, 0.8, 0.56,  1.07, 1.16, 2.43];
% P = [  19,  24,   35,   40,  48,  63,   81,   103, 123,   221];


totals = [];
sosals = [];
founder = [];


lps = [2140;2145;2135;2150;2155];

hps = [2100;2055;2030;2040;2035];

parfor i = 0:1:20

present = presentH+i*predLen;

% for i = 1:length(lps)
% 
%     present = lps(i)


% ticker = 5;
% 
% for present = presentH:ticker:presentH+100;
   
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
    c.plotPro(projection, sig);
%     c.plotPro(sigPro, sig);
    
    e = Evaluator(sigMod, model, prediction);
    
    total0 = e.percentReturn(prediction);
    total1 = e.percentReturn(sigPro)
    total2 = e.percentReturn(sig)
    [modDVE modDVEList] = e.DVE();
    
    loadErUp = [theta, present, CItotal, total0, total1, total2];
    founder = [founder; loadErUp];
    
    present
    
    pause
    
    close all
    
end


sfd = sortrows(founder,2)

figure()
plot(founder(:,1))
