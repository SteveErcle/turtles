clear all; clc; close all;



toter = [];
PR = [];
angaliousSuperiomus = [];

stock = 'JPM';
A = [.45 .45 .45 .78 .88];
P = [32 41 52 62 82];
B = [270 356 422 535 665];

day = 400;
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


plot(angaliousMajor)
hold on;
plot(sig-mean(sig),'k')


