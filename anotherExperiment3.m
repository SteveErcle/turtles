

clc; clear all; close all;


allFiles = dir( '/Users/Roccotepper/Documents/turtles/TurtleData' );
allNames = { allFiles.name };

stotal = [];


for stcn = 33:33length(allNames)
   
    stock = allNames{stcn}(1:end-4);
    filtH = 0.0065;
    filtL = 0.0110;
    sFFT = SignalGenerator(stock, 2202, 2000);
    [sig, sigHL, sigH, sigL] = sFFT.getSignal('ac',filtH, filtL);

    figure(stcn+100)
     plot(sig,'r');
     
    
    %     sigHL = (sigHL-min(sigHL))/ range(sigHL);
    %     sigH = (sigH-min(sigH))/ range(sigH);
    %     sig = (sig-min(sig))/ range(sig);
    
    sigHL = sigHL-mean(sigHL);
    sigHL = sigHL/std(sigHL);
    
    sigH = sigH-mean(sigH);
    sigH = sigH/std(sigH);
    
    sig = sig-mean(sig);
    sig = sig/std(sig);
    
    sigPro = sigH;
    
    sample = sigHL';
    
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
    Pds = fs./ (Xt*(fs/length(x1)));
    [pkt It] = findpeaks(X1);
    
    pktNbins = [pkt', It'];
    
    pktNbins = sortrows(pktNbins,-1);
    
    if (pktNbins(1,1) - pktNbins(2,1))/ pktNbins(1,1) < 0.75
        B = pktNbins(1:2,2);
        P = fs./ (B*(fs/length(x1)));
        A = pktNbins(1:2,1);
    else
        B = pktNbins(1,2);
        P = fs./ (B*(fs/length(x1)));
        A = pktNbins(1:1,1);
    end

    figure(stcn+200)
    plot(X1)
 
    axis([0 300 0 3])
   
    
    figure(stcn)
    plot(sigHL)
    hold on;
    plot(sigPro,'r')
    plot(ones(length(sigPro),1)*mean(sigPro));
   

    
    eMod = Evaluator(sigPro, sigHL', 1);
    
    eOne = Evaluator(sigPro, ones(1,length(sigPro)), 1);
    
    [modDVE modDVElist] = eMod.DVE();
    eOne.DVE();
    
    totald =(eMod.DVE()/eOne.DVE() - 1) * 100;
    
    mm = sigHL;
    sm = sigPro;
    modPVElist = (mm-sm).^2;
    modPVEofCurve = sum(modPVElist);
    
    mm = ones(length(sigPro),1)*mean(sigPro);
    sm = sigPro;
    modPVElist = (mm-sm).^2;
    modPVEofOne = sum(modPVElist);
    
    totalp =(modPVEofCurve/modPVEofOne - 1);
    stotal = [stotal; stcn, totald, totalp, sum(X1), modDVE, modPVEofCurve];
    
end


stotal = sortrows(stotal,5)



