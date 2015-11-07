clear all
clc
close all

presentH = 1000
sigLen =  900;
predLen = 50;

totals = [];
sosals = [];
founder = [];


stock = 'ABT';
% A = [0.09 0.09 0.2 0.15 0.20 0.35 0.43 0.67];
% P = [18 25 34 43 62 99 142 178];

% A = [0.09 0.15 0.35 0.43 0.67];
% P = [18 43 99 142 178];

sFFT = SignalGenerator(stock, 2002, 2000);
[signal_pure, sig_pure_HL, sph, spl] = sFFT.getSignal('ac');
 

P = [178]; 
A = [0.67];

plot(spl, 'r')

keeper = [];

parfor i = 0:1:100
    present = presentH+i*10;
    
    sMod = SignalGenerator(stock, present, sigLen);
    [sig, sigHL, sigH, sigL] = sMod.getSignal('ac');
    sigMod = sigL;
    
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
    
    sigPro = sigL;
    
    c.plotPro(projection, sigPro);
    
    e = Evaluator(sigMod, model, prediction);
    
%     capture = [e.DVE(), e.percentReturn(sigPro), sum(pkt), present];
    
%     totalDVE = [totalDVE; capture];
    
    keeper = [keeper; theta];
end




t = 1:10;
y = [];

sFFT = SignalGenerator(stock, 2010, 1010);
[signal_pure, sig_pure_HL, sph, spl] = sFFT.getSignal('ac');

[m,n] = size(keeper)

figure()
for i = 1:m
    
    model = 0;
    for k = 1:n
        model = model + A(k)*cos(2*pi*1/P(k)*t + keeper(i,k));
    end
    
    y = [y,model];
    
end 

y = y+mean(spl);
plot(y)
hold on;


plot(spl,'r')

