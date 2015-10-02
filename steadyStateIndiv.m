clear all
clc
close all

presentH = 600
sigLen = 125;
predLen = 25;

totals = [];
sosals = [];
founder = [];


stock = 'ABT';
% A = [0.09 0.09 0.2 0.15 0.20 0.35 0.43 0.67];
% P = [18 25 34 43 62 99 142 178];


sFFT = SignalGenerator(stock, 2002, 2000);
[signal_pure, sigHL] = sFFT.getSignal('ac');
% [b a] = butter(5,[0.01 0.04], 'bandpass');
% signal_pure = filtfilt(b,a,signal_pure);

plot(signal_pure)

P = [178];
A = [.67];

plot(signal_pure)


totalDVE = [];
parfor i = 0:1:35*5
    present = presentH+i*10;


% for present = 200 : 10 : 2000
    
    sMod = SignalGenerator(stock, present, sigLen);
    [sig, sigHL, sigH, sigL] = sMod.getSignal('ac');
    [b a] = butter(5,[0.001 0.04], 'bandpass');
    sigMod = filtfilt(b,a,sig) + mean(sig)
%     sigMod = sigHL+mean(sig);
    
    t = TideFinder(sigMod, A, P);
    t.type = 1;
    [theta] = t.getTheta('BF');
    c = Construction(A, P, theta, predLen, sigMod);
    [model, prediction, projection] = c.constructPro();
    conInt = [];
    for ci = 1:length(P)
        
        cDays = length(model) + theta(ci)/(2*pi)*P(ci);
        cDays =  mod(cDays, P(ci));
        if cDays > P(ci)/2
            cDays = P(ci) - cDays;
        end
        conInt = [conInt; cDays];
    end
    CItotal = sum(conInt(:,1)) / (sum(P)/2);
    
    sPro = SignalGenerator(stock, present+predLen, sigLen+predLen);
    [sig, sigHL, sigH, sigL] = sPro.getSignal('ac');
    [b a] = butter(5,[0.001 0.04], 'bandpass');
    sigPro = filtfilt(b,a,sig) + mean(sig)
%     sigPro = sigHL+mean(sig);
    
    
    fs = 1;
    x1 = sig';
    ss = length(x1);
    % x1 = x1.*hanning(length(x1))';
    % x1 = [x1 zeros(1, 20000)];
    X1 = abs(fft(x1));
    X1 = X1(1:ceil(length(X1)/2));
%     
%     Xt = 0:length(X1)-1;
%     P = fs./ (Xt*(fs/length(x1)));
    [pkt It] = findpeaks(X1);
    
    c.plotPro(projection, sigPro);
    
    e = Evaluator(sigMod, model, prediction);
    
    capture = [e.DVE(), e.percentReturn(sigPro), sum(pkt), present];
    
    totalDVE = [totalDVE; capture];
    
end

figure()
dve = totalDVE(:,1);
pr =  totalDVE(:,2);
pks = totalDVE(:,3);
i = totalDVE(:,4);

figure()
plot(i,dve*70, 'k');
hold on;
% plot(i, pr, 'b');
plot(i,pks, 'm')



% sFFTtest = SignalGenerator(stock, 200, 100);
% [sig, sigHL, sigH, sigL] = sFFTtest.getSignal('ac');


