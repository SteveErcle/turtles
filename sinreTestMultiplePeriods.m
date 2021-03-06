
% sinreTestMultiplePeriods

clear all
close all
clc


addpath('/Users/Roccotepper/Documents/turtles/TurtleData')
addpath('/Users/Roccotepper/Documents/turtles/sinide')

stock = 'JPM'


day = 1502;
futer = 1000;
interval = 31

predLen = 1;
sampLen = 50;
dc_offset = 15;

dataliousMajor = [];
dataliousMinor = [];
totalious = [];

expectoProptronum = [];

% theSamples = [25, 120, 300]

for i = 0:futer/interval
    present = day + i*interval
    
    expectoProptronum = [];
    
    for sampLen = 50:100:50
        
        filtL = 0.0550;
        filtH = 0.0065;
        
        sMod = SignalGenerator(stock, present+2, sampLen);
        [sigMod, sigHL, sigH, sigL] = sMod.getSignal('c', filtH, filtL);
        sVol = SignalGenerator(stock, present+2, sampLen);
        [vol] = sVol.getSignal('v', filtH, filtL);
        
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
        %         c.plotPro(projection, sigPro);
        %         hold on;
        %         plot(sigMod,'m')
        
        
        
    end
    
    P = expectoProptronum(:,1);
    A = expectoProptronum(:,2);
    theta = expectoProptronum(:,3);
    sampLens = expectoProptronum(:,4);
    
    if (sum(P == 1) < 1)
        
        [thetaShift] = shiftTheta(P, sampLens, theta);
        
        sMod = SignalGenerator(stock, present+2, min(sampLens));
        [sigMod, sigHL, sigH, sigL] = sMod.getSignal('c', filtH, filtL);
        sPro = SignalGenerator(stock, present+2+predLen, min(sampLens)+predLen);
        [sigPro, sigHL, sigH, sigL] = sPro.getSignal('c', filtH, filtL);
        
        
        sMtx = SignalGenerator(stock, present+2+predLen, min(sampLens)+predLen);
        [sigMtx, sigHL, sigH, sigL] = sMtx.getSignal('all', filtH, filtL);
        
        
        c = Construction(A, P, thetaShift, predLen, sigMod);
        [model, prediction, projection] = c.constructPro();
        
        spPasto = sigMtx(end-predLen-10:end-predLen,1);
        spPasth = sigMtx(end-predLen-10:end-predLen,2);
        spPastl = sigMtx(end-predLen-10:end-predLen,3);
        spPastc = sigMtx(end-predLen-10:end-predLen,4);
        spPastt = length(sigPro)-(predLen)-10:length(sigPro)-predLen;
        
        spo = sigMtx(end-(predLen-1):end,1);
        sph = sigMtx(end-(predLen-1):end,2);
        spl = sigMtx(end-(predLen-1):end,3);
        spc = sigMtx(end-(predLen-1):end,4);
        spt = length(sigPro)-(predLen-1):length(sigPro);
        
        spmh = max(sigMtx(end-(predLen-1):end,2));
        spml = min(sigMtx(end-(predLen-1):end,3));
        
        speo = sigMtx(end-(predLen-1),1);
        spec = sigMtx(end,4);
        
        if prediction(end) > prediction(1)
            111
            totalious = [totalious; (spmh - speo)/speo*100 , (spml - speo)/speo*100, (spec - speo)/speo*100, i]
        else
            222
            totalious = [totalious; (speo - spml)/speo*100 ,(speo - spmh)/speo*100, (speo - spec)/speo*100, i]
        end
        
        
%         c.plotPro(projection-mean(projection) + mean(sigPro), sigMod);
%         
%         for ii = predLen:-1:0
%         
%         hold on;
%         %         plot(sigMod,'m')
%         plot(spt(1:end-ii),spo(1:end-ii),'ro')
%         pause;
%         plot(sigPro(1:end-ii),'r')
%         plot(spt(1:end-ii),sph(1:end-ii),'k+')
%         plot(spt(1:end-ii),spl(1:end-ii),'ks')
%         
%         plot(spt(1:end-ii),spc(1:end-ii),'x', 'color', [0, 0.65, 0])
%         plot(spt(1),speo,'ro');
%         plot(spPastt,spPastc, 'x', 'color', [0, 0.65, 0], 'markers', 7)
%         plot(spPastt,spPasto,'ro', 'markers', 7)
%         plot(spPastt,spPasth,'k+', 'markers', 7)
%         plot(spPastt,spPastl,'ks', 'markers', 7)
%         
%         hold off
%         
%         drawnow
%         
%         pause
%         
%         end 
        
        e = Evaluator(sigMod, model, prediction);
        pr = e.percentReturn(sigPro)
        [modDVE, modList] = e.DVE();
        
        posList = (model-sigMod').^2;
        pSumo = sum(posList);
        
        
        dataliousMinor = [i, present, pr];
        
        dataliousMajor = [dataliousMajor; dataliousMinor];
        
%         pause
        
%         close all
        
        
    end
    
end

sprintf('Done')

stopLoss = -1;
stopLimit = 5;

TotalSum = [];

for stopLimit = 3:0.25:10
    for stopLoss = -0.25:-0.25:-3
        
        totaliousMajor = [];
        
        for i = 1:length(totalious)
            if totalious(i,2) <= stopLoss;
                totaliousMajor = [totaliousMajor; stopLoss];
                
            elseif totalious(i,1) >= stopLimit;
                totaliousMajor = [totaliousMajor; stopLimit];
            else
                totaliousMajor = [totaliousMajor; totalious(i,3)];
            end
            
        end
        
        TotalSum = [TotalSum; sum(totaliousMajor), stopLimit, stopLoss];
        
    end
end


TotalSum = sortrows(TotalSum,-1);

totalious = sortrows(totalious,-1);



