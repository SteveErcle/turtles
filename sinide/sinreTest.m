
clear all
close all
clc


addpath('/Users/Roccotepper/Documents/turtles/TurtleData')
addpath('/Users/Roccotepper/Documents/turtles')

stock = 'JPM'


day = 1040;
futer = 800;
interval = 50


predLen = 50;
sampLen = 50;
dc_offset = 15;

dataliousMajor = [];
dataliousMinor = [];

% for i = 0:futer/interval
%     
%     present = day + i*interval;
%     
%     filtL = 0.0550;
%     filtH = 0.0065;
%     sMod = SignalGenerator(stock, present+2, sampLen);
%     [sig, sigHL, sigH, sigL] = sMod.getSignal('ac', filtH, filtL);
%     sigMod = sig;
%     
%     [X1 Pds] = getFFT(sigMod');
%     t = TideFinder(sigMod, A, P);
%     theta = t.BFtideFinder();
%     c = Construction(A, P, theta, predLen, sigMod);
%     [model, prediction, projection] = c.constructPro();
%     e = Evaluator(sigMod, model, prediction);
%     pr = e.percentReturn(sigPro)
%     [modDVE, modList] = e.DVE();
%     
%     
%     data = [i, present, modDVE, pr];
%     dataliousMinor = [dataliousMinor; data];
%     
% end 

for i = 0:futer/interval
    present = day + i*interval
    
    filtL = 0.0550;
    filtH = 0.0065;
    sMod = SignalGenerator(stock, present+2, sampLen);
    [sig, sigHL, sigH, sigL] = sMod.getSignal('ac', filtH, filtL);
    sVol = SignalGenerator(stock, present+2, sampLen);
    [vol] = sVol.getSignal('v', filtH, filtL);
 
%     sigMod = sigHL+ dc_offset;
    sigMod = sig;
    
    filtL = 0.0550;
    filtH = 0.0065;
    sPro = SignalGenerator(stock, present+2+predLen, sampLen+predLen);
    [sig, sigHL, sigH, sigL] = sPro.getSignal('ac', filtH, filtL);
    % sigPro = sigHL + dc_offset;
    sigPro = sig;
    
    
%     [X1 Pds] = getFFT(sigMod');
    
    [frq,amp,phi,ave,ssq,cnt] = sinide(sigMod,1,0);
    
    P = 1/frq;
    A = amp;
    theta = phi - pi/2;
    ssq/1000;
    
    % figure()
    % plot(Pds, X1)
    
    
    % pause;
    
    % t = TideFinder(sigMod, A, P);
    
    % thetaBF = t.BFtideFinder()
    
    c = Construction(A, P, theta, predLen, sigMod);
    [model, prediction, projection] = c.constructPro();
%     c.plotPlay(projection, sigPro);
    c.plotPro(projection, sigPro);
    hold on;
    plot(sigMod,'m')
    
    e = Evaluator(sigMod, model, prediction);
    pr = e.percentReturn(sigPro)
    [modDVE, modList] = e.DVE();
    
    posList = (model-sigMod').^2;
    pSumo = sum(posList);
    
    modList = modList - mean(modList);
    modList = modList/std(modList);
    modList = modList*2;
%     [modList] = getFiltered(modList, 0.1, 'low');
    
    posList = posList - mean(posList);
    posList = posList/std(posList);
    posList = posList*2;
%     [posList] = getFiltered(posList, 0.1, 'low');
    
    vol = vol-mean(vol);
    vol = vol/std(vol);
    vol = vol*2;
%     [vol] = getFiltered(vol, 0.1, 'low');
    
    plot(modList+mean(sigMod)+3, 'k')
    plot(posList+mean(sigMod)+4, 'b')
    plot(vol+mean(sigMod)+5,'g')
    
    
    % pause;clc
    
    % close all
    
    % cBF = Construction(A, P, thetaBF, predLen, sigMod);
    % [model, prediction, projectionBF] = cBF.constructPro();
    % c.plotPro(projection, sigPro);
    
    % plot(projection)
    
    
    % eBF = Evaluator(sigMod, model, prediction);
    % pr = eBF.percentReturn(sigPro)
    % [modDVE, modList] = e.DVE();
    
    
    
    
    % pause
    
    
    data = [i+1, P, A, theta, ssq/1000, pr, modDVE, sum(modList(end-10:end))];
    % data = [P, A, theta, ssq/1000, pr];
    dataliousMajor = [dataliousMajor; data];
    
    
end

mL = dataliousMajor(:, end);
mD = dataliousMajor(:, end-1);
pR = dataliousMajor(:, 6);
P  = dataliousMajor(:, 2);

figure()
plot(mL, pR, 'ko')
title('mL')
figure()
plot(mD, pR, 'ko')
title('mD')

dataliousMajor = sortrows(dataliousMajor, -6);
% y = A*sin(2*pi*1/P*(1:length(sig))+phi);
% plot(y,'m')
% hold on
% plot(sig)
% x = A*cos(2*pi*1/P*(1:length(sig))+theta);

% plot(P, pR, 'ro')




