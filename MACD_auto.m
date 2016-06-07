
% MACD testing

clc; close all; clear all;

% delete(slider);
% handles = guihandles(slider);


stock = 'MSFT';
indx = 'SPY';
exchange = 'NASDAQ';

slPercent = 1;

INTRA = 0;
DAILY = 1;

past = now - 1000;
pres = now - 500;


tf = TurtleFun;
td = TurtleData;


if DAILY
    c = yahoo;
    
    dAll = flipud(fetch(c,stock,past, now, 'd'));
    avgAll = flipud(fetch(c,indx,past, now, 'd'));
    
    [hiD, loD, clD, opD, daD] = tf.returnOHLCDarray(dAll);
    hi.STOCK = hiD;
    lo.STOCK = loD;
    op.STOCK = opD;
    cl.STOCK = clD;
    [hiA, loA, clA, opA, daA] = tf.returnOHLCDarray(avgAll);
    cl.INDX = clA;
    
    len = length(clD)-1;
end


if INTRA
    iAll.STOCK = IntraDayStockData(stock,exchange,'600','10d');
    iAll.STOCK = td.getAdjustedIntra(iAll.STOCK);
    
    iAll.INDX = IntraDayStockData(indx,exchange,'600','10d');
    iAll.INDX = td.getAdjustedIntra(iAll.INDX);
    
    len = length(iAll.STOCK.close)-1;
end


tradeLen = 0;
enterPrice = NaN;
enterMarket = 0;
stopLoss = NaN;
inMarket = [];
trades = [];
figure

i = 50-1;

while i <= len
    
    i = i + 1
    range = 1:i;
    
    if INTRA
        hi.STOCK = iAll.STOCK.high(range);
        lo.STOCK = iAll.STOCK.low(range);
        op.STOCK = iAll.STOCK.open(range);
        cl.STOCK = iAll.STOCK.close(range);
        
        cl.INDX = iAll.INDX.close(range);
    end
    
    if DAILY
        hi.STOCK = hiD(range);
        lo.STOCK = loD(range);
        op.STOCK = opD(range);
        cl.STOCK = clD(range);
        
        cl.INDX = clA(range);
    end
 
    
    if length(cl.STOCK) ~= length(cl.INDX)
        disp('Length Error')
        return
    end
    
    [macdvec.STOCK, nineperma.STOCK] = macd(cl.STOCK);
    [macdvec.INDX, nineperma.INDX] = macd(cl.INDX);
    
    B.STOCK = [NaN; diff(macdvec.STOCK)];
    B.INDX  = [NaN; diff(macdvec.INDX)];
    
    if tradeLen <= 2
        stopLoss = enterPrice*(1.00-slPercent/100);
    else
        stopLoss = lo.STOCK(i-2);
    end
    
    
    for i_conditions = 1:1
        if nineperma.STOCK(i) < macdvec.STOCK(i) && nineperma.INDX(i) < macdvec.INDX(i)
            condition.MACD_bull_cross = 1;
        else
            condition.MACD_bull_cross = 0;
        end
        
        if B.STOCK(i) >= 0 && B.INDX(i) >= 0
            condition.MACD_bull_derv = 1;
        else
            condition.MACD_bull_derv = 0;
        end
        
        if lo.STOCK(i) <= stopLoss
            condition.Not_Stopped_Out = 0;
        else
            condition.Not_Stopped_Out = 1;
        end
        
    end
    
    
    if condition.MACD_bull_cross && condition.MACD_bull_derv...
            && condition.Not_Stopped_Out
        
        if enterMarket == 0
            enterPrice = cl.STOCK(i);
            trades = [trades; enterPrice, NaN, i, NaN];
        end
        
        enterMarket = 1;
        tradeLen = tradeLen + 1;
        
        inMarket = [inMarket; i, cl.STOCK(i)];
        
    else
        
        if enterMarket == 1
            
            if condition.Not_Stopped_Out
                trades(end,2) = cl.STOCK(i);
            else
                trades(end,2) = stopLoss;
            end
            
            trades(end,4) = i;
            
            i = i-1
        end
        
        enterMarket = 0;
        enterPrice = NaN;
        tradeLen = 0;
        stopLoss = NaN;
        
    end
    
    %     set(0, 'CurrentFigure', 1);
    %     cla
    %     candle(hi.STOCK, lo.STOCK, cl.STOCK, op.STOCK, 'blue');
    %     hold on
    %
    %     if enterMarket == 1
    %         for j = 1:size(inMarket,1)
    %             plot(inMarket(j,1), inMarket(j,2), 'bo');
    %         end
    %
    %         for j = 1:size(trades,1)
    %             plot(trades(j,3), trades(j,1), 'go');
    %             plot(trades(j,4), trades(j,2), 'ro');
    %         end
    %
    %         plot(xlim, [stopLoss, stopLoss]);
    %     end
    
    
    %     disp('EnterMarket: ');
    %     disp(enterMarket);
    %     disp('EnterPrice: ');
    %     disp(enterPrice);
    %     disp('tradeLen: ');
    %     disp(tradeLen);
    %     disp('stopLoss: ');
    %     disp(stopLoss);
    %     disp(' ');
    
    
    
end


set(0, 'CurrentFigure', 1);
cla
candle(hi.STOCK, lo.STOCK, cl.STOCK, op.STOCK, 'blue');
hold on

for j = 1:size(inMarket,1)
    plot(inMarket(j,1), inMarket(j,2), 'bo');
end

for j = 1:size(trades,1)
    plot(trades(j,3), trades(j,1), 'go');
    plot(trades(j,4), trades(j,2), 'ro');
end


roiLong = (trades(:,2) - trades(:,1)) ./ trades(:,1) * 100;

sum(roiLong(~isnan(roiLong)))

return;
