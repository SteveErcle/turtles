% anotherExperiment

clc; clear all; close all;

stock = 'JPM';


filtH = 0.0065;
filtL = 0.0110;
sMod = SignalGenerator(stock, 2000+2, 2000);
[sig, sigHL, sigH, sigL] = sMod.getSignal('ac', filtH, filtL);



hsvNum = 12;
col = hsv(hsvNum);
icl = 1;

PLOT = 0;
if PLOT == 1
    for filtL = 0.0110:0.0050:0.110
        figure()
        icl = 1;
        
        for filtH = 0.0110:0.0010:0.0210
            
            sigH = getFiltered(sig, filtH, 'high');
            sigL = getFiltered(sig, filtL, 'low');
            sigHL = getFiltered(sigH, filtL, 'low');
            
            
            plot(sigHL+mean(sig), 'color',col(icl,:));
            hold on;
            %         plot(sig);
            %         hold on;
            
            % axis([0 2000 20 25]);
            
            icl = icl + 1;
            
        end
        
    end
end

filtL = 0.1100;
filtH = 0.0210;
sMod = SignalGenerator(stock, 2000+2, 2000);
[sig, sigHL, sigH, sigL] = sMod.getSignal('ac', filtH, filtL);

[X1 Pds angles] = getFFT(sigHL');
plot(Pds,X1)

A = [.45 .45 .45 .78 .88];
P = [32 41 52 62 82];
B = [270 356 422 535 665];






