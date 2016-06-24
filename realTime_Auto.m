% realTime_Auto

clc; close all; clear all;

ib = ibtws('',7497);
pause(1);
ibContract = ib.Handle.createContract;


stock = 'TSLA';
indx = 'SPY';
exchange = 'NASDAQ';

tf = TurtleFun;
td = TurtleData;
taRT = TurtleAutoRealTime;
isFlip = 0;

taRT.slPercentFirst = 0.50;
taRT.slPercentSecond = 0.25;

numPlots = 5;

iAll.past.STOCK = IntraDayStockData(stock,exchange,'600','1d');
iAll.past.INDX = IntraDayStockData(indx,exchange,'600', '1d');
iAll.past.STOCK = td.getAdjustedIntra(iAll.past.STOCK);
iAll.past.INDX = td.getAdjustedIntra(iAll.past.INDX);


yesterdaysIndxFin = min(strmatch( datestr(now,6), datestr(iAll.past.STOCK.date,6)))-1;

if ~isempty(yesterdaysIndxFin)
    fields = fieldnames(iAll.past.INDX);
    for i = strmatch('close', fields) : length(fields)
        
        iAll.past.INDX.(fields{i}) = iAll.past.INDX.(fields{i})(1:yesterdaysIndxFin);
        iAll.past.STOCK.(fields{i}) = iAll.past.STOCK.(fields{i})(1:yesterdaysIndxFin);
        
    end
end

figure()
while(true)
    
%     try
        for Get_And_Organdize_Data = 1:1
            tic
            iAll.present.STOCK = IntraDayStockData(stock,exchange,'600','1d');
            iAll.present.INDX = IntraDayStockData(indx,exchange,'600', '1d');
            
%             for i_d = 1:length(iAll.present.INDX.date)
%                 if iAll.present.STOCK.date(i_d) ~= iAll.INDX.date(i_d)
%                     iAll.present.STOCK.close = [iAll.STOCK.close(1:i_d-1); NaN; iAll.STOCK.close(i_d:end)];
%                     iAll.present.STOCK.open = [iAll.STOCK.open(1:i_d-1); NaN; iAll.STOCK.open(i_d:end)];
%                     iAll.present.STOCK.high = [iAll.STOCK.high(1:i_d-1); NaN; iAll.STOCK.high(i_d:end)];
%                     iAll.present.STOCK.low = [iAll.STOCK.low(1:i_d-1); NaN; iAll.STOCK.low(i_d:end)];
%                     iAll.present.STOCK.volume = [iAll.STOCK.volume(1:i_d-1); NaN; iAll.STOCK.volume(i_d:end)];
%                     iAll.present.STOCK.datestring = [iAll.STOCK.datestring(1:i_d-1); NaN; iAll.STOCK.datestring(i_d:end)];
%                     iAll.present.STOCK.date = [iAll.STOCK.date(1:i_d-1); NaN; iAll.STOCK.date(i_d:end)];
%                 end
%             end
            
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
%     catch
%     end
    
    taRT.cl.STOCK(end)
    
    taRT.calculateData(isFlip);
    taRT.setStopLoss();
    taRT.checkConditions();
%     taRT.condition.Large_Volume = 1;
    taRT.executeBullTrade();
    taRT.executeBearTrade();
    
    sprintf( '%0.2f or %0.2f', taRT.vo.STOCK(end-1), taRT.vo.STOCK(end-2))
    sprintf( '%0.2f', mean(taRT.vo.STOCK(~isnan(taRT.vo.STOCK(1:end-1)))))
    sprintf( '%0.2f or %0.2f', taRT.vo.INDX(end-1), taRT.vo.INDX(end-2))
    sprintf( '%0.2f', mean(taRT.vo.INDX(~isnan(taRT.vo.INDX(1:end-1)))))
    
    disp('BULL')
    disp([taRT.condition.Not_Stopped_Out.BULL,...
        taRT.condition.Not_End_of_Day,...
        taRT.condition.Large_Volume,...
        taRT.condition.Above_MA.BULL])
    
    disp('BEAR')
    disp([taRT.condition.Not_Stopped_Out.BEAR,...
        taRT.condition.Not_End_of_Day,...
        taRT.condition.Large_Volume,...
        taRT.condition.Below_MA.BEAR])
    
    disp('Enter')
    disp([taRT.enterMarket.BULL, taRT.enterMarket.BEAR])
    
    
    subplot(numPlots,1,[1:2])
    cla
    candle(taRT.hi.STOCK, taRT.lo.STOCK, taRT.cl.STOCK, taRT.op.STOCK, 'blue');
    hold on
    plot(taRT.clSma,'b')
    xlim(gca, [length(taRT.cl.STOCK)-99, length(taRT.cl.STOCK)]+5);
    
    
    subplot(numPlots,1,3)
    cla
    candle(taRT.hi.INDX, taRT.lo.INDX, taRT.cl.INDX, taRT.op.INDX, 'red');
    hold on
    plot(taRT.clAma,'r')
    xlim(gca, [length(taRT.cl.STOCK)-99, length(taRT.cl.STOCK)+5]);
    
    
    subplot(numPlots,1,4)
    cla
    bar(taRT.vo.STOCK)
    hold on
    plot(xlim, [mean(taRT.vo.STOCK), mean(taRT.vo.STOCK)])
    xlim(gca, [length(taRT.cl.STOCK)-99, length(taRT.cl.STOCK)+5]);
    
    
    subplot(numPlots,1,5)
    cla
    bar(taRT.vo.INDX)
    hold on
    plot(xlim, [mean(taRT.vo.INDX), mean(taRT.vo.INDX)])
    xlim(gca, [length(taRT.cl.STOCK)-99, length(taRT.cl.STOCK)+5]);
    
    
    pause(1)
end





