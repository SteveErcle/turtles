clc; close all; clear all;


past = now - 1000;
pres = now - 500;

tf = TurtleFun;
td = TurtleData;

stock = 'FB'

% c = yahoo;

% dAll = flipud(fetch(c,stock,past, now, 'd'));
load('price26Day.mat');
exchange = 'NASDAQ';
iAll = IntraDayStockData(stock,exchange,'60','3d');
iAll = td.getAdjustedIntra(iAll);

% priceAction.price(end,:) = [];

% [hi, lo, cl, op, da] = tf.returnOHLCDarray(priceAction.price);
range = 1:length(iAll.high);
hi = iAll.high(range);
lo = iAll.low(range);
op = iAll.open(range);
cl = iAll.close(range);

magicTarr = [];
for i = 2:length(cl)
    
    if cl(i) >= cl(i-1)
        magicTarr = [magicTarr; 1];
    else
        magicTarr = [magicTarr; 0];
    end
    
end


sum(magicTarr) / length(magicTarr)


% return
% 
% magicTarr = cl >= op;
% 



negMagTarr = (magicTarr == 0) * -1;

magicTarr = magicTarr + negMagTarr;

% return

% plot(magicTarr)
% ylim([-2 2])


sum = 0;
total = [];

for i = 1:length(magicTarr)
    
    sum = sum + magicTarr(i)
    
    total = [total; sum];
end


windSize = 25;

totalMA = tsmovavg(total,'s', windSize ,1);

priceMA = tsmovavg(cl,'s', windSize ,1);

[valTP indxTP] = findpeaks(totalMA,'MINPEAKDISTANCE',100)
[valTPn indxTPn] = findpeaks(-totalMA,'MINPEAKDISTANCE',100)

subplot(2,1,1)
title('MagicT')
plot(total)
hold on
plot(totalMA,'r')

for i = 1:length(indxTP)
    plot( [indxTP(i)+2, indxTP(i)+2], ylim )
% plot(indxTP(i), valTP(i), 'ro')
end
for i = 1:length(indxTPn)
    plot( [indxTPn(i)+2, indxTPn(i)+2], ylim )
% plot(indxTPn(i), valTPn(i), 'ro')
end



subplot(2,1,2)
title('Price')
candle(hi, lo, cl, op, 'blue');
hold on
plot(priceMA,'r')
ylimit = ylim

for i = 1:length(indxTP)
    plot( [indxTP(i), indxTP(i)], ylim )
% plot(indxTP(i), valTP(i), 'ro')
end
for i = 1:length(indxTPn)
    plot( [indxTPn(i), indxTPn(i)], ylim )
% plot(indxTPn(i), valTPn(i), 'ro')
end

ylim(ylimit)