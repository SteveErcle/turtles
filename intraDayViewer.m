% intraDayViewer


clear; close all; clc;


delete(intraDayGui);
handles = guihandles(intraDayGui);
set(handles.radiobutton1, 'Value', 0);

[~,allStocks] = xlsread('listOfStocks');

stock = 'WLL'

minutely = IntraDayStockData(stock,'NYSE','60','1d');
c = yahoo;
m = fetch(c,stock,now, now-17000, 'm');
d = fetch(c,stock,now, now-1000, 'd');
close(c)

exchange = 'NYSE';
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

i_time = -1;
refreshRate = 0.1;

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
    
    if i_time >= 30|| i_time == -1
        d(1,:) = [];
        d = getTodaysOHLC(stock, exchange, d);
        fifteenly = IntraDayStockData(stock,exchange,'900','1d');
        minutely = IntraDayStockData(stock,exchange,'60','1d');
        
        subplot(2,2,[1,3])
        hi = d(:,3); lo = d(:,4); cl = d(:,5); op = d(:,2); da = d(:,1);
        highlow(hi, lo, op, cl, 'blue', da);
        axis([da(100), da(1)+5,...
            min(lo(1:100))*0.95, max(hi(1:100))*1.05])
        title(strcat(stock,' Daily'))
        datetick('x',12, 'keeplimits');
        hold on
        
        subplot(2,2,2)
        hi = fifteenly.high; lo = fifteenly.low; da = fifteenly.date;
        highlow(hi, lo, hi, lo,'blue', da);
        hold on;
        datetick('x',15, 'keeplimits');
        axis([x1, x2, y1*0.995, y2*1.005])
        
        subplot(2,2,4)
        hi = minutely.high; lo = minutely.low; da = minutely.date;
        highlow(hi, lo, hi, lo,'blue', da);
        hold on;
        datetick('x',15, 'keeplimits');
        %     axis([x1, x2, y1*0.995, y2*1.005])
        
        numHours = str2double(get(handles.edit1,'String'))
        %     axis([da(end)-(numHours/24), da(end) + 1/48, y1*0.995, y2*1.005])
        i_time = 0;
    end
    
    if get(handles.radiobutton1, 'Value')
        numHours = str2double(get(handles.edit1,'String'));
        subplot(2,2,4)
        now = da(end);
        nowMinusHours = now-(numHours/24);
        [c idxOfNowMinusHours] = min(abs(da-nowMinusHours));
        y1 = min(lo(idxOfNowMinusHours:end));
        y2 = max(hi(idxOfNowMinusHours:end));
        axis([nowMinusHours, now + 1/48, y1*0.995, y2*1.005])
    else
        subplot(2,2,4)
        axis([x1, x2, y1*0.995, y2*1.005])
    end
    
    pause(refreshRate)
    i_time = i_time + refreshRate;
   
    
end


% set(gcf, 'Position', [1441,1,1080,1824]);






