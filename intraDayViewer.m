% intraDayViewer


clear; close all; clc;

[~,allStocks] = xlsread('listOfStocks');

stock = allStocks(1)
stock = 'PSEC'

minutely = IntraDayStockData(stock,'NYSE','60','1d');
c = yahoo;
m = fetch(c,stock,now, now-17000, 'm');
d = fetch(c,stock,now, now-1000, 'd');
close(c)

exchange = 'NASDAQ';
d = getTodaysOHLC(stock, exchange, d);

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

minutely = IntraDayStockData(stock,'NYSE','60','1d');
y1 = d(2,4); y2 = d(2,3);
x1 = floor(minutely.date(1))+0.3833333333; x2 = floor(minutely.date(1))+0.677777777;

da = linspace(x1,x2,10);
subplot(2,2,2)
hold on;
autoPlotLevs(quarterlyHL, yearlyHL, da);
plot(linspace(x1,x1+0.02,3), ones(1, 3)*op(2), 'color', 'm', 'marker', 'o');
plot(linspace(x1,x1+0.02,3), ones(1, 3)*hi(2), 'color', 'm', 'marker', '^');
plot(linspace(x1,x1+0.02,3), ones(1, 3)*lo(2), 'color', 'm', 'marker', 'v');
plot(linspace(x1,x1+0.02,3), ones(1, 3)*cl(2), 'color', 'm', 'marker', 'x');

subplot(2,2,4)
hold on;
autoPlotLevs(quarterlyHL, yearlyHL, da)
plot(linspace(x1,x1+0.02,3), ones(1, 3)*op(2), 'color', 'm', 'marker', 'o');
plot(linspace(x1,x1+0.02,3), ones(1, 3)*hi(2), 'color', 'm', 'marker', '^');
plot(linspace(x1,x1+0.02,3), ones(1, 3)*lo(2), 'color', 'm', 'marker', 'v');
plot(linspace(x1,x1+0.02,3), ones(1, 3)*cl(2), 'color', 'm', 'marker', 'x');


while(true)
    
    if y1 < min(minutely.low)
        y1 =  d(2,4);
    else
        y1 = min(minutely.low);
    end
    
    if y2 > max(minutely.high)
        y2 =  d(2,3);
    else
        y2 = max(minutely.high);
    end
    
    subplot(2,2,[1,3])
    d(1,:) = [];
    d = getTodaysOHLC(stock, exchange, d);
    hi = d(:,3); lo = d(:,4); cl = d(:,5); op = d(:,2); da = d(:,1);
    highlow(hi, lo, op, cl, 'blue', da);
    axis([da(100), da(1)+5,...
        min(lo(1:100))*0.95, max(hi(1:100))*1.05])
    title(strcat(stock,' Daily'))
    datetick('x',12, 'keeplimits');
    hold on

    
    subplot(2,2,2)
    fifteenly = IntraDayStockData(stock,exchange,'900','1d');
    hi = fifteenly.high; lo = fifteenly.low; da = fifteenly.date;
    highlow(hi, lo, hi, lo,'blue', da);
    hold on;
    datetick('x',15, 'keeplimits');
    axis([x1, x2, y1*0.995, y2*1.005])
    
    subplot(2,2,4)
    minutely = IntraDayStockData(stock,exchange,'60','1d');
    hi = minutely.high; lo = minutely.low; da = minutely.date;
    highlow(hi, lo, hi, lo,'blue', da);
    hold on;
    datetick('x',15, 'keeplimits');
    axis([x1, x2, y1*0.995, y2*1.005])
    
    pause
    
end


% set(gcf, 'Position', [1441,1,1080,1824]);

return












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

minutely = IntraDayStockData(stock,exchange,'60','1d');
minutely.date = minutely.date(1);
minutely.low = minutely.low(1);
minutely.high = minutely.high(1);

y1 = d(2,4); y2 = d(2,3);
x1 = floor(minutely.date(1))+0.3833333333; x2 = floor(minutely.date(1))+0.677777777;

da = linspace(x1,x2,10);
subplot(2,2,2)
hold on;
autoPlotLevs(quarterlyHL, yearlyHL, da);
plot(linspace(x1,x1+0.02,3), ones(1, 3)*op(2), 'color', 'm', 'marker', 'o');
plot(linspace(x1,x1+0.02,3), ones(1, 3)*hi(2), 'color', 'm', 'marker', '^');
plot(linspace(x1,x1+0.02,3), ones(1, 3)*lo(2), 'color', 'm', 'marker', 'v');
plot(linspace(x1,x1+0.02,3), ones(1, 3)*cl(2), 'color', 'm', 'marker', 'x');

subplot(2,2,4)
hold on;
autoPlotLevs(quarterlyHL, yearlyHL, da)
plot(linspace(x1,x1+0.02,3), ones(1, 3)*op(2), 'color', 'm', 'marker', 'o');
plot(linspace(x1,x1+0.02,3), ones(1, 3)*hi(2), 'color', 'm', 'marker', '^');
plot(linspace(x1,x1+0.02,3), ones(1, 3)*lo(2), 'color', 'm', 'marker', 'v');
plot(linspace(x1,x1+0.02,3), ones(1, 3)*cl(2), 'color', 'm', 'marker', 'x');


j = 1;
% while(true)

for i = 1:300
    
    if y1 < min(minutely.low(1:i))
        y1 =  d(2,4);
    else
        y1 = min(minutely.low(1:i));
    end
    
    if y2 > max(minutely.high(1:i))
        y2 =  d(2,3);
    else
        y2 = max(minutely.high(1:i));
    end
    
    subplot(2,2,2)
    fifteenly = IntraDayStockData(stock,exchange,'900','1d');
    if minutely.date(i) >= fifteenly.date(j+1)
        j = j+1;
    end
    hi = fifteenly.high(1:j); lo = fifteenly.low(1:j); da = fifteenly.date(1:j);
    highlow(hi, lo, hi, lo,'blue', da);
    hold on;
    datetick('x',15, 'keeplimits');
    axis([x1, x2, y1*0.995, y2*1.005])
    
    subplot(2,2,4)
    minutely = IntraDayStockData(stock,exchange,'60','1d');
    hi = minutely.high(1:i); lo = minutely.low(1:i); da = minutely.date(1:i);
    highlow(hi, lo, hi, lo,'blue', da);
    hold on;
    datetick('x',15, 'keeplimits');
    axis([x1, x2, y1*0.995, y2*1.005])
    
    pause
    
end


% set(gcf, 'Position', [1441,1,1080,1824]);

