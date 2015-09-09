function [] = twoDMapOfTurtles(signal)


shiftSize = 10;
LowX1 = 100;
HighX1 = 1850;
fs = 1;

hsvNum = 1000/shiftSize;
col = hsv(hsvNum);

icl = 1;
x1ph = signal;

figure();

for k = 1:shiftSize:1000
    
    x1 = x1ph(k:1000+k);
    ss = length(x1);
    x1 = x1.*hanning(length(x1))';
    x1 = [x1 zeros(1, 20000)];
    X1 = abs(fft(x1));
    X1 = X1(1:ceil(length(X1)/2));
    
    Xt = 0:length(X1)-1;
    P = fs./ (Xt*(fs/length(x1)));
    [pkt It] = findpeaks(X1);
    
    plot(P(100:1850), X1(LowX1:HighX1), 'color',col(icl,:))
    
    hold on;
    
    icl = icl + 1;
    
    
    %         for j = 1:length(It)
    %             if It(j) < 1650
    %                 text( P(It(j)), X1(It(j)), [num2str(P(It(j)))] );
    %             end
    %         end
    
    
    
    axis([8 100 0 1000])
    title(num2str(k));
    
    
    
end

end
