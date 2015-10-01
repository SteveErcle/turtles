% Stop loss, stop limit & open to close
% "" "" optimization
% Watch by hand on HL with no candles
% "" with candles

clear all
clc
close all

stock = 'ABT';
presentH = 1200;
sigLen = 1000;
predLen = 20;

A = [0.09 0.09 0.2 0.15 0.20 0.35 0.43 0.67];
P = [18 25 34 43 62 99 142 178];

% getConstructInter()
% getSteadyState()

totals = [];
sosals = [];
founder = [];

show = [];

% for present = presentH %: presentH+100;
%
%     present

for i = 0:1:5
    
    present = presentH+i*predLen
    
    
    sMod = SignalGenerator(stock, present, sigLen);
    [sig, sigHL] = sMod.getSignal('ac');
    sigMod = sigHL + mean(sig(end-100:end));
    
    t = TideFinder(sigMod, A, P)
    t.type = 1;
    [theta] = t.getTheta('BF');
    
    c = Construction(A, P, theta, predLen, sigMod);
    [model, prediction, projection] = c.constructPro();
    
    conInt = [];
    for ci = P
        conInt = [conInt; mod(length(model),ci)];
    end
    
    diffMod = diff(model);
    
    if sign(diffMod(end-1)) ~= sign(diffMod(end))
        
        
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
        
        if percDiff > 0.04 & nextInflection > 7
            
            present
            
            total0 = e.percentReturn(prediction)
            total1 = e.percentReturn(sigPro)
            total2 = e.percentReturn(sig)
            [mod modl] = e.DVE();
            
            founder = [founder; present];
            
        end
        
    end
    
    
    
end









