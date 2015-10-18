% ae5

clear all; clc; close all;



toter = [];
PR = [];
angaliousSuperiomus = [];


stock = 'ADBE';
A = [1.33; 0.73];
P = [215.69; 314.29];
B = [102; 70];


day = 1000;
futer = 1000;
interval = 25;

predLen = 25;
dc_offset = 15;
sumoCumo = 200;



for i = 0:futer/interval
    present = day + i*interval
    
    angaliousMajor = [];
    present
    sampLen = 300;
    
    filtH = 0.0065;
    filtL = 0.0110;
    sMod = SignalGenerator(stock, present+2, present);
    [sig, sigHL, sigH, sigL] = sMod.getSignal('ac', filtH, filtL);
    
    sigMod = sigHL(present-sampLen:present)';
    
    sample = sigMod;
    [X1 Pds angles] = getFFT(sample);
    theta = [angles(B)];

    sigMod = sigMod + dc_offset;
    
    c = Construction(A, P, theta, predLen, sigMod);
    [model, prediction, projection] = c.constructPro();
    
    filtH = 0.0065;
    filtL = 0.0110;    
    sPro = SignalGenerator(stock, present+2+predLen+200, present+predLen+200);
    [sig, sigHL, sigH, sigL] = sPro.getSignal('ac', filtH, filtL);
    
    lenSPleft = 199+predLen+length(sigMod);
    lenSPright = 200;
    lenSMleft = lenSPleft;
    lenSMright = lenSPright + predLen;
    
    sigPro = sigHL(end-lenSPleft:end-lenSPright)+dc_offset;
    signalPro = sig(end-lenSPleft:end-lenSPright);
    
    sigModOP = sigH(end-lenSMleft:end-lenSMright)+dc_offset;
    sigTrendOP = sigL(end-lenSMleft:end-lenSMright);
    sigTrendOPshort = sigTrendOP(end-49:end);
    
    
    dervTrend = sum(diff(sigTrendOPshort));
    dervPred = sum(diff(prediction));

    
    sigTrendOPNorm = sigTrendOP - mean(sigTrendOP) + dc_offset;
    
    c.plotPro(projection, sigPro);
    title(present)
    hold on;
    plot(sigTrendOPNorm);
    
   
    c.plotPro((projection-dc_offset)+mean(signalPro), signalPro);
    title(present)
    hold on;
    plot(sigTrendOP);
%     pause
    
     
    filtEval = Evaluator(1, 1, sigPro(end-predLen:end));
    bandEval = Evaluator(sigModOP, model, prediction);
    [modDVE, modDVElist] = bandEval.DVE();
    mSumo = sum(modDVElist(end-(sumoCumo-1):end));
    
    dmp = diff(prediction');
    dsp = diff(sigPro(end-predLen:end));
    predDVElist = (dmp-dsp).^2;
    pSumo = sum(predDVElist);
    
    PR = [bandEval.percentReturn(sigPro),...
        bandEval.percentReturn(signalPro),...
        filtEval.percentReturn(signalPro)];
    
    tt = [present, mSumo, pSumo, dervTrend, dervPred, PR];
    
    toter = [toter; tt];
    
    
%     plot(sigMod-1,'k')
%     hold on;
%     plot(sigModOP+1,'r')
%     plot(sigPro,'g')
%     plot(signalPro)
%     pause
    
    
end



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


figure()

plot(pres,-1*mS/200,'k');
hold on;
% plot(pres,-1*pS,'b');
plot(negPR(:,1),negPR(:,2),'r*')
plot(neutPR(:,1),neutPR(:,2),'b*')
plot(posPR(:,1),posPR(:,2),'g*')
plot(pres,zeros(1,length(pres)));
plot(dvSame(:,1), dvSame(:,3)*25, 'cs');
plot(dvSame(:,1), dvSame(:,2)*25, 'ms');
% plot(dvSame2(:,1), dvSame2(:,3)*25, 'bs');
% plot(dvSame2(:,1), dvSame2(:,2)*15, 'rs');
hold off;

