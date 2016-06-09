
% MACD testing

clc; close all; clear all;

portfolio = {'TSLA'};
    
for k = 1:length(portfolio)
    
    stock = portfolio{k}
    
    % stock = 'LABU';
    indx = 'SPY';
    exchange = 'NASDAQ';
    
    
    INTRA = 0;
    DAILY = 1;
    
    past = now - 200;
    pres = now ;
    
    
    tf = TurtleFun;
    td = TurtleData;
    ta = TurtleAuto;
    
    ta.slPercent = .250;
    
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
        [hiA, loA, clA, opA, daA, voA] = tf.returnOHLCDarray(avgAll);
        cl.INDX = clA;
        
        isFlip = 1;
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
        
        isFlip = 0;
        len = length(iAll.STOCK.close)-1;
    end
    
    
    
    figure
    
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
            
            ta.cl.INDX = iAll.INDX.close(range);
            ta.vo.INDX = iAll.INDX.volume(range);
        end
        
        if DAILY
            ta.hi.STOCK = hiD(range);
            ta.lo.STOCK = loD(range);
            ta.op.STOCK = opD(range);
            ta.cl.STOCK = clD(range);
            ta.vo.STOCK = voD(range);
            
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
    bar(ta.RSIderv)
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
            
            hp = patch(xLong,yLong, [1, .7, .7], 'FaceAlpha', 0.25);
            
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
            
            hp = patch(xLong,yLong, [0.7, 1, .7], 'FaceAlpha', 0.25);
        end
        
    end
    
    pause(10/100);
    
end

return;
