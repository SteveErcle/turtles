% realTime_Auto

% clc; close all; clear all;

stock = 'TSLA';
indx = 'SPY';
exchange = 'NASDAQ';

tf = TurtleFun;
td = TurtleData;
taRT = TurtleAutoRealTime;
isFlip = 1;

taRT.slPercent = 0.25;

numPlots = 5;

iAll.past.STOCK = IntraDayStockData(stock,exchange,'600','5d');
iAll.past.INDX = IntraDayStockData(indx,exchange,'600', '5d');
iAll.past.STOCK = td.getAdjustedIntra(iAll.past.STOCK);
iAll.past.INDX = td.getAdjustedIntra(iAll.past.INDX);


yesterdaysIndxFin = min(strmatch( datestr(now,6), datestr(iAll.past.STOCK.date,6)))-1;

if ~isempty(yesterdaysIndxFin)
    fields = fieldnames(iAll.past.INDX);
    for i = strmatch('close', fields) : length(fields)
        
        iAll.past.INDX.(fields{i}) = iAll.past.INDX.(fields{i})(1:yesterdaysIndxFin);
        iAll.past.STOCK.(fields{i}) = iAll.past.INDX.(fields{i})(1:yesterdaysIndxFin);
        
    end
end

figure()
while(true)
    
    for Get_And_Organdize_Data = 1:1
        tic
        iAll.present.STOCK = IntraDayStockData(stock,exchange,'600','1d');
        iAll.present.INDX = IntraDayStockData(indx,exchange,'600', '1d');
        iAll.present.STOCK = td.getAdjustedIntra(iAll.present.STOCK);
        iAll.present.INDX = td.getAdjustedIntra(iAll.present.INDX);
        toc
        
        tic
        taRT.hi.STOCK = [iAll.past.STOCK.high; iAll.present.STOCK.high];
        taRT.lo.STOCK = [iAll.past.STOCK.low; iAll.present.STOCK.low];
        taRT.cl.STOCK = [iAll.past.STOCK.close; iAll.present.STOCK.close];
        taRT.op.STOCK = [iAll.past.STOCK.open; iAll.present.STOCK.open];
        taRT.vo.STOCK = [iAll.past.STOCK.volume; iAll.present.STOCK.volume];
        taRT.da.STOCK = [iAll.past.STOCK.date; iAll.present.STOCK.date];
        
        taRT.hi.INDX = [iAll.past.INDX.high; iAll.present.INDX.high];
        taRT.lo.INDX = [iAll.past.INDX.low; iAll.present.INDX.low];
        taRT.cl.INDX = [iAll.past.INDX.close; iAll.present.INDX.close];
        taRT.op.INDX = [iAll.past.INDX.open; iAll.present.INDX.open];
        taRT.vo.INDX = [iAll.past.INDX.volume; iAll.present.INDX.volume];
        taRT.da.INDX = [iAll.past.INDX.date; iAll.present.INDX.date];
        toc
        
    end
    
    taRT.cl.STOCK(end)
    
    taRT.calculateData(isFlip);
    taRT.setStopLoss();
    taRT.checkConditionsUsingInd();
    taRT.executeBullTrade();
    taRT.executeBearTrade();
    
    candle(hi, lo, cl, op, 'blue');
    
    pause(1)
end





