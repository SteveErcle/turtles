% intraDayPractice

clc; close all; clear all;

stock = 'ZIOP';
dateSelected = '04/26/16';
LEVELS = 0;


exchange = 'NASDAQ';

td = TurtleData;

levels = [8.10000000000000;7.90000000000000;8.72000000000000;8.36500000000000;8.52000000000000; 7.88];

thirtyAll = IntraDayStockData(stock,exchange,'1800','51d');
fiveAll = IntraDayStockData(stock,exchange,'60','51d');

hi = []; lo = []; cl = []; op = [];
for i = [04, 05, 06, 07, 08, 11, 12, 13, 14, 15, 18, 19, 20, 21, 22, 25]

    datePulled = ['04/',num2str(i),'/16'];
    
    thirty = td.getIntraForDate(thirtyAll, datePulled);
    congThirty.(['A',num2str(i)]) = td.getAdjustedIntra(thirty);
    
    hi = [hi; congThirty.(['A',num2str(i)]).high];
    lo = [lo; congThirty.(['A',num2str(i)]).low];
    cl = [cl; congThirty.(['A',num2str(i)]).close];
    op = [op; congThirty.(['A',num2str(i)]).open];
end

figure(1)
candle(hi, lo, cl, op, 'blue')
hold on
xlimits = xlim;
for i = 1:length(levels)
    plot([xlimits(1), xlimits(2)], [levels(i), levels(i)], 'k')
end

if LEVELS == 1
    while(true)
        
        xlimits = xlim;
        h = gcf;
        axesObjs = get(h, 'Children');
        axesObjs = findobj(axesObjs, 'type', 'axes');
        
        dataTips = findall(axesObjs, 'Type', 'hggroup', 'HandleVisibility', 'off');
        
        if length(dataTips) > 0
            
            cursor = datacursormode(gcf);
            dateOnPlot = cursor.CurrentDataCursor.getCursorInfo.Position(1)
            value = cursor.CurrentDataCursor.getCursorInfo.Position(2)
            levels = [levels; value];
            
            plot([xlimits(1), xlimits(2)], [value, value], 'k')
            
        end
        
        delete(dataTips);
        
        pause(0.1)
    end
end


thirty = td.getIntraForDate(thirtyAll, dateSelected);
thirty = td.getAdjustedIntra(thirty);
five = td.getIntraForDate(fiveAll, dateSelected);
five =  td.getAdjustedIntra(five);

hiHold = hi;
loHold = lo;
clHold = cl;
opHold = op;

reset = -1;
for i = 1:length(five.date)
    
    pause
    
    five.datestring(i)
    
    finished30 = max(find(five.date(i) >= thirty.date)) - 1;
    
    if isempty(finished30)
        finished30 = 0;
    end 
    
    if reset ~= finished30
        curHi = five.high(i);
        curLo = five.low(i);
        curOp = five.open(i);
        reset = finished30;
    end
    
    if (five.high(i) > curHi), curHi = five.high(i); end 
    if (five.low(i) > curLo), curLo = five.low(i); end 
    curCl = five.close(i);
    
    
    hi = [hiHold; thirty.high(1:finished30); curHi];
    lo = [loHold; thirty.low(1:finished30); curLo];
    cl = [clHold; thirty.close(1:finished30); curCl];
    op = [opHold; thirty.open(1:finished30); curOp];
    
    
    
    
    
    cla
    candle(hi, lo, cl, op, 'blue')
    hold on
    xlimits = xlim;
    for j = 1:length(levels)
        plot([xlimits(1), xlimits(2)], [levels(j), levels(j)], 'k')
    end
    
    
    
end 



