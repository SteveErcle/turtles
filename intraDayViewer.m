% intraDayViewer


clear; close all; clc;


stock = 'PSEC'

c = yahoo;
m = fetch(c,stock,now, now-17000, 'm');
d = fetch(c,stock,now, now-1000, 'd');
close(c)

exchange = 'NASDAQ';
% d = getTodaysOHLC(stock, exchange, d);

datestr(d(1))
[quarterlyHL yearlyHL] = getQYHL(m);

subplot(2,2,[1,3])
hi = d(:,3); lo = d(:,4); cl = d(:,5); op = d(:,2); da = d(:,1);
highlow(hi, lo, op, cl, 'blue', da);
axis([da(100), da(1)+5,...
    min(lo(1:100))*0.95, max(hi(1:100))*1.05])
title(strcat(stock,' Daily'))
datetick('x',12, 'keeplimits');
hold on
autoPlotLevs(quarterlyHL, yearlyHL, da)

data = IntraDayStockData(stock,exchange,'60','1d');
y1 = d(1,4); y2 = d(1,3);
x1 = floor(data.date(1))+0.3833333333; x2 = floor(data.date(1))+0.677777777;


while(true)
    
    

    if y1 < min(data.low)
        y1 =  d(1,4)
    else
        y1 = min(data.low)
    end
    
    if y2 > max(data.high)
        y2 =  d(1,3)
    else
        y2 = max(data.high)
    end
    
    subplot(2,2,2)
    data = IntraDayStockData(stock,exchange,'900','1d');
    hi = data.high; lo = data.low; da = data.date;
    highlow(hi, lo, hi, lo,'blue', da);
    hold on;
    autoPlotLevs(quarterlyHL, yearlyHL, da);
    datetick('x',15, 'keeplimits');
    axis([x1, x2, y1*0.995, y2*1.005])
    
    subplot(2,2,4)
    data = IntraDayStockData(stock,exchange,'60','1d');
    hi = data.high; lo = data.low; da = data.date;
    highlow(hi, lo, hi, lo,'blue', da);
    hold on;
    autoPlotLevs(quarterlyHL, yearlyHL, da)
    datetick('x',15, 'keeplimits');
    axis([x1, x2, y1*0.995, y2*1.005])
    
    pause(60)
    
end




% set(gcf, 'Position', [1441,1,1080,1824]);
