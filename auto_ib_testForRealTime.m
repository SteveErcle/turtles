% auto_ib_testForRealTime

clc; close all; clear all;


as1 = ['A',num2str(1)];%1
as2 = ['A',num2str(400)];%400
[~,allStocks] = xlsread('listOfStocks', [as1, ':', as2]);

% allStocks = allStocks([1:10,20:30]);
allStocks = {'HALO'};

ta = TurtleAuto;

ib = ibtws('',7497);
pause(1)
ibBuiltInErrMsg

numPlots = 5;

ibContract = ib.Handle.createContract;
ibContract.secType = 'STK';
ibContract.exchange = 'SMART';
ibContract.currency = 'USD';

ibContract.symbol = 'SPY';

load('weeklyDates')
startDate = weeklyDates(end-3)-4
endDate   = weeklyDates(end-3)

data.SPY = timeseries(ib, ibContract, startDate, endDate, '10 mins' , '', true);
if ~isnumeric(data.SPY(1))
    disp('Service Error')
    return
end 

for k = 1:length(allStocks)
    
    pause(1)
    stock = allStocks{k}
    
    ibContract.symbol = stock;
    data.(stock) = timeseries(ib, ibContract, startDate, endDate, '10 mins', '', true);
    
    if length(data.(stock)) ~= length(data.SPY)
        disp('Length Error')
        return
    end
    
end

ta = TurtleAuto;
len = size(data.SPY,1)-1;
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
        
        ta.organizeDataIB(data.(stock)(range,:), data.SPY(range,:));
        
        ta.setStock(stock);
        ta.calculateData(0);
        ta.setStopLoss();
        ta.checkConditionsUsingInd();
        ta.executeBullTrade();
        ta.executeBearTrade();
        
        
        if ta.enterMarket.BULL || ta.enterMarket.BEAR
            break
        end
        
    end
    
end

roiLong = (ta.trades.BULL(:,2) - ta.trades.BULL(:,1)) ./ ta.trades.BULL(:,1) * 100;
sL = sum(roiLong);

roiShort = (ta.trades.BEAR(:,1) - ta.trades.BEAR(:,2)) ./ ta.trades.BEAR(:,1) * 100;
sS = sum(roiShort);

disp([sL, sS, length(ta.trades.BULL) + length(ta.trades.BEAR)])
        
principal = 20000;
principal = principal*(1+(sL+sS)/100) - (length(ta.trades.BULL) + length(ta.trades.BEAR))*20;

disp(principal)



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


