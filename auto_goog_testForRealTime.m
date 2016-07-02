% auto_goog_testForRealTime



clc; close all; clear all;

WATCH = 0;
PULL  = 0;

as1 = ['A',num2str(1)];%1
as2 = ['A',num2str(400)];%400
[~,allStocks] = xlsread('listOfStocks', [as1, ':', as2]);

% allStocks = allStocks([1:20]);
% allStocks = {'HALO'};

% delete(watchConditions);
% handles = guihandles(watchConditions);


ta = TurtleAuto;
td = TurtleData;

% ta.slPercentFirst = nan; 
% ta.slPercentSecond = nan;

numPlots = 5;
exchange = 'NASDAQ';


load('weeklyDates')
startDate = weeklyDates(end-3)-4
endDate   = weeklyDates(end-3)

if PULL == 1
    for k = 0:length(allStocks)
        
        pause(1)
        
        if k == 0
            stock = 'SPY'
            allData.SPY = IntraDayStockData(stock,exchange,'600','5d');
            allData.SPY = td.getAdjustedIntra(allData.SPY);
            
        else
            stock = allStocks{k}
            
            try
                temp = IntraDayStockData(stock,exchange,'600','5d');
                
                %         for i_d = 1:length(iAll.INDX.date)
                %             if iAll.STOCK.date(i_d) ~= iAll.INDX.date(i_d)
                %                 iAll.STOCK.close = [iAll.STOCK.close(1:i_d-1); NaN; iAll.STOCK.close(i_d:end)];
                %                 iAll.STOCK.high = [iAll.STOCK.high(1:i_d-1); NaN; iAll.STOCK.high(i_d:end)];
                %                 iAll.STOCK.low = [iAll.STOCK.low(1:i_d-1); NaN; iAll.STOCK.low(i_d:end)];
                %                 iAll.STOCK.volume = [iAll.STOCK.volume(1:i_d-1); NaN; iAll.STOCK.volume(i_d:end)];
                %                 iAll.STOCK.datestring = [iAll.STOCK.datestring(1:i_d-1); NaN; iAll.STOCK.datestring(i_d:end)];
                %                 iAll.STOCK.date = [iAll.STOCK.date(1:i_d-1); NaN; iAll.STOCK.date(i_d:end)];
                %             end
                %         end
                
                temp = td.getAdjustedIntra(temp);
                
                if length(temp.close) ~= length(allData.SPY.close)
                    disp('Length Error')
                else
                    allData.(stock) = temp;
                end
                
            catch
                disp('Failed to pull stock data')
            end 
        end
    end
else
    load('allData')
end

% stock = 'AMKR'
% temp.STOCK = allData.(stock);
% temp.INDX = allData.SPY;
% clear allData;
% allData = [];
% allData.SPY = temp.INDX;
% allData.(stock) = temp.STOCK;


allStocks = fieldnames(allData); allStocks = allStocks(2:end);
len = size(allData.SPY.close,1)-1;
ta.ind = 50-1;


while ta.ind <= len
    
    ta.ind = ta.ind + 1;
    range = 1:ta.ind;
    
    disp(ta.ind)
        
    for k = 1:length(allStocks)
        
        if ta.enterMarket.BULL || ta.enterMarket.BEAR
            stock = ta.enteredStock
        else
            stock = allStocks{k};
        end
        
        ta.organizeDataGoog(allData.(stock), allData.SPY, range);
        
        ta.setStock(stock);
        ta.calculateData(0);
        ta.setStopLoss();
        %BREAK EVEN STOP
        ta.checkConditionsUsingInd();
        ta.executeBullTrade();
        ta.executeBearTrade();
        
        
        if ta.enterMarket.BULL || ta.enterMarket.BEAR
            break
        end
        
%         disp(ta.ind)
        
    end
    
%     if ta.condition.Not_Stopped_Out.BULL == 0 || ta.condition.Not_Stopped_Out.BEAR == 0
%         ta.ind = ta.ind + 1;
%     end 
    
    
end



try
    roiLong = (ta.trades.BULL(:,2) - ta.trades.BULL(:,1)) ./ ta.trades.BULL(:,1) * 100;
    sL = sum(roiLong(~isnan(roiLong)));
catch
    roiLong = 0;
    sL = 0;
end

try
    roiShort = (ta.trades.BEAR(:,1) - ta.trades.BEAR(:,2)) ./ ta.trades.BEAR(:,1) * 100;
    sS = sum(roiShort(~isnan(roiShort)));
catch
    roiShort = 0;
    sS = 0;
end

disp([sL, sS, size(ta.trades.BULL,1) + size(ta.trades.BEAR,1)])

principal = 20000;
principal = principal*(1+(sL+sS)/100) - (size(ta.trades.BULL,1) + size(ta.trades.BEAR,1))*20;

disp(principal)

return

delete(slider);
handles = guihandles(slider);


len = length(ta.cl.INDX);
set(handles.axisView, 'Max', len, 'Min', 0);
set(handles.axisView, 'SliderStep', [1/len, 10/len]);
set(handles.axisView, 'Value', 0);

figure

while(true)
    
    subplot(numPlots,1,[1:2])
    cla
    candle(ta.hi.STOCK, ta.lo.STOCK, ta.cl.STOCK, ta.op.STOCK, 'blue');
    hold on
    plot(ta.clSma,'b')
    
    
    
    subplot(numPlots,1,3)
    cla
    candle(ta.hi.INDX, ta.lo.INDX, ta.cl.INDX, ta.op.INDX, 'red');
    hold on
    plot(ta.clAma,'r')
    
    subplot(numPlots,1,4)
    cla
    bar(ta.vo.STOCK)
    hold on
    plot(xlim, [mean(ta.vo.STOCK), mean(ta.vo.STOCK)])
    
    subplot(numPlots,1,5)
    cla
    bar(ta.vo.INDX)
    hold on
    plot(xlim, [mean(ta.vo.INDX), mean(ta.vo.INDX)])
    
    
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






