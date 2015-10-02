clear all
clc
close all

presentH = 127
sigLen = 125;
predLen = 25;

totals = [];
sosals = [];
founder = [];

% stock = 'JPM'
% A = [0.23, 0.3, 0.53, 0.35, 0.3, 0.8, 0.56,  1.07, 1.16, 2.43];
% P = [  19,  24,   35,   40,  48,  63,   81,   103, 123,   221];
%

stock = 'ABT';
% A = [0.09 0.09 0.2 0.15 0.20 0.35 0.43 0.67];
% P = [18 25 34 43 62 99 142 178];

% stock = 'PEG';
% A = [0.106155871912528;0.190619933471946;0.307169276428061;0.219712179892408;0.327350418653880;0.390029790817962;0.418510291013449;0.7422];
% P = [13.1023765996344;25.5964285714286;38.8104693140794;33.7535321821036;47.4635761589404;86.6975806451613;75.4421052631579;125];

sFFT = SignalGenerator(stock, 2002, 2000);
[signal_pure, sigHL] = sFFT.getSignal('ac');

P = [178];
A = [0.67];
% t = 0:1999;
% signal_pure = A(1)*cos(2*pi/P(1)*t + 1); %+ A(2)*cos(2*pi/P(2)*t);

plot(signal_pure)

% sigMod = sigMod';



1/P(1)

errorPerPeriod = [];

for P = 10:10:200
    totalDVE = [];
    parfor i = 0:1:40
        
        present = presentH+i*50;
        
        sMod = SignalGenerator(stock, present, sigLen);
        [sig, sigHL, sigH, sigL] = sMod.getSignal('ac');
        % [b a] = butter(5,[0.001 0.04], 'bandpass');
        % sigMod = filtfilt(b,a,sig);
        sigMod = sig; %sigHL+mean(sig);
        
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
        % [b a] = butter(5,[0.005 0.04], 'bandpass');
        % sigPro = filtfilt(b,a,sig);
        sigPro = sig; %sigHL+mean(sig);
        
%         c.plotPro(projection, sigPro);
        
        e = Evaluator(sigMod, model, prediction);
        
        capture = [e.DVE()*10, e.percentReturn(sigPro), present];
        
        totalDVE = [totalDVE; capture];
        
    end
%     figure()
    dve = totalDVE(:,1);
    pr =  totalDVE(:,2);
%     i = totalDVE(:,3);
    
    capp = [sum(dve) ,sum(pr), P];
    errorPerPeriod = [errorPerPeriod; capp ];
    dve = [];
    pr = [];
end

figure()
plot(errorPerPeriod(:,3), errorPerPeriod(:,1))
figure()
plot(errorPerPeriod(:,3), errorPerPeriod(:,2))

% plot(i,dve, 'k');
% hold on;
% plot(i, pr, 'b');







%%
%
% clear all
% clc
% close all
%
%
% stock = 'ABT';
% A = [0.09 0.09 0.2 0.15 0.20 0.35 0.43 0.67];
% P = [18 25 34 43 62 99 142 178];
%
%
% present = 1700;
% sigLen = 1000;
% predLen = 100;
%
% totals = [];
% sosals = [];
% founder = [];
%
% sFFT = SignalGenerator(stock, 2002, 2000);
% [signal_pure, sigHL] = sFFT.getSignal('ac');
%
% % m = MoonFinder(signal_pure);
% % m.getAandP();
%
%
%
% % t = 0:199;
% % signal_pure = A(1)*cos(2*pi/P(1)*t + 1) + A(2)*cos(2*pi/P(2)*t);
% % length(t);
%
% A = 0.67;
% P = 178;
%
%
% 1/P(1)
%
%
% sMod = SignalGenerator(stock, present, sigLen);
% [sig, sigHL] = sMod.getSignal('ac');
% sigMod = sig;
%
% [b a] = butter(5,[0.005 0.05], 'bandpass');
% sigMod = filtfilt(b,a,sigMod);
%
% t = TideFinder(sigMod, A, P);
% t.type = 1;
% [theta] = t.getTheta('BF');
% c = Construction(A, P, theta, predLen, sigMod);
% [model, prediction, projection] = c.constructPro();
% conInt = [];
% for ci = 1:length(P)
%
%     cDays = length(model) + theta(ci)/(2*pi)*P(ci);
%     cDays =  mod(cDays, P(ci));
%     if cDays > P(ci)/2
%         cDays = P(ci) - cDays;
%     end
%     conInt = [conInt; cDays];
% end
% CItotal = sum(conInt(:,1)) / (sum(P)/2);
%
% c.plotPro(projection, sig1);
%
% e = Evaluator(sigMod, model, prediction);
% e.DVE()
%
%
%
%
%
%
%
%
% % sPro = SignalGenerator(stock, present+predLen, sigLen+predLen);
% % [sig, sigHL] = sPro.getSignal('ac');
% % sigPro = sigHL + mean(sig(end-100:end));
%
%
%
