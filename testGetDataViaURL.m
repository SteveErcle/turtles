% testGet data

clear all; clc; close all;

symbol = 'TSLA';
stockexchange = 'NASDAQ';

minutes = 5;
interval = num2str(60*minutes);
prevdays = '50d';

tf = TurtleFun;

data = IntraDayStockData(symbol,stockexchange,interval,prevdays)

data.dateDay = datestr(data.date,2);


simDate = '3/2/16';
simDate = datestr(datenum(simDate),2);

intraIndx = strmatch(simDate, data.dateDay);

if isempty(intraIndx)
    disp('** Intraday data not available **')
else
    
    hi = data.high(intraIndx);
    lo = data.low(intraIndx);
    op = data.close([intraIndx(1);intraIndx(1:end-1)]);
    cl = data.close(intraIndx);
    da = data.date(intraIndx);
    
    %
    intraDay = [da, op, hi, lo, cl];
    
    % tf.plotHiLoMultiple(intraDay)
    
    for i = 1:size(intraDay,1)
        [figHandle, pHandle] = tf.plotHiLoSolo(intraDay(i,:), 0.0003*minutes);
        datetick('x',15, 'keeplimits');
        pause(.01)
    end
    
end