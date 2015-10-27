
% sinreTestMultiplePeriods

clear all
close all
clc


addpath('/Users/Roccotepper/Documents/turtles/TurtleData')
addpath('/Users/Roccotepper/Documents/turtles/sinide')

stock = 'JPM'


day = 1000;
futer = 1000;
interval = 25

predLen = 25;
sampLen = 50;
dc_offset = 15;

dataliousMajor = [];
dataliousMinor = [];

expectoProptronum = [];

% theSamples = [25, 120, 300]


parfor i = 0:futer/interval
    present = day + i*interval
    
    expectoProptronum = [];
    
    for sampLen = 500:100:500
        
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
        
        props = [P, A, theta, sampLen];
        
        expectoProptronum = [expectoProptronum; props];
        
        c = Construction(A, P, theta, predLen, sigMod);
        [model, prediction, projection] = c.constructPro();
        %         c.plotPlay(projection, sigPro);
        c.plotPro(projection, sigPro);
        hold on;
        plot(sigMod,'m')
        
        
        
    end
    
    P = expectoProptronum(:,1);
    A = expectoProptronum(:,2);
    theta = expectoProptronum(:,3);
    sampLens = expectoProptronum(:,4);
    
    if (sum(P == 1) < 1)
        
        [thetaShift] = shiftTheta(P, sampLens, theta);
        
        sMod = SignalGenerator(stock, present+2, min(sampLens));
        [sigMod, sigHL, sigH, sigL] = sMod.getSignal('ac', filtH, filtL);
        sPro = SignalGenerator(stock, present+2+predLen, min(sampLens)+predLen);
        [sigPro, sigHL, sigH, sigL] = sPro.getSignal('ac', filtH, filtL);
        
        %         for i = 1:length(sampLens)
        %             c = Construction(A(i), P(i), thetaShift(i), predLen, sigMod);
        %             [model, prediction, projection] = c.constructPro();
        %             %     c.plotPlay(projection, sigPro);
        %             c.plotPro(projection-mean(projection) + mean(sigPro), sigPro);
        %             hold on;
        %             plot(sigMod,'m')
        %         end
        %
        %         theta
        %         thetaShift
        
        P
        
        c = Construction(A, P, thetaShift, predLen, sigMod);
        [model, prediction, projection] = c.constructPro();
        %     c.plotPlay(projection, sigPro);
        
        pause;
        c.plotPro(projection-mean(projection) + mean(sigPro), sigPro);
        hold on;
        plot(sigMod,'m')
        
        
        e = Evaluator(sigMod, model, prediction);
        pr = e.percentReturn(sigPro)
        [modDVE, modList] = e.DVE();
        
        posList = (model-sigMod').^2;
        pSumo = sum(posList);
        
        
        dataliousMinor = [i, present, pr, P];
        
        dataliousMajor = [dataliousMajor; dataliousMinor];
        
        pause
        
        close all
        
        
    end
    
end

sprintf('Done')


