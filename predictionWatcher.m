% predictionWatcher


clear all
close all
clc


addpath('/Users/Roccotepper/Documents/turtles/TurtleData')
addpath('/Users/Roccotepper/Documents/turtles/sinide')

stock = 'JPM'
A = 1;
P = 120;

day = 1125;
futer = 500;
interval = 1

predLen = P/4;
sampLen = P*3;

dc_offset = 15;
dataliousMajor = [];
dataliousMinor = [];
expectoProptronum = [];
PRall = [];

parfor i = 0:futer/interval
    present = day + i*interval
    
    
    filtL = 0.0550;
    filtH = 0.0065;
    
    sMod = SignalGenerator(stock, present+2, sampLen);
    [sigMod, sigModHL, sigH, sigL] = sMod.getSignal('ac', filtH, filtL);
    
    
    sPro = SignalGenerator(stock, present+2+predLen, sampLen+predLen);
    [sigPro, sigHL, sigH, sigL] = sPro.getSignal('ac', filtH, filtL);
    
    
    %     [frq,amp,phi,ave,ssq,cnt] = sinide(sigMod,1,0);
    %
    %     P = 1/frq;
    %     A = amp;
    %     theta = phi - pi/2;
    %     ssq/1000;
    
    
    t = TideFinder(sigMod, A, P);
    theta = t.BFtideFinder();
    
    c = Construction(A, P, theta, predLen, sigMod);
    [model, prediction, projection] = c.constructPro();
%     c.plotPro(projection, sigPro);
    
    e = Evaluator(sigMod, model, prediction);
    pr = e.percentReturn(sigPro);
    
    PRall = [PRall; pr];
    
    
%     sMod = SignalGenerator(stock, present+2+predLen, sampLen+predLen);
%     [sigMod, sigHL, sigH, sigL] = sMod.getSignal('ac', filtH, filtL);
%     
%     sPro = SignalGenerator(stock, present+2+(2*predLen), sampLen+(2*predLen));
%     [sigPro, sigHL, sigH, sigL] = sPro.getSignal('ac', filtH, filtL);
%     
%     t = TideFinder(sigMod, A, P);
%     theta = t.BFtideFinder();
%     
%     c = Construction(A, P, theta, predLen, sigMod);
%     [model, prediction, projection] = c.constructPro();
% %     c.plotPro(projection, sigPro);
%     
%     eFut = Evaluator(sigMod, model, prediction);
%     prFut = eFut.percentReturn(sigPro);
%     
% %         prTrack = [pr, pr - PRall(end,1), prFut];
%     prTrack = [pr, prFut];
%     
%     PRall = [PRall; prTrack];

    
    
%     pause
    
    
    %     sigModNorm = normalizer(sigModHL);
    %     modelNorm = normalizer(model);
    %
    %     eNorm = Evaluator(sigModNorm, modelNorm, 1);
    %     eNorm.DVE()
    
    %     c.plotPro(projection, sigMod);
    
    %     PRall = [0, 0];
    
    %     for j = 2: length(sigPro)-length(sigMod)
    %         pause;
    %         figure(1)
    %         plot(sigPro(1:length(sigMod)+j), 'r');
    %
    %         e = Evaluator(sigMod, model, prediction(1:j));
    %         pr = e.percentReturn(sigPro(1:length(sigMod)+j));
    %
    %         PRall = [PRall; pr, pr - PRall(end,1)];
    %
    %         pr
    %
    %         figure(2)
    %         clf
    %         plot(PRall(:,2),'ko', 'markers', 12)
    %         hold on
    %         if pr > 0
    %             plot(ones(length(PRall(:,2)),1)*pr,'g');
    %         else
    %             plot(ones(length(PRall(:,2)),1)*pr,'r');
    %         end
    %         plot(zeros(length(PRall(:,2)),1)*pr,'b');
    %
    %     end
    
    close all
    
    
end

PRall(:,2) = zeros(length(PRall),1);

PRall(1:length(PRall)-predLen,2) = PRall(predLen+1:length(PRall),1);

% [PRall(:,1)] = getFiltered(PRall(:,1), 0.1, 'low');
% [PRall(:,2)] = getFiltered(PRall(:,2), 0.1, 'low');

figure()
hold on
plot(PRall(:,1),'k')
plot(PRall(:,2),'b')
plot(zeros(length(PRall),1),'r')


[frq,amp,phi,ave,ssq,cnt] = sinide(PRall(1:400,1),1,0);

P = 1/frq;
A = amp;
theta = phi - pi/2;
ssq/1000;
    

c = Construction(A, P, theta, predLen, PRall(1:400,1));
[model, prediction, projection] = c.constructPro();
c.plotPro(projection, PRall(:,1));




sprintf('Done')


