% ae5

clear all; clc; close all;



toter = [];
PR = [];
angaliousSuperiomus = [];


% stock = 'ADBE';
% A = [1.33; 0.73];
% P = [215.69; 314.29];
% B = [102; 70];

% stock = 'MENT';
% A = [1.37, 0.75]/2;
% P = [215.68, 305.55];
% B  = [102, 72];

% stock = 'HON';
% A = [1.45;0.66];
% P = [234;310];
% B = [94;71];

% stock = 'GS';
% A = [1.04, 1.02];
% B = [70 101];
% P = [314 218];

stock = 'JPM';
A = [.45 .45 .45 .78 .88];
P = [32 41 52 62 82];
B = [270 356 422 535 665];



day = 1000;
futer = 1500;
interval = 25;

predLen = 25;
dc_offset = 15;
sumoCumo = 75 ;



for i = 0:futer/interval
    present = day + i*interval
    
    angaliousMajor = [];
    present
    sampLen = 300;
    
    filtL = 0.1100;
    filtH = 0.0210;
    sMod = SignalGenerator(stock, present+2, present);
    [sig, sigHL, sigH, sigL] = sMod.getSignal('ac', filtH, filtL);
    
    plot(sig)
    signalMod = sig(present-sampLen:present);
    sigMod = sigHL(present-sampLen:present)';
    
    sample = sigMod;
    [X1 Pds angles] = getFFT(sample);
    theta = [angles(B)];
    
    sigMod = sigMod + dc_offset;
    
    c = Construction(A, P, theta, predLen, sigMod);
    [model, prediction, projection] = c.constructPro();
    dervPred = sum(diff(prediction));
    
    
    
    filtH = 0.0065;
    filtL = 0.0500;
    sGreen = SignalGenerator(stock, present+2, present);
    [sig, sigHL, sigH, sigL] = sGreen.getSignal('ac', filtH, filtL);
    
    sigGreen = (sigHL(present-sampLen:present) + dc_offset).';
    
    filtH = 0.0065;
    filtL = 0.0500;
    sTrend = SignalGenerator(stock, present+2, present);
    [sig, sigHL, sigH, sigL] = sTrend.getSignal('ac', filtH, filtL);
    
    trendLen = 50;
    sigTrend = sigL(present-sampLen:present);
    sigTrend(end-(trendLen-1):end) = linspace(sigTrend(end-(trendLen-1)), sigTrend(end), trendLen);
    dervTrend = diff(sigTrend(end-1:end));
    sigTrendNorm = sigTrend - mean(sigTrend); 
    sigTrendNorm = sigTrendNorm/std(sigTrendNorm) + dc_offset;
    
    
    
    filtH = 0.0065;
    filtL = 0.0500;
    sPro = SignalGenerator(stock, present+2+predLen+10, present+predLen+10);
    [sig, sigHL, sigH, sigL] = sPro.getSignal('ac', filtH, filtL);
    
    lenSPleft = 9+predLen+length(sigMod);
    lenSPright = 10;
    lenSMleft = lenSPleft;
    lenSMright = lenSPright + predLen;
    
    sigPro = sigHL(end-lenSPleft:end-lenSPright)+dc_offset;
    signalPro = sig(end-lenSPleft:end-lenSPright);

    filtEval = Evaluator(1, 1, sigPro(end-predLen:end));
    bandEval = Evaluator(sigGreen', model, prediction);
    [modDVE, modDVElist] = bandEval.DVE();
    mSumo = sum(modDVElist(end-(sumoCumo-1):end));
    
    dmp = diff(model');
    dsp = diff(sigGreen');
    predDVElist = (dmp-dsp).^2;
    pSumo = sum(predDVElist);
    
    PR = [bandEval.percentReturn(sigPro),...
        bandEval.percentReturn(signalPro),...
        filtEval.percentReturn(signalPro)];
    
  
    tt = [present, mSumo, pSumo, dervTrend, dervPred, PR];
    
    toter = [toter; tt];
    
   
    
    if (present >= 2500)
        
        
        
        
        PR = toter(:,end-1); % actual return
        % PR = toter(:,end-2); % band return
        pres = toter(:,1);
        dvp = toter(:,end-3);
        dvt = toter(:,end-4);
        posRet = 10;
        
        
        
        % dvpNorm2 = dvp-mean(dvp);
        % dvpNorm2 = dvpNorm2/std(dvpNorm2);
        % dvtNorm2 = dvt-mean(dvt);
        % dvtNorm2 = dvtNorm2/std(dvtNorm2);
        % dvpNorm2 = dvp/mean(dvp)
        dvpNorm2 = dvp;
        dvtNorm2 = dvt;
        dvI2 = [(find( dvtNorm2 > 0 & dvpNorm2 > 0)); (find( dvtNorm2 <= 0 & dvpNorm2 <= 0))];
        dvV2 = [dvtNorm2(dvI2),dvpNorm2(dvI2)];
        dvSame2 = [pres(dvI2), dvV2];
        
        dvpNorm = (dvp-min(dvp))/ range(dvp)-0.5;
        dvtNorm = (dvt-min(dvt))/ range(dvt)-0.5;
        dvI = [(find( dvtNorm > 0 & dvpNorm > 0)); (find( dvtNorm <= 0 & dvpNorm <= 0))];
        dvV = [dvtNorm(dvI),dvpNorm(dvI)];
        dvSame = [pres(dvI), dvV];
        
        negPR = [pres(find( PR<0 )), PR( PR<0 )];
        
        neutPR = [pres(find( PR>=0 & PR<=posRet )), PR( PR>=0 & PR<=posRet )];
        
        posPR = [pres(find( PR>posRet )), PR( PR>posRet )];
        
        pres = toter(:,1);
        mS = toter(:,2)*100;
        pS = toter(:,3)*100;
        
        band = toter(:,end-2);
        actual = toter(:,end-1);
        filtv = toter(:,end);
        
        c.plotPro(projection, sigGreen);
        title(present)
        hold on;
        plot(sigTrendNorm);
        hold off;
        
        c.plotPro(4*(projection-dc_offset)+mean(signalMod), signalMod);
        title(present)
        hold on;
        plot(sigTrend);
        pause
        hold off;
  
        mS = mS - mean(mS);
        mS = mS/std(mS)*5+10;
        mS = mS*2;
        pS = pS - mean(pS);
        pS = pS/std(pS)*5+10;
        pS = pS*2;
        
        
       
        figure()
        
        plot(pres,-1*mS,'k');
        hold on;
        plot(pres,-1*pS,'b');

        plot(pres,zeros(1,length(pres)));
        plot(dvSame(:,1), dvSame(:,3)*25, 'cs');
        plot(dvSame(:,1), dvSame(:,2)*25, 'ms');
        % plot(dvSame2(:,1), dvSame2(:,3)*25, 'bs');
        % plot(dvSame2(:,1), dvSame2(:,2)*15, 'rs');
        
        
        
        if (negPR(end,1) == present)
            plot(negPR(1:end-1,1),negPR(1:end-1,2),'r*')
            plot(neutPR(:,1),neutPR(:,2),'b*')
            plot(posPR(:,1),posPR(:,2),'g*')
            pause
            plot(negPR(end,1),negPR(end,2),'r*')
        
            
        elseif (neutPR(end,1) == present)
  
            plot(neutPR(1:end-1,1),neutPR(1:end-1,2),'b*')
            plot(posPR(:,1),posPR(:,2),'g*')
            plot(negPR(:,1),negPR(:,2),'r*')
            pause
            plot(neutPR(end,1),neutPR(end,2),'b*')
            
        elseif (posPR(end,1) == present)
    
            plot(posPR(1:end-1,1),posPR(1:end-1,2),'g*')
            plot(neutPR(:,1),neutPR(:,2),'b*')
            plot(negPR(:,1),negPR(:,2),'r*')
            pause
            plot(posPR(end,1),posPR(end,2),'g*')
            
        end
        
   
        hold off; 
        
        pause;
        
        c.plotPro((projection-dc_offset)+mean(signalPro), signalPro);
        title(present)
        hold on;
        plot(sigTrend);
        pause
        hold off;
        
        
        
   
    
%     close all;
%     
        
    end
    
    
    
end


toter = [];
PR = [];
angaliousSuperiomus = [];


day = 1000;
futer = 2500-day;
interval = 1;

predLen = 100;
dc_offset = 15;


angaliousMajor = [];


parfor i = 0:futer/interval
    present = day + i*interval
    
    
    present
    sampLen = 100;
    
    filtL = 0.1100;
    filtH = 0.0210;
    sMod = SignalGenerator(stock, present+2, present);
    [sig, sigHL, sigH, sigL] = sMod.getSignal('ac', filtH, filtL);
    
    
    signalMod = sig(present-sampLen:present);
    sigMod = sigHL(present-sampLen:present)';
    
    sample = sigMod;
    [X1 Pds angles] = getFFT(sample);
    theta = [angles(B)];
    
    sigMod = sigMod + dc_offset;
    
    c = Construction(A, P, theta, predLen, sigMod);
    [model, prediction, projection] = c.constructPro();
    
    angaliousMajor = [angaliousMajor; theta];
    
end

filtL = 0.1100;
filtH = 0.0210;
present = 1000;
sMod = SignalGenerator(stock, day+futer+2, futer);
[sig, sigHL, sigH, sigL] = sMod.getSignal('ac', filtH, filtL);

figure()

plot(angaliousMajor)
hold on;
plot(sig-mean(sig),'k')






