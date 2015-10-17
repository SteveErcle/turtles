% anotherExperiment2

clear all; clc; close all;



toter = [];
PR = [];
angaliousSuperiomus = [];



% stock = 'JPM';
% A = [1.48 1.2]/5;
% P = [221, 309];
% B = [73 103];

% stock = 'MENT';
% A = [1.37, 0.75];
% P = [215.68, 305.55];
% B  = [102, 72];

stock = 'ADBE';
A = [1.33; 0.73];
P = [215.69; 314.29];
B = [102; 70];

day = 1000;
futer = 1000;
interval = 25;

predLen = 25;
dc_offset = 15;
sumoCumo = 50;

for i = 0:futer/interval
    present = day + i*interval
    
    
    angaliousMajor = [];
    present
    sampLen = 300;
    
    filtH = 0.0065;
    filtL = 0.0110;
    sFFT = SignalGenerator(stock, present+2, present);
    [sig, sigHL, sigH, sigL] = sFFT.getSignal('ac', filtH, filtL);
    
    sigMod = sigHL;
    
    ps = present-sampLen;
    
    sample = sigMod(ps:sampLen + ps)';
    %     sigMod = sample;
    
    fs = 1;
    x1 = sample;
    ss = length(x1);
    x1 = x1.*hanning(length(x1))';
    x1 = [x1 zeros(1, 20000)];
    angles = angle(fft(x1));
    X1 = abs(fft(x1));
    X1 = X1(1:ceil(length(X1)/2));
    X1 = X1/(ss/4);
    Xt = 0:length(X1)-1;
    [pkt It] = findpeaks(X1);
    
    
    angaliousMinor = [angles(B(1)), angles(B(2))]
    
    angaliousMajor = [angaliousMajor; angaliousMinor];
    
    angaliousMajor = angaliousMajor';
    
    sigMod = sigMod + dc_offset;
    
    
    model = A(1)*cos(2*pi*1/P(1)*(0)+angaliousMajor(1)) +...
        A(2)*cos(2*pi*1/P(2)*(0)+angaliousMajor(2));
    
    ac = 0;
    
    
   
    
 
    projection = [ model, (A(1)*cos(2*pi*1/P(1)*(1:sampLen+predLen)+angaliousMajor(1)+ac) +...
        A(2)*cos(2*pi*1/P(2)*(1:sampLen+predLen)+angaliousMajor(2)+ac))];
    
    
    projection = projection + dc_offset;
    
    
    
    c = Construction(1, 1, 1, predLen, sigMod);
    
    sFFT = SignalGenerator(stock, present+2+predLen+200, present+predLen+200);
    [sig, sigHL, sigH, sigL] = sFFT.getSignal('ac', filtH, filtL);
    
    sigPro = sigHL;
    
    sigPro = sigPro + dc_offset;
    
    sigPro = sigPro(1:length(sigMod)+predLen);
    
    projection = [dc_offset*ones(1,(length(sigPro)-length(projection))),...
        projection];
    
   mean(model)
    mean(projection)
    
    length(projection)
    
    cheaterSigMod = sigPro(1:length(sigMod));
    
    signalPro = sig(1:length(sigMod)+predLen);
    
    modelExtender = projection(1:end-predLen);
    
    prediction = projection(end-(predLen-1):end);
    
    sigTrend = sigL(1:length(cheaterSigMod));
    
    
    
    
    sigPro;
    signalPro;
    cheaterSigMod;
    sigTrend;
    modelExtender;
    prediction;
    
    
    
    sigTrendNorm = (sigTrend-min(sigTrend))/ range(sigTrend)+dc_offset;
    
    c.plotPro(projection, sigPro);
    title(present)
    hold on;
    plot(sigTrend);
    
    c.plotPro((projection-dc_offset)+mean(signalPro), signalPro);
    title(present)
    hold on;
    plot(sigTrend);
    
    pause 
    
    
    filtEval = Evaluator(1, 1, sigPro(end-(predLen-1):end));
    
    bandEval = Evaluator(cheaterSigMod, modelExtender, prediction);
    [modDVE, modDVElist] = bandEval.DVE();
    mSumo = sum(modDVElist(end-(sumoCumo-1):end));
    
    dmp = diff(prediction');
    dsp = diff(sigPro(end-(predLen-1):end));
    predDVElist = (dmp-dsp).^2;
    pSumo = sum(predDVElist);
    
    PR = [bandEval.percentReturn(sigPro),...
        bandEval.percentReturn(signalPro),...
        filtEval.percentReturn(signalPro)]
    
    bandEval.percentReturn(signalPro);
    
    cheaterSigLShort = sigL(end-200-(predLen*2):end-200-predLen);
    dervTrend = sum(diff(cheaterSigLShort));
    dervPred = sum(diff(prediction));
    
    tt = [present, mSumo, pSumo, dervTrend, dervPred, PR];
    
    toter = [toter; tt];
    
    aif = [angaliousMajor(1), angaliousMajor(2)];
    angaliousSuperiomus = [angaliousSuperiomus; aif];
    
    
    
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

plot(pres,-1*mS,'k');
hold on;
% plot(pres,-1*pS,'b');
plot(negPR(:,1),negPR(:,2),'r*')
plot(neutPR(:,1),neutPR(:,2),'b*')
plot(posPR(:,1),posPR(:,2),'g*')
plot(pres,zeros(1,length(pres)));
% plot(dvSame(:,1), dvSame(:,3)*25, 'cs');
% plot(dvSame(:,1), dvSame(:,2)*25, 'ms');
plot(dvSame2(:,1), dvSame2(:,3)*25, 'bs');
plot(dvSame2(:,1), dvSame2(:,2)*15, 'rs');

% plot(pres,band*5, 'k');
% plot(pres,actual, 'c');
% plot(pres,filtv, 'm')
hold off;







