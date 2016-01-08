% intraDayViewer


clear; close all; clc


stock = 'TSLA'
exchange = 'NASDAQ';

subplot(2,1,1)
data = IntraDayStockData(stock,exchange,'900','1d');
plot(data.date,data.high, 'r')
hi = data.high; lo = data.low; da = data.date;
highlow(hi, lo, hi, lo,'blue', da);
datetick('x',15, 'keeplimits');

subplot(2,1,2)
plot(data.date,data.high, 'r')
data = IntraDayStockData(stock,exchange,'60','1d');
hi = data.high; lo = data.low; da = data.date;
highlow(hi, lo, hi, lo,'blue', da);
datetick('x',15, 'keeplimits');

set(gcf, 'Position', [1441,1,1080,1824]);


