% anotherExperiment2

clear all; clc; close all;

y = [];
angaliousMajor = [];
toter = [];
PR = [];

% stock = 'ABT';
% A = [0.48, 0.38, 0.36];
% P = [222 171, 286];
% B = [102 132 76];
% 
% A = [0.13, 0.06, 0.04];
% P = [169 221 147]
% B = [134 103 154];

stock = 'PG';
A = [1.25, 0.80];
P = [268 216]
B = [85 105];


day = 1000
futer = 1000

dc_offset = 10;

for present = day : 25 : day + futer
    
    predLen = 100;
    
    sFFT = SignalGenerator(stock, present+2, present);
    [sig] = sFFT.getSignal('ac');
    
    filtL = 0.0110;
    filtH = 0.0110;
    sigH = getFiltered(sig, filtH, 'high');
    sigL = getFiltered(sig, filtL, 'low');
    sigHL = getFiltered(sigH, filtL, 'low');
    sigMod = sigHL;
    
    sampLen = 300;
    
    ps = present-sampLen;
    
    
    parfor i = 1:ps
        
        sample = sigMod(i:sampLen + i)';
        
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
        P = fs./ (Xt*(fs/length(x1)));
        [pkt It] = findpeaks(X1);
        
        
        angaliousMinor = [angles(B(1)), angles(B(2))]; %angles(B(3))];
        
        angaliousMajor = [angaliousMajor; angaliousMinor];
        
        
    end
    
    angaliousMajor = angaliousMajor';
    
    sigMod = sigMod + dc_offset;
    
    model1 = A(1)*cos(2*pi*1/P(1)+angaliousMajor(1,:));
    
    model = A(1)*cos(2*pi*1/P(1)+angaliousMajor(1,:)) +...
        A(2)*cos(2*pi*1/P(2)+angaliousMajor(2,:));
%         A(3)*cos(2*pi*1/P(3)+angaliousMajor(3,:));
    
    ac = 0;
    
    projection1 = [ model1, A(1)*cos(2*pi*1/P(1)*(0:sampLen-1+predLen)+angaliousMajor(1,end)+ac) ];
    
    
    projection = [ model, (A(1)*cos(2*pi*1/P(1)*(0:sampLen-1+predLen)+angaliousMajor(1,end)+ac) +...
        A(2)*cos(2*pi*1/P(2)*(0:sampLen-1+predLen)+angaliousMajor(2,end)+ac))];
        %A(3)*cos(2*pi*1/P(3)*(0:sampLen-1+predLen)+angaliousMajor(3,end)+ac))];
    
    
    projection1 = projection1 + dc_offset;
    projection = projection + dc_offset;
    
    c = Construction(1, 1, 1, predLen, sigMod);
    
    
    
    sFFT = SignalGenerator(stock, present+2+predLen+200, present+predLen+200);
    [sig] = sFFT.getSignal('ac');
    
    sigH = getFiltered(sig, filtH, 'high');
    sigL = getFiltered(sig, filtL, 'low');
    sigHL = getFiltered(sigH, filtL, 'low');
    sigPro = sigHL;
    
    sigPro = sigPro + dc_offset;
    
    sigPro = sigPro(1:length(projection));
    
    cheaterSigMod = sigPro(1:length(sigMod));
    
    signalPro = sig(1:length(projection));
    
    modelExtender = projection(1:length(sigMod));
    
    prediction = projection(end-(predLen-1):end);
    
    sigPro;
    signalPro;
    cheaterSigMod;
    modelExtender;
    prediction;
    
    c.plotPro(projection, sigPro);
    title('Band')
%     c.plotPro(projection-dc_offset+mean(signalPro), signalPro);
%     title('Actual')
%     c.plotPro(sigPro-dc_offset+mean(signalPro), signalPro);
%     title('Filt vs Unfilt')
%     hold on;
%     plot(projection1, 'c');
    
    
    filtEval = Evaluator(1, 1, sigPro(end-(predLen-1):end));
    
    bandEval = Evaluator(cheaterSigMod, modelExtender, prediction);
    [modDVE, modDVElist] = bandEval.DVE();
    mSumo = sum(modDVElist(end-199:end));
    
    dmp = diff(prediction');
    dsp = diff(sigPro(end-(predLen-1):end));
    predDVElist = (dmp-dsp).^2;
    pSumo = sum(predDVElist);
    
    PR = [bandEval.percentReturn(sigPro),...
        bandEval.percentReturn(signalPro),...
        filtEval.percentReturn(signalPro)]
    
    toter = [toter; present, mSumo, pSumo, PR];
    
    
    angaliousMajor = [];
    
    
end

close all
pres = toter(:,1);
mS = toter(:,2)*2000;
pS = toter(:,3)*4000;
band = toter(:,4);
actual = toter(:,5);
filtv = toter(:,6);
figure()
plot(pres,-1*mS,'k');
hold on;
plot(pres,-1*pS,'b');
hold on;
plot(pres,band,'g');
hold on;
plot(pres,actual,'c');
hold on;
plot(pres,filtv,'m');
legend('model','pred','band','actual','filtv')








