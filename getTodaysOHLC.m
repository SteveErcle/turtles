function [d] = getTodaysOHLC(stock, exchange, d)

stock = char(stock);

today = IntraDayStockData(stock,exchange,'60','1d');

dToday = [today.date(1), today.close(1), max(today.high), min(today.low),...
    today.close(end), sum(today.volume), today.close(end)];

d = [dToday;d];

end
