
% MACD testing

clc; close all; clear all;

delete(slider);
handles = guihandles(slider);



stock = 'TSLA';
indx = 'SPY';
exchange = 'NASDAQ';

past = now - 350;
pres = now;

tf = TurtleFun;
td = TurtleData;

% c = yahoo;
% 
% dAll = flipud(fetch(c,stock,past, now, 'd'));
% avgAll = flipud(fetch(c,indx,past, now, 'd'));
% 
% [hiD, loD, clD, opD, daD] = tf.returnOHLCDarray(dAll);
% hi.TSLA = hiD;
% lo.TSLA = loD;
% op.TSLA = opD;
% cl.TSLA = clD;
% [hiA, loA, clA, opA, daA] = tf.returnOHLCDarray(avgAll);
% cl.SPY = clA;



iAll.TSLA = IntraDayStockData(stock,exchange,'300','5d');
iAll.TSLA = td.getAdjustedIntra(iAll.TSLA);

hi.TSLA = iAll.TSLA.high;
lo.TSLA = iAll.TSLA.low;
op.TSLA = iAll.TSLA.open;
cl.TSLA = iAll.TSLA.close;
vo.TSLA = iAll.TSLA.volume;

iAll.SPY = IntraDayStockData(indx,exchange,'300','5d');
iAll.SPY = td.getAdjustedIntra(iAll.SPY);

cl.SPY = iAll.SPY.close;

len = length(cl.SPY);
set(handles.axisView, 'Max', len, 'Min', 0);
set(handles.axisView, 'SliderStep', [1/len, 10/len]);
set(handles.axisView, 'Value', 0);



[macdvec.TSLA, nineperma.TSLA] = macd(cl.TSLA);
[macdvec.SPY, nineperma.SPY] = macd(cl.SPY);

if length(cl.SPY) ~= length(cl.TSLA)
    disp('Length Error')
    return
end

macdStackLong = [];
macdStackShort = [];

B.TSLA = [NaN; diff(macdvec.TSLA)];
B.SPY  = [NaN; diff(macdvec.SPY)];

difference = [];

for i = 1:length(nineperma.TSLA)
    
    difference = [difference; nineperma.TSLA(i) - macdvec.TSLA(i)];
    
    if nineperma.TSLA(i) < macdvec.TSLA(i) & nineperma.SPY(i) < macdvec.SPY(i)...
            & B.TSLA(i) >= 0 & B.SPY(i) >= 0
        macdStackLong = [macdStackLong; i];
    end
    
    if nineperma.TSLA(i) > macdvec.TSLA(i) & nineperma.SPY(i) > macdvec.SPY(i)...
            & B.TSLA(i) <= 0 & B.SPY(i) <= 0
        macdStackShort = [macdStackShort; i];
    end
    
end


shortDiff = find(diff(macdStackShort) ~= 1);
shortStackInd = [1, shortDiff(1)];
for i = 2:length(shortDiff)
    shortStackInd = [shortStackInd; shortDiff(i-1)+1, shortDiff(i)];
end

shortStackInd = [shortStackInd; shortDiff(i)+1, length(macdStackShort)];

% shortStackInd(find(shortStackInd(:,1) == shortStackInd(:,2)),:) = [];

shortStackMacd = [macdStackShort(shortStackInd(:,1)), macdStackShort(shortStackInd(:, 2))];

roiShort = [];

for i = 1:length(shortStackMacd)
    roiShort = [roiShort; ((cl.TSLA(shortStackMacd(i,1))) - cl.TSLA(shortStackMacd(i,2))) / cl.TSLA(shortStackMacd(i,1))*100];
end

roiShort;
disp('ROI Short');
disp(sum(roiShort));

longDiff = find(diff(macdStackLong) ~= 1);
longStackInd = [1,longDiff(1)];
for i = 2:length(longDiff)
    longStackInd = [longStackInd; longDiff(i-1)+1, longDiff(i)];
end
longStackInd = [longStackInd; longDiff(i)+1, length(macdStackLong)];


longStackInd(find(longStackInd(:,1) == longStackInd(:,2)),:) = [];

longStackMacd = [macdStackLong(longStackInd(:,1)), macdStackLong(longStackInd(:, 2))];

roiLong = [];

for i = 1:length(longStackMacd)
    roiLong = [roiLong; (cl.TSLA(longStackMacd(i,2)) - cl.TSLA(longStackMacd(i,1))) / cl.TSLA(longStackMacd(i,1))*100];
end

roiLong;
disp('ROI Long');
disp(sum(roiLong));

while(true)
    
    subplot(5,1,[1:2])
    cla
    candle(hi.TSLA, lo.TSLA, cl.TSLA, op.TSLA, 'blue');
    hold on
    
    
    subplot(5,1,3)
    cla
    plot(macdvec.TSLA)
    hold on
    plot(nineperma.TSLA,'r')
    plot(xlim, [0,0], 'k')
    
    
    subplot(5,1,4)
    cla
    plot(macdvec.SPY)
    hold on
    plot(nineperma.SPY,'r')
    plot(xlim, [0,0], 'k')
    
    subplot(5,1,5)
    cla
    bar(vo.TSLA)
    hold on
    plot(xlim, [mean(vo.TSLA), mean(vo.TSLA)])
    
    
    
    for j = 2:5
        
        if j == 2
            subIndx = [1:2];
        else
            subIndx = j;
        end
        
        subplot(5,1,subIndx)
        hold on
        axisView = get(handles.axisView, 'Value');
        xlim(gca, [0+axisView, 100+axisView])
        
        
        yLimits = ylim(gca);
        yLo = yLimits(1);
        yHi = yLimits(2);
        
        if j == 3
            B = [NaN; diff(macdvec.TSLA)];
            B = B * ((yLimits(2)/2) / max(B));
            bp = bar(B);
            set(get(bp,'Children'),'FaceAlpha',0.2);    
        elseif j == 4
            B = [NaN; diff(macdvec.SPY)];
            B = B * ((yLimits(2)/2) / max(B));
            bp = bar(B);
            set(get(bp,'Children'),'FaceAlpha',0.2);
        end
        
        for i = 1:length(longStackMacd)
            xLo = longStackMacd(i,1);
            xHi = longStackMacd(i,2);
            
            xLong = [xLo xHi xHi xLo];
            yLong = [yLo yLo yHi yHi];
            
            hp = patch(xLong,yLong, [0.7, 1, .7], 'FaceAlpha', 0.25);
        end
        
        for i = 1:length(shortStackMacd)
            xLo = shortStackMacd(i,1);
            xHi = shortStackMacd(i,2);
            
            xShort = [xLo xHi xHi xLo];
            yShort = [yLo yLo yHi yHi];
            
            hp = patch(xShort,yShort, [1, .7, .7], 'FaceAlpha', 0.25);
        end
        
        
        
        
        
    end
    
    
    bestRoiLong = sortrows(roiLong, -1);
    
    subplot(5,1,[1:2])
    for i = 1:10
        
        xText = mean(longStackMacd(find(bestRoiLong(i) == roiLong),:));
        ylimits = ylim;
        text(xText, ylimits(2), num2str(bestRoiLong(i)))
    end
    
    pause(10/100)
    
end

% plot(macdStackLong, cl.TSLA(macdStackLong), 'color', 'g', 'Marker', 'o', 'MarkerSize', 10)
% plot(macdStackShort, cl.TSLA(macdStackShort), 'color', 'r', 'Marker', 'o', 'MarkerSize', 10)



