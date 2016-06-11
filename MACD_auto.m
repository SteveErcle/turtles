
% MACD testing

clc; close all; clear all;

as1 = ['A',num2str(150)];%1
as2 = ['A',num2str(225)];%400

[~,allStocks] = xlsread('allStocks', [as1, ':', as2]);

% allStocks = {'SGY'} % QQQ ABX
% preRange = 1:400;
preRange = 401:799;

% portfolio = {'CYCC'}; %GEVO %NUGT %LABU %IMMU %ENDP %CCXI %CYCC
roiCong = [];
for k = 1:length(allStocks)
    
    
    
    stock = allStocks{k}
    
    try
    
    % stock = 'LABU';
    indx = 'SPY';
    exchange = 'NASDAQ';
    
    
    INTRA = 1;
    DAILY = 0;
    
    past = now - 400;
    pres = now ;
    
    
    tf = TurtleFun;
    td = TurtleData;
    ta = TurtleAuto;
    
    ta.slPercent = 0.25;
    
    numPlots = 7;
    
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
        da.STOCK = daD;
        [hiA, loA, clA, opA, daA, voA] = tf.returnOHLCDarray(avgAll);
        cl.INDX = clA;
        
        isFlip = 1;
        len = length(clD)-1;
    end
    
    
    if INTRA
        iAll.STOCK = IntraDayStockData(stock,exchange,'600','20d');
        
        iAll.INDX = IntraDayStockData(indx,exchange,'600', '20d');
        
        for i_d = 1:length(iAll.INDX.date)
            if iAll.STOCK.date(i_d) ~= iAll.INDX.date(i_d)
                iAll.STOCK.close = [iAll.STOCK.close(1:i_d-1); NaN; iAll.STOCK.close(i_d:end)];
                iAll.STOCK.high = [iAll.STOCK.high(1:i_d-1); NaN; iAll.STOCK.high(i_d:end)];
                iAll.STOCK.low = [iAll.STOCK.low(1:i_d-1); NaN; iAll.STOCK.low(i_d:end)];
                iAll.STOCK.volume = [iAll.STOCK.volume(1:i_d-1); NaN; iAll.STOCK.volume(i_d:end)];
                iAll.STOCK.datestring = [iAll.STOCK.datestring(1:i_d-1); NaN; iAll.STOCK.datestring(i_d:end)];
                iAll.STOCK.date = [iAll.STOCK.date(1:i_d-1); NaN; iAll.STOCK.date(i_d:end)];
            end
            
        end
        
        iAll.STOCK = td.getAdjustedIntra(iAll.STOCK);
        
        iAll.INDX = td.getAdjustedIntra(iAll.INDX);

        
        iAll.STOCK.high = iAll.STOCK.high(preRange);
        iAll.STOCK.low = iAll.STOCK.low(preRange);
        iAll.STOCK.open = iAll.STOCK.open(preRange);
        iAll.STOCK.close = iAll.STOCK.close(preRange);
        iAll.STOCK.volume = iAll.STOCK.volume(preRange);
        iAll.STOCK.date = iAll.STOCK.date(preRange);
        
        iAll.INDX.close = iAll.INDX.close(preRange);
        iAll.INDX.volume = iAll.INDX.volume(preRange);
        
        
        if length(iAll.STOCK.close) ~= length(iAll.INDX.close)
            disp('Length Error')
            return
        end
        
        isFlip = 0;
        len = length(iAll.STOCK.close)-1;
    end
    
    ta.ind = 50-1;
    
    while ta.ind <= len
        
        ta.ind = ta.ind + 1;
        range = 1:ta.ind;
        
        if INTRA
            ta.hi.STOCK = iAll.STOCK.high(range);
            ta.lo.STOCK = iAll.STOCK.low(range);
            ta.op.STOCK = iAll.STOCK.open(range);
            ta.cl.STOCK = iAll.STOCK.close(range);
            ta.vo.STOCK = iAll.STOCK.volume(range);
            ta.da.STOCK = iAll.STOCK.date(range);
            
            ta.cl.INDX = iAll.INDX.close(range);
            ta.vo.INDX = iAll.INDX.volume(range);
        end
        
        if DAILY
            ta.hi.STOCK = hiD(range);
            ta.lo.STOCK = loD(range);
            ta.op.STOCK = opD(range);
            ta.cl.STOCK = clD(range);
            ta.vo.STOCK = voD(range);
            ta.da.STOCK = daD(range);
            
            ta.cl.INDX = clA(range);
            ta.vo.INDX = voA(range);
        end
        
        ta.calculateData(isFlip);
        
        ta.checkConditions();
        
        ta.executeBullTrade();
        
        ta.executeBearTrade();
        
        %      if ta.ind >= 147 && ta.ind < 160
        %         figure(1)
        %         cla
        %         candle(ta.hi.STOCK, ta.lo.STOCK, ta.cl.STOCK, ta.op.STOCK, 'blue');
        %         hold on
        %         plot(xlim, [ta.stopLoss.BEAR, ta.stopLoss.BEAR])
        %         pause
        %      end
        
        
        
        
        
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
    
    
    
    roiLong = (ta.trades.BULL(:,2) - ta.trades.BULL(:,1)) ./ ta.trades.BULL(:,1) * 100;
    
    sL = sum(roiLong(~isnan(roiLong)));
    
    sL/length(ta.trades.BULL);
    
    
    
    roiShort = (ta.trades.BEAR(:,1) - ta.trades.BEAR(:,2)) ./ ta.trades.BEAR(:,1) * 100;
    
    sS = sum(roiShort(~isnan(roiShort)));
    %     sS/length(ta.trades.BULL)
    disp([sL, sS])
    
    %     pause
    
    catch
        sL = 0;
        sS = 0;
    end
    
    roiCong = [roiCong; sL, sS];
    
