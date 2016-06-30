% auto_ib_testMinutely

clc; close all; %clear all;

as1 = ['A',num2str(1)];%1
as2 = ['A',num2str(400)];%400
[~,allStocks] = xlsread('listOfStocks', [as1, ':', as2]);

% allStocks = allStocks([1]);
allStocks = {'NUGT'}

ta = TurtleAutoRealTime;
td = TurtleData;

ib = ibtws('',7497);
pause(1)
ibBuiltInErrMsg

ibContract = ib.Handle.createContract;
ibContract.secType = 'STK';
ibContract.exchange = 'SMART';
ibContract.currency = 'USD';


load('tenTimes')
load('weeklyDates')
startDate = weeklyDates(end-3)-4;
endDate   = weeklyDates(end-3)


for k = 0:length(allStocks)
    
    pause(1)
    
    if k == 0
        stock = 'SPY'
        ibContract.symbol = stock;
        
        allData.SPY = timeseries(ib, ibContract, startDate, endDate, '1 min' , '', true);
        
        if ~isnumeric(allData.SPY(1))
            disp('Service Error')
            return
        end
    else
        stock = allStocks{k}
        ibContract.symbol = stock;
        
        allData.(stock) = timeseries(ib, ibContract, startDate, endDate, '1 min', '', true);
        
        if length(allData.(stock)) ~= length(allData.SPY)
            disp('Length Error')
            return
        end
    end
    
    ten.(stock).Hi = nan;
    ten.(stock).Lo = nan;
    ten.(stock).Op = nan;
    ten.(stock).Cl = nan;
    ten.(stock).Vo = 0;
    ten.(stock).data = [];
    
end


for i = 1:length(allData.SPY)
    
    ten.SPY = td.genTen(ten.SPY, allData.SPY, i, tenTimes);
    ten.(stock) = td.genTen(ten.(stock), allData.(stock), i, tenTimes);
    
    
    if size(ten.SPY.data,1) >= 50
        
        ta.organizeDataIB(ten.SPY.data, 'indx');
        ta.organizeDataIB(ten.(stock).data, 'stock');
        ten.SPY.data(end,1);
        ten.(stock).data(end,1);
        
        if length(ten.SPY.data) == 55
            111
        end 
        
        ta.setStock(stock);
        ta.calculateData(0);
        ta.setStopLoss();
        ta.checkConditions();
        ta.executeBullTrade();
        ta.executeBearTrade();
        
%         disp([ta.condition.Not_Stopped_Out.BULL,...
%             ta.condition.Large_Volume,...
%             ta.condition.Not_End_of_Day,...
%             ta.condition.Above_MA.BULL,...
%             ta.condition.Below_MA.BEAR])
        
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



% stock = 'ACHN'
% ibContract.symbol = stock;
% data.(stock) = timeseries(ib, ibContract, startDate, endDate, '10 mins', '', true);
% [da, op, hi, lo, cl, vo] = td.organizeDataIB(data.(stock));
% disp([op, ten.(stock).data(:,2), op == ten.(stock).data(:,2)])
% disp([hi, ten.(stock).data(:,3), hi == ten.(stock).data(:,3)])
% disp([lo, ten.(stock).data(:,4), lo == ten.(stock).data(:,4)])
% disp([cl, ten.(stock).data(:,5), cl == ten.(stock).data(:,5)])
% disp([vo, ten.(stock).data(:,6), vo == ten.(stock).data(:,6)])










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




