% intraDayPractice

clc; close all; clear all;

stock = 'RPRX';
dateSelected = '04/14/16';
LEVELS = 0;
view = 14;

exchange = 'NASDAQ';

td = TurtleData;
tf = TurtleFun;
levels = [];

c = yahoo;
dAll.(stock) = fetch(c,stock,datenum(dateSelected)-170, dateSelected, 'd');
close(c)

thirtyAll.(stock) = IntraDayStockData(stock,exchange,'1800','100d');
fiveAll.(stock) = IntraDayStockData(stock,exchange,'300','100d');

uniqueDates = unique(datenum(datestr(thirtyAll.(stock).date,2)));
simYesterday = find(datenum(dateSelected) == uniqueDates)-1;

hi.(stock) = []; lo.(stock) = []; cl.(stock) = []; op.(stock) = [];

for i = simYesterday - view : simYesterday
    
    datePulled = datestr(uniqueDates(i),2);
    thirty.(stock) = td.getIntraForDate(thirtyAll.(stock), datePulled);
    thirty.(stock) = td.getAdjustedIntra(thirty.(stock));
    
    hi.(stock) = [hi.(stock); thirty.(stock).high];
    lo.(stock) = [lo.(stock); thirty.(stock).low];
    cl.(stock) = [cl.(stock); thirty.(stock).close];
    op.(stock) = [op.(stock); thirty.(stock).open];
    
end


figure
subplot(2,1,1)
hold on
[hiD, loD, clD, opD, daD] = tf.returnOHLCDarray(dAll.(stock)(2:end,:));
candle(hiD, loD, clD, opD, 'blue', daD);

subplot(2,1,2)
candle(hi.(stock), lo.(stock), cl.(stock), op.(stock), 'blue')
hold on
xlimits = xlim;

return


for i = 1:length(levels)
    plot([xlimits(1), xlimits(2)], [levels(i), levels(i)], 'k')
end

if LEVELS == 1
    while(true)
        
        for j = 1:2
            
            set(0, 'CurrentFigure',j)
            h = gcf;
            axesObjs = get(h, 'Children');
            axesObjs = findobj(axesObjs, 'type', 'axes');
            
            dataTips = findall(axesObjs, 'Type', 'hggroup', 'HandleVisibility', 'off');
            
            if length(dataTips) > 0
                
                cursor = datacursormode(gcf);
                dateOnPlot = cursor.CurrentDataCursor.getCursorInfo.Position(1)
                value = cursor.CurrentDataCursor.getCursorInfo.Position(2)
                levels = [levels; value];
                
                
                set(0, 'CurrentFigure',2)
                plot([daD(end), daD(1)], [value, value], 'k')
                set(0, 'CurrentFigure',1)
                plot([xlimits(1), xlimits(2)], [value, value], 'k')
                
                delete(dataTips);
                
            end
            
        end
        
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
    set(0, 'CurrentFigure',1);
    hold on
    xlimits = xlim;
    for j = 1:length(levels)
        plot([xlimits(1), xlimits(2)], [levels(j), levels(j)], 'k')
    end
    
    
    
end



