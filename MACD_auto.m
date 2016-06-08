
% MACD testing

clc; close all; clear all;

stock = 'MSFT';
indx = 'SPY';
exchange = 'NASDAQ';

slPercent = 0.5;

INTRA = 1;
DAILY = 0;

past = now - 1000;
pres = now - 500;


tf = TurtleFun;
td = TurtleData;

numPlots = 6;

if DAILY
    c = yahoo;
    
    dAll = flipud(fetch(c,stock,past, now, 'd'));
    avgAll = flipud(fetch(c,indx,past, now, 'd'));
    
    [hiD, loD, clD, opD, daD, voD] = tf.returnOHLCDarray(dAll);
    hi.STOCK = hiD;
    lo.STOCK = loD;
    op.STOCK = opD;
    cl.STOCK = clD;
    vo.STOCK = voD;
    [hiA, loA, clA, opA, daA, voA] = tf.returnOHLCDarray(avgAll);
    cl.INDX = clA;
    
    len = length(clD)-1;
end


if INTRA
    iAll.STOCK = IntraDayStockData(stock,exchange,'600','10d');
    iAll.STOCK = td.getAdjustedIntra(iAll.STOCK);
    
    iAll.INDX = IntraDayStockData(indx,exchange,'600','10d');
    iAll.INDX = td.getAdjustedIntra(iAll.INDX);
    
    if length(iAll.STOCK.close) ~= length(iAll.INDX.close)
        disp('Length Error')
        return
    end
    
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
        TA.hi.STOCK = iAll.STOCK.high(range);
        TA.lo.STOCK = iAll.STOCK.low(range);
        TA.op.STOCK = iAll.STOCK.open(range);
        TA.cl.STOCK = iAll.STOCK.close(range);
        TA.vo.STOCK = iAll.STOCK.volume(range);
        
        TA.cl.INDX = iAll.INDX.close(range);
        TA.vo.INDX = iAll.INDX.volume(range);
    end
    
    if DAILY
        TA.hi.STOCK = hiD(range);
        TA.lo.STOCK = loD(range);
        TA.op.STOCK = opD(range);
        TA.cl.STOCK = clD(range);
        TA.vo.STOCK = voD(range);
        
        TA.cl.INDX = clA(range);
        TA.vo.INDX = voA(range);
    end
    
    
    
    
    [TA.macdvec.STOCK, TA.nineperma.STOCK] = macd(TA.cl.STOCK);
    [TA.macdvec.INDX, TA.nineperma.INDX] = macd(TA.cl.INDX);
    
    TA.B.STOCK = [NaN; diff(TA.macdvec.STOCK)];
    TA.B.INDX  = [NaN; diff(TA.macdvec.INDX)];
    
    if tradeLen <= 2
        stopLoss = enterPrice*(1.00-slPercent/100);
    else
        stopLoss = lo.STOCK(i-2);
    end
    
    
    for i_conditions = 1:1
        if  nineperma.INDX(i) < macdvec.INDX(i) %&& nineperma.STOCK(i) < macdvec.STOCK(i)
            condition.MACD_bull_cross = 1;
        else
            condition.MACD_bull_cross = 0;
        end
        
        if B.STOCK(i) >= 0.005 && B.INDX(i) >= 0.0
            condition.MACD_bull_derv = 1;
        else
            condition.MACD_bull_derv = 0;
        end
        
        if lo.STOCK(i) <= stopLoss
            condition.Not_Stopped_Out = 0;
        else
            condition.Not_Stopped_Out = 1;
        end
        
        if vo.STOCK(i) > mean(vo.STOCK)
            condition.Large_Volume = 1;
        else
            condition.Large_Volume = 0;
        end
   
    end
    
    
    if TA.condition.MACD_bull_cross && TA.condition.MACD_bull_derv...
            && TA.condition.Not_Stopped_Out && TA.condition.Large_Volume
        
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


roiLong = (trades(:,2) - trades(:,1)) ./ trades(:,1) * 100;

sum(roiLong(~isnan(roiLong)))




delete(slider);
handles = guihandles(slider);


len = length(cl.INDX);
set(handles.axisView, 'Max', len, 'Min', 0);
set(handles.axisView, 'SliderStep', [1/len, 10/len]);
set(handles.axisView, 'Value', 0);


while(true)
    
    subplot(numPlots,1,[1:2])
    cla
    candle(hi.STOCK, lo.STOCK, cl.STOCK, op.STOCK, 'blue');
    hold on
    
    %     for j = 1:size(inMarket,1)
    %         plot(inMarket(j,1), inMarket(j,2), 'bo');
    %     end
    %
    %     for j = 1:size(trades,1)
    %         plot(trades(j,3), trades(j,1), 'go');
    %         plot(trades(j,4), trades(j,2), 'ro');
    %     end
    
    subplot(numPlots,1,3)
    cla
    bp = bar(B.STOCK,'k');
    set(get(bp,'Children'),'FaceAlpha',0.2);
    hold on
    plot(macdvec.STOCK)
    plot(nineperma.STOCK,'r')
    
    subplot(numPlots,1,4)
    cla
    bp = bar(B.INDX,'k');
    set(get(bp,'Children'),'FaceAlpha',0.2);
    hold on
    plot(macdvec.INDX)
    plot(nineperma.INDX,'r')
    
    subplot(numPlots,1,5)
    cla
    bar(vo.STOCK)
    hold on
    plot(xlim, [mean(vo.STOCK), mean(vo.STOCK)])
    
    
    subplot(numPlots,1,6)
    cla
    bar(vo.INDX)
    hold on
    plot(xlim, [mean(vo.INDX), mean(vo.INDX)])
    
    
    
    for j = 2:numPlots
        
        if j == 2
            subIndx = [1:2];
        else
            subIndx = j;
        end
        
        subplot(numPlots,1,subIndx)
        
        hold on
        axisView = get(handles.axisView, 'Value');
        xlim(gca, [0+axisView, 100+axisView])
        
        yLimits = ylim(gca);
        yLo = yLimits(1);
        yHi = yLimits(2);
        
        for i = 1:size(trades,1)
            xLo = trades(i,3);
            xHi = trades(i,4);
            
            xLong = [xLo xHi xHi xLo];
            yLong = [yLo yLo yHi yHi];
            
            hp = patch(xLong,yLong, [0.7, 1, .7], 'FaceAlpha', 0.25);
        end
    end
    
    pause(10/100);
    
end

return;
