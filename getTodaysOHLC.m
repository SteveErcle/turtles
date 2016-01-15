function [d] = getTodaysOHLC(stock, exchange, d)

stock = char(stock);

catchFlag = 0;

try
    today = IntraDayStockData(stock,exchange,'60','1d');
catch
    catchFlag = 1;
    exchange = 'NASDAQ';
end

if catchFlag == 1
    try
        today = IntraDayStockData(stock,exchange,'60','1d');
    catch
        catchFlag = 2;
        exchange = 'NYSEMKT';
    end
end

if catchFlag == 2
    try
        today = IntraDayStockData(stock,exchange,'60','1d');
    catch
        catchFlag = 3;
        exchange = 'NYSEARCA';
    end
end

today = IntraDayStockData(stock,exchange,'60','1d');

dToday = [today.date(1), today.close(1), max(today.high), min(today.low),...
    today.close(end), sum(today.volume), today.close(end)];
d = [dToday;d];

end
