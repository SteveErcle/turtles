% intraDayViewer


clear; close all; clc

stock = 'TSLA'


subplot(2,1,1)
data = IntraDayStockData(stock,'NASDAQ','300','1d');
plot(data.date,data.high, 'r')
hi = data.high; lo = data.low; da = data.date;
highlow(hi, lo, hi, lo,'blue', da);
datetick('x',15, 'keeplimits');

subplot(2,1,2)
plot(data.date,data.high, 'r')
data = IntraDayStockData(stock,'NASDAQ','60','1d');
hi = data.high; lo = data.low; da = data.date;
highlow(hi, lo, hi, lo,'blue', da);
datetick('x',15, 'keeplimits');