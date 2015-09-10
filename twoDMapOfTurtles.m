function [totalX] = twoDMapOfTurtles(signal)


shiftSize = 1;
sampleSize = 1000;

figure();
LowX1 = 100;
HighX1 = 1850;
fs = 1;


x1ph = signal;

totalX = [];


for sampleSize = 500 : 1 : 500
    
    leftOver = 2000-sampleSize;
    hsvNum = leftOver/shiftSize
    col = hsv(hsvNum);
    icl = 1;
    
    for k = 1 : shiftSize : leftOver
        
        k;
        
        x1 = x1ph(k:sampleSize+k);
        ss = length(x1);
        x1 = x1.*hanning(length(x1))';
        x1 = [x1 zeros(1, 20000)];
        X1 = abs(fft(x1));
        X1 = X1(1:ceil(length(X1)/2));
        
        Xt = 0:length(X1)-1;
        P = fs./ (Xt*(fs/length(x1)));
        [pkt It] = findpeaks(X1);
        
        totalX = [totalX; X1];

%         plot(P(LowX1:HighX1), sum(totalX(:,LowX1:HighX1)), 'color',col(icl,:))
%         hold on;
%         
        
        plot(P(LowX1:HighX1), X1(LowX1:HighX1), 'color',col(icl,:))
        hold on;
        
        icl = icl + 1;
        
        axis([8 150 0 1000])
        title(num2str(k));
    
        
    end
    
    % end
    
    
    % plot(P(LowX1:HighX1), sum(totalX(:,LowX1:HighX1)), 'k')
    % hold on;
    
end










%         for j = 1:length(It)
%             if It(j) < 1650
%                 text( P(It(j)), X1(It(j)), [num2str(P(It(j)))] );
%             end
%         end

