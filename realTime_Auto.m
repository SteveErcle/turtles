% realTime_Auto

clc; close all; clear all;


stock = 'TSLA';

indx = 'SPY';
exchange = 'NASDAQ';





tf = TurtleFun;
td = TurtleData;
ta = TurtleAuto;

ta.slPercent = 0.25;

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


iAll.present.STOCK = IntraDayStockData(stock,exchange,'600','1d');
iAll.present.INDX = IntraDayStockData(indx,exchange,'600', '1d');
iAll.present.STOCK = td.getAdjustedIntra(iAll.present.STOCK);
iAll.present.INDX = td.getAdjustedIntra(iAll.present.INDX);



ta.calculateData(isFlip);
ta.setStopLoss();
ta.checkConditionsUsingInd();
ta.executeBullTrade();
ta.executeBearTrade();

