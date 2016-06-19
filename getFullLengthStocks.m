clc; close all; clear all;

as1 = ['A',num2str(1)];%1
as2 = ['A',num2str(400)];%400

[~,allStocks] = xlsread('allStocks', [as1, ':', as2]);

indx = 'SPY';
exchange = 'NASDAQ';

iAll.INDX = IntraDayStockData(indx,exchange,'600', '50d');

goodLengthStocks = [];

for k = 1:length(allStocks)
    
    stock = allStocks{k};
    try
        iAll.STOCK = IntraDayStockData(stock,exchange,'600','50d');
        
        if length(iAll.STOCK.close) == length(iAll.INDX.close)
            stock
            goodLengthStocks = [goodLengthStocks; k];
        end
        
    catch
    end
    
    
end

goodies = {};
for i = goodLengthStocks
goodies = [goodies, {allStocks{i}}]
end 

goodies = goodies';

equalLengthStocks = goodies;

save('equalLengthStocks', 'equalLengthStocks');





