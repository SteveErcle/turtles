% Stop loss, stop limit & open to close
% "" "" optimization

clear all
clc
close all

stock = 'ABT';
presentH = 1852;
sigLen = 1000;
predLen = 20;

A = [0.09 0.09 0.2 0.15 0.20 0.35 0.43 0.67];
P = [18 25 34 43 62 99 142 178];

% construct Interference finder

totals = [];
sosals = [];
founder = [];

show = [];

for present = presentH %: presentH+100;
    
    present
    
    % for i = 0:1:10
    
    %     present = presentH+i*predLen
    
    sMod = SignalGenerator(stock, present, sigLen);
    [sig, sigHL] = sMod.getSignal('ac');
    sigMod = sigHL + mean(sig);
    
    t = TideFinder(sigMod, A, P)
    t.type = 2;
    [theta] = t.getTheta('BF');
    
    c = Construction(A, P, theta, predLen, sigMod);
    [model, prediction, projection] = c.constructPro();
    
    diffMod = diff(model);
    
    if sign(diffMod(end-1)) ~= sign(diffMod(end))
        
           
        sPro = SignalGenerator(stock, present+predLen, sigLen+predLen);
        [sig, sigHL] = sPro.getSignal('ac');
        sigPro = sigHL + mean(sig);
        
        c.plotPro(projection, sigPro);
        c.plotPro(projection, sig);
        
        e = Evaluator(sigMod, model, prediction);
        
        nextInflection = e.peakAndTrough(prediction);
        nextInflection = nextInflection(2);
        
        
        
        percDiff = abs((prediction(nextInflection) - model(end-1))/model(end-1))
        nextInflection
        
        if percDiff > 0.05 & nextInflection > 7
            
            present
            
            total0 = e.percentReturn(prediction)
            total1 = e.percentReturn(sigPro)
            total2 = e.percentReturn(sig)
            [mod modl] = e.DVE();
            
            founder = [founder; present];
            
        end
        
    end
    
    
    
end




%         slope = abs((prediction(end)-prediction(1)) / prediction(1));
%
%         tt = [total0, total1, total2, slope, sum(modl(end-200:end))];
%
%         if total0 > 1
%             ss = [total0, total1, total2, slope, sum(modl(end-200:end))];
%             sosals = [sosals ;ss];
%         end
%
%         totals = [totals; tt];


figure()
plot((totals(:,2)))
hold on;
plot((totals(:,3)),'r')

sum(totals(:,1))
sum(totals(:,2))
sum(totals(:,3))

figure()
plot((sosals(:,2)))
hold on;
plot((sosals(:,3)),'r')

sum(sosals(:,1))
sum(sosals(:,2))
sum(sosals(:,3))

% figure()
% plot(totals(:,3),totals(:,1), '*')
% hold on
% plot(totals(:,3),totals(:,2), 'r*')
% title('Sloper')
%
% figure()
% plot(totals(:,4),totals(:,1), '*')
% hold on
% plot(totals(:,4),totals(:,2), 'r*')
% title('diffErrorer')




% open to close;
% stop loss
% stop limit







