% realTime_Auto

clc; close all; clear all;

ib = ibtws('',7497);
pause(1);
ibContract = ib.Handle.createContract;


stock = 'TSLA';
indx = 'SPY';
exchange = 'NASDAQ';

ibContract.symbol = 'TSLA';
ibContract.secType = 'STK';
ibContract.exchange = 'SMART';
ibContract.primaryExchange = 'NASDAQ';
ibContract.currency = 'USD';

tf = TurtleFun;
td = TurtleData;
ta = TurtleAutoRealTime;
isFlip = 0;

ta.slPercentFirst = 0.75;
ta.slPercentSecond = 0.25;

numPlots = 5;


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
  
%     catch
%     end
    
    ta.cl.STOCK(end)
    
    ta.calculateData(isFlip);
    ta.setStopLoss();
    ta.checkConditions();
%     taRT.condition.Large_Volume = 1;
    ta.executeBullTrade();
    ta.executeBearTrade();
    
    sprintf( '%0.2f or %0.2f', ta.vo.STOCK(end-1), ta.vo.STOCK(end-2))
    sprintf( '%0.2f', mean(ta.vo.STOCK(~isnan(ta.vo.STOCK(1:end-1)))))
    sprintf( '%0.2f or %0.2f', ta.vo.INDX(end-1), ta.vo.INDX(end-2))
    sprintf( '%0.2f', mean(ta.vo.INDX(~isnan(ta.vo.INDX(1:end-1)))))
    
    disp('BULL')
    disp([ta.condition.Not_Stopped_Out.BULL,...
        ta.condition.Not_End_of_Day,...
        ta.condition.Large_Volume,...
        ta.condition.Above_MA.BULL])
    
    disp('BEAR')
    disp([ta.condition.Not_Stopped_Out.BEAR,...
        ta.condition.Not_End_of_Day,...
        ta.condition.Large_Volume,...
        ta.condition.Below_MA.BEAR])
    
    disp('Enter')
    disp([ta.enterMarket.BULL, ta.enterMarket.BEAR])
    
    
    subplot(numPlots,1,[1:2])
    cla
    candle(ta.hi.STOCK, ta.lo.STOCK, ta.cl.STOCK, ta.op.STOCK, 'blue');
    hold on
    plot(ta.clSma,'b')
    xlim(gca, [length(ta.cl.STOCK)-99, length(ta.cl.STOCK)]+5);
    
    
    subplot(numPlots,1,3)
    cla
    candle(ta.hi.INDX, ta.lo.INDX, ta.cl.INDX, ta.op.INDX, 'red');
    hold on
    plot(ta.clAma,'r')
    xlim(gca, [length(ta.cl.STOCK)-99, length(ta.cl.STOCK)+5]);
    
    
    subplot(numPlots,1,4)
    cla
    bar(ta.vo.STOCK)
    hold on
    plot(xlim, [mean(ta.vo.STOCK), mean(ta.vo.STOCK)])
    xlim(gca, [length(ta.cl.STOCK)-99, length(ta.cl.STOCK)+5]);
    
    
    subplot(numPlots,1,5)
    cla
    bar(ta.vo.INDX)
    hold on
    plot(xlim, [mean(ta.vo.INDX), mean(ta.vo.INDX)])
    xlim(gca, [length(ta.cl.STOCK)-99, length(ta.cl.STOCK)+5]);
    
    
    pause(1)
end





