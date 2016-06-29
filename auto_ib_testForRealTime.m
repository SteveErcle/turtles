% auto_ib_testForRealTime

% auto_ib

clc; close all; clear all;


as1 = ['A',num2str(1)];%1
as2 = ['A',num2str(400)];%400
[~,allStocks] = xlsread('listOfStocks', [as1, ':', as2]);

allStocks = allStocks([1:10,20:30]);

ta = TurtleAuto;

ib = ibtws('',7497);
pause(1)
ibBuiltInErrMsg

ibContract = ib.Handle.createContract;
ibContract.secType = 'STK';
ibContract.exchange = 'SMART';
ibContract.currency = 'USD';

ibContract.symbol = 'SPY';

startDate = datenum('06/20');
endDate   = datenum('06/24');

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

len = size(data.SPY,1)-1;
ta.ind = 50-1;

while ta.ind <= len
    
    ta.ind = ta.ind + 1;
    range = 1:ta.ind;
    
    disp(ta.ind)
    
    for k = 1:length(allStocks)

        if ta.enterMarket.BULL || ta.enterMarket.BEAR
            stock = ta.enteredStock;
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




