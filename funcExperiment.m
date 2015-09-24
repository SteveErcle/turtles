% Stop loss, stop limit & open to close
% "" "" optimization

clear all
clc
close all

stock = 'ABT';
present = 1330;
sigLen = 1000;
predLen = 1;

A = [0.09 0.09 0.2 0.15 0.20 0.35 0.43 0.67];
P = [18 25 34 43 62 99 142 178];

totals = [];
show = [];

parfor present = 2350:2375
    
    
    sMod = SignalGenerator(stock, present, sigLen);
    [sig, sigHL] = sMod.getSignal('ac');
    sigMod = sigHL;
    
    t = TideFinder(sigMod, A, P)
    t.type = 2;
    [theta] = t.getTheta('BF');
    
    c = Construction(A, P, theta, predLen, sigMod);
    [model, prediction, projection] = c.constructPro();
    
    % c.plotPro(projection, sig);
    
    sPro = SignalGenerator(stock, present+predLen, sigLen+predLen);
    [sig, sigHL] = sPro.getSignal('ac');
    sigPro = sigHL;
    
    c.plotPro(projection, sigPro);
    
    e = Evaluator(sigMod, model, prediction);
    total1 = e.percentReturn(sig);
    total2 = e.percentReturn(sigHL);
    tt = [total1, total2];
    
    slope = diff(prediction);
    slope = abs(slope(end))/mean(prediction);
    
   sloper =  [slope, total1, total2];
   
   show = [show; sloper];
   
    
    if slope > 0.0033
%         show = [present,slope,tt]
        totals = [totals; tt];
    end
    
  
  
end

sum(totals(:,1))
sum(totals(:,2))

% open to close;
% stop loss
% stop limit


% close all
%
% plot(sigPro,'r')
% hold on;
% plot(projection)



% plot(sig_pure)
% hold on;
% plot(sigHL,'r')
% hold on;
% plot(sigH,'g')
% hold on;
% plot(sigL,'c')





