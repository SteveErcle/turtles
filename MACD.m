
% MACD testing

clc; close all; clear all;

stock = 'TSLA';
indx = 'SPY';
exchange = 'NASDAQ';

past = now - 250;
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

iAll.TSLA = IntraDayStockData(stock,exchange,'30','5d');
iAll.TSLA = td.getAdjustedIntra(iAll.TSLA);

hi.TSLA = iAll.TSLA.high;
lo.TSLA = iAll.TSLA.low;
op.TSLA = iAll.TSLA.open;
cl.TSLA = iAll.TSLA.close;

iAll.SPY = IntraDayStockData(indx,exchange,'30','5d');
iAll.SPY = td.getAdjustedIntra(iAll.SPY);

cl.SPY = iAll.SPY.close;



[macdvec.TSLA, nineperma.TSLA] = macd(cl.TSLA);
[macdvec.SPY, nineperma.SPY] = macd(cl.SPY);



macdStackLong = [];
macdStackShort = [];

for i = 1:length(nineperma.TSLA)
    
    if nineperma.TSLA(i) < macdvec.TSLA(i) & nineperma.SPY(i) < macdvec.SPY(i)
        macdStackLong = [macdStackLong; i];
    end
    
    if nineperma.TSLA(i) > macdvec.TSLA(i) & nineperma.SPY(i) > macdvec.SPY(i)
        macdStackShort = [macdStackShort; i];
    end
    
end


shortDiff = find(diff(macdStackShort) ~= 1);
shortStackInd = [1, shortDiff(1)];
for i = 2:length(shortDiff)
    shortStackInd = [shortStackInd; shortDiff(i-1)+1, shortDiff(i)];
end
shortStackInd = [shortStackInd; shortDiff(i)+1, length(macdStackShort)];

shortStackInd(find(shortStackInd(:,1) == shortStackInd(:,2)),:) = [];

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



subplot(2,1,1)
plot(macdvec.TSLA)
hold on
plot(nineperma.TSLA,'r')
plot(macdStackLong, macdvec.TSLA(macdStackLong), 'go')



subplot(2,1,2)
plot(macdvec.SPY)
hold on
plot(nineperma.SPY,'r')
plot(macdStackLong, macdvec.SPY(macdStackLong), 'go')

figure
candle(hi.TSLA, lo.TSLA, cl.TSLA, op.TSLA, 'blue');
hold on
plot(macdStackLong, cl.TSLA(macdStackLong), 'color', 'g', 'Marker', 'o', 'MarkerSize', 10)
plot(macdStackShort, cl.TSLA(macdStackShort), 'color', 'r', 'Marker', 'o', 'MarkerSize', 10)




