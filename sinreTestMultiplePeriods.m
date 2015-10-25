
% sinreTestMultiplePeriods

clear all
close all
clc


addpath('/Users/Roccotepper/Documents/turtles/TurtleData')
addpath('/Users/Roccotepper/Documents/turtles/sinide')

stock = 'JPM'


day = 1000;
futer = 1000;
interval = 50


predLen = 50;
sampLen = 50;
dc_offset = 15;

dataliousMajor = [];
dataliousMinor = [];

expectoProptronum = [];


for i = 0:futer/interval
    present = day + i*interval
    
    for sampLen = 100:105:515
        
        filtL = 0.0550;
        filtH = 0.0065;
        
        sMod = SignalGenerator(stock, present+2, sampLen);
        [sigMod, sigHL, sigH, sigL] = sMod.getSignal('ac', filtH, filtL);
        sVol = SignalGenerator(stock, present+2, sampLen);
        [vol] = sVol.getSignal('v', filtH, filtL);
        
        
        sPro = SignalGenerator(stock, present+2+predLen, sampLen+predLen);
        [sigPro, sigHL, sigH, sigL] = sPro.getSignal('ac', filtH, filtL);
        
        
        [frq,amp,phi,ave,ssq,cnt] = sinide(sigMod,1,0);
        
        P = 1/frq;
        A = amp;
        theta = phi - pi/2;
        ssq/1000;
        
        expectoProptronum = [expectoProptronum; P, A, theta, sampLen];
        
        c = Construction(A, P, theta, predLen, sigMod);
        [model, prediction, projection] = c.constructPro();
        %     c.plotPlay(projection, sigPro);
%         c.plotPro(projection, sigPro);
%         hold on;
%         plot(sigMod,'m')
        
        
        
    end
    
    
    P = expectoProptronum(:,1)
    A = expectoProptronum(:,2);
    theta = expectoProptronum(:,3)
    sampLens = expectoProptronum(:,4);
    
    [thetaShift] = shiftTheta(P, sampLens, theta)
    
    sigMod = sigMod(end-(min(sampLens)-1):end);
    sigPro = sigPro(end-(min(sampLens)-1)-predLen:end);
    
    c = Construction(A, P, thetaShift, predLen, sigMod);
    [model, prediction, projection] = c.constructPro();
    %     c.plotPlay(projection, sigPro);
    c.plotPro(projection-mean(projection) + mean(sigPro), sigPro);
    hold on;
    plot(sigMod,'m')
    
    
    expectoProptronum = [];
    
%     pause
    
%     close all
    
    
end




