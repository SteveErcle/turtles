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
    for filtL = 0.0110:0.0050:0.0550
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

filtL = 0.0550;
filtH = 0.0065;
sMod = SignalGenerator(stock, 2000+2, 2000);
[sig, sigHL, sigH, sigL] = sMod.getSignal('ac', filtH, filtL);

[X1 Pds angles] = getFFT(sigHL');
plot(Pds, X1)

A = [.45 .45 .45 .78 .88];
P = [32 41 52 62 82];
B = [270 356 422 535 665];

saValues = [];
values = [];
for i = 1:length(cursor_info)

value = getfield(cursor_info, {i},'Position')
values = [values;value];

end 
saValues = [saValues;values];
P = saValues(:,1);
A = saValues(:,2);


P = [41.0447761194030;99.5475113122172;62.3229461756374;52.1327014218009;81.4814814814815;209.523809523810;122.222222222222;318.840579710145];
A = [0.339497673909774;0.434571526579002;0.800542331823607;0.461698880254668;1.08169199144594;1.42692813386403;1.53695933574092;1.11859378182605];
B = [537; 222; 354; 424; 272; 106; 181; 69];