end


return


delete(slider);
handles = guihandles(slider);


len = length(ta.cl.INDX);
set(handles.axisView, 'Max', len, 'Min', 0);
set(handles.axisView, 'SliderStep', [1/len, 10/len]);
set(handles.axisView, 'Value', 0);


while(true)
    
    subplot(numPlots,1,[1:2])
    cla
    candle(ta.hi.STOCK, ta.lo.STOCK, ta.cl.STOCK, ta.op.STOCK, 'blue');
    hold on
    
    
    subplot(numPlots,1,3)
    cla
    bp = bar(ta.B.STOCK,'k');
    set(get(bp,'Children'),'FaceAlpha',0.2);
    hold on
    plot(ta.macdvec.STOCK)
    plot(ta.nineperma.STOCK,'r')
    
    subplot(numPlots,1,4)
    cla
    bp = bar(ta.B.INDX,'k');
    set(get(bp,'Children'),'FaceAlpha',0.2);
    hold on
    plot(ta.macdvec.INDX)
    plot(ta.nineperma.INDX,'r')
    
    subplot(numPlots,1,5)
    cla
    bar(ta.vo.STOCK)
    hold on
    plot(xlim, [mean(ta.vo.STOCK), mean(ta.vo.STOCK)])
    
    
    subplot(numPlots,1,6)
    cla
    bar(ta.vo.INDX)
    hold on
    plot(xlim, [mean(ta.vo.INDX), mean(ta.vo.INDX)])
    
    subplot(numPlots,1,7)
    cla
    plot(ta.rsi.STOCK)
    hold on
    plot(xlim, [50,50])
    plot(xlim, [70,70])
    plot(xlim, [30,30])
    %     cla
    %     bar(ta.RSIderv)
    %     plot(clSma,'b')
    %     hold on
    %     plot(clAma, 'r')
    %     plot(clRma, 'k')
    
    
    
    
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
        
        for i = 1:size(ta.trades.BEAR,1)
            xLo = ta.trades.BEAR(i,3);
            xHi = ta.trades.BEAR(i,4);
            
            if j == 2
                yLo = min(ta.trades.BEAR(i,1:2));
                yHi = max(ta.trades.BEAR(i,1:2));
            end
            
            xLong = [xLo xHi xHi xLo];
            yLong = [yLo yLo yHi yHi];
            
            if roiShort(i) < 0
                color = [1, .7, .7];
            else
                color = [0.7, 1, .7];
            end
            
            hp = patch(xLong,yLong, color, 'FaceAlpha', 0.25);
            
        end
        
        for i = 1:size(ta.trades.BULL,1)
            xLo = ta.trades.BULL(i,3);
            xHi = ta.trades.BULL(i,4);
            
            if j == 2
                yLo = min(ta.trades.BULL(i,1:2));
                yHi = max(ta.trades.BULL(i,1:2));
            end
            
            xLong = [xLo xHi xHi xLo];
            yLong = [yLo yLo yHi yHi];
            
            if roiLong(i) < 0
                color = [1, .7, .7];
            else
                color = [0.7, 1, .7];
            end
            
            hp = patch(xLong,yLong, color, 'FaceAlpha', 0.25);
        end
        
    end
    
    pause(10/100);
    
end

return;
