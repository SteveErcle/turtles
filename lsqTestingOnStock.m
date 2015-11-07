close all
clear
clc

addpath('/Users/Roccotepper/Documents/turtles/TurtleData')
addpath('/Users/Roccotepper/Documents/turtles/sinide')


filtL = 0.1;
filtH = 0.0065;
stock = 'JPM'
present = 2400;
sampLen = 500;
predLen = 50;
interval = 50;

day = 2000;
futer = 500;


for i = 0:futer/interval
    present = day + i*interval
    
    sMod = SignalGenerator(stock, present+2, sampLen);
    [sig, sigHL, sigH, sigL] = sMod.getSignal('c', filtH, filtL);
    
    sigMod = sig;
    %     plot(sigMod)
    %     drawnow
    
    foundP = [209 121 81 62 41 33 22 8];
    theta = [1,2,3,4,5,6,7,8];
    t = (0:length(sigMod)-1).';
    
    
    fun = @(x)loopClosure(theta, t, sigMod, x);
    
    resMajor = [];
    
    parfor i = 1:100
        
        i
        
        guess      = zeros(length(theta),3);
        guess(:,1) = rand(length(theta),1)*5;
        %     guess(:,2) = rand(length(theta),1)*150;
        guess(:,2) = foundP % + ((-0.5+rand(1,length(foundP)))*2)*10
        %     guess(end,2) = 5;
        guess(:,3) = rand(length(theta),1)*2*pi;
        guess = guess';
        guess = guess(:);
        guess(end+1) = mean(sigMod);
        
        x0 = [guess'];
        
        lb = [];
        ub = [];
        options = optimset('Display', 'off');
        
        [x, resnorm] = lsqnonlin(fun, x0, lb, ub, options);
        
        
        resMinor = [resnorm , x];
        resMajor = [resMajor; resMinor];
        
    end
    
    
    
    sPro = SignalGenerator(stock, present+2+predLen, sampLen+predLen);
    [sigPro, sigHL, sigH, sigL] = sPro.getSignal('c', filtH, filtL);
    
    
    
    resMajor = sortrows(resMajor,1);
 
    x = resMajor(1,2:end);
    xReshaped = reshape(x(1:end-1),3,length(theta));
    A = xReshaped(1,:);
    P = xReshaped(2,:);
    theta = xReshaped(3,:);
    
    c = Construction(A, P, theta, predLen, sigMod);
    [model, prediction, projection] = c.constructPro();
    c.plotPro(projection-mean(projection), sigPro-mean(sigPro));
    
    %     sprintf('Properties found via sorting resnorm')
    %     display([A',P',theta'])
    
    display([sort(foundP'), sort(P')]);
    sum(abs(sort(foundP') - sort(P')))
    resMajor(1:3,1)
    
    
    
    deltaSum = [];
    for i = 1:size(resMajor,1)
        resP = resMajor(i,3:3:size(resMajor,2));
        selectedP = sortrows(abs(resP)',-1);
        deltaP = abs(selectedP-foundP');
        deltaSum = [deltaSum; sum(deltaP),resMajor(i,:)];
    end
    
    
    deltaSum = sortrows(deltaSum,1);
    deltaSum = deltaSum(:,2:end);
    
    x = deltaSum(1,2:end);
    xReshaped = reshape(x(1:end-1),3,length(theta));
    A = xReshaped(1,:);
    P = xReshaped(2,:);
    theta = xReshaped(3,:);
    
     display([sort(foundP'), sort(P')]);
     sum(abs(sort(foundP') - sort(P')))
    
    
    
    c = Construction(A, P, theta, predLen, sigMod);
    [model, prediction, projection] = c.constructPro();
    c.plotPro(projection-mean(projection), sigPro-mean(sigPro));
    
    %     sprintf('Properties found via sorting deltaSum')
    %     display([A',P',theta'])
    
    
    pause;
    close all;
    
end

% figure()
% plot(resMajor(:,1))




% [frq,amp,phi,ave,ssq,cnt] = sinide(sigMod,1,0);
%
% P = 1/frq;
% A = amp;
% theta = phi - pi/2;
% ssq/1000;
%
% props = [P, A, theta, sampLen];
%
% c = Construction(A, P, theta, predLen, sigMod);
% [model, prediction, projection] = c.constructPro();
% c.plotPro(projection, sigPro);
%
% sprintf('Properties found via sinide')
% display([A;P;theta])



% sFFT = SignalGenerator(stock, present+2, 2000);
% [sigFFT, sigHL, sigH, sigL] = sFFT.getSignal('c', filtH, filtL);
%
% m = MoonFinder(sigFFT);
% m.getAandP();

