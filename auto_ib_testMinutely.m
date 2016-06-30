% auto_ib_testMinutely

% clc; close all; clear all;
% 
% as1 = ['A',num2str(1)];%1
% as2 = ['A',num2str(400)];%400
% [~,allStocks] = xlsread('listOfStocks', [as1, ':', as2]);
% 
% allStocks = allStocks([1]);
% 
% 
% ta = TurtleAuto;
% 
% ib = ibtws('',7497);
% pause(1)
% ibBuiltInErrMsg
% 
% ibContract = ib.Handle.createContract;
% ibContract.secType = 'STK';
% ibContract.exchange = 'SMART';
% ibContract.currency = 'USD';
% 
% ibContract.symbol = 'SPY';
% 
% load('tenTimes')
% load('weeklyDates')
% startDate = weeklyDates(end-4)-1;%datenum('06/20');
% endDate   = weeklyDates(end-4)
% 
% data.SPY = timeseries(ib, ibContract, startDate, endDate, '1 min' , '', true);
% if ~isnumeric(data.SPY(1))
%     disp('Service Error')
%     return
% end 
% 
% for k = 1:length(allStocks)
%     
%     pause(1)
%     stock = allStocks{k}
%     
%     ibContract.symbol = stock;
%     data.(stock) = timeseries(ib, ibContract, startDate, endDate, '1 min', '', true);
%     
%     if length(data.(stock)) ~= length(data.SPY)
%         disp('Length Error')
%         return
%     end
%     
% end


ten.Hi = nan;
ten.Lo = nan;
ten.Op = nan;
ten.Cl = nan;
ten.Vo = 0;
ten.data = [];

td = TurtleData;

for i = 1:length(data.(stock))
    
    ten = td.genTen(ten, data.(stock), i, tenTimes);
    
%     datestr(data.(stock)(i,1),15)
%     [da, op, hi, lo, cl, vo] = td.organizeDataIB(data.(stock)(i,:));
%      
%     if hi > tenHi || isnan(tenHi)
%         tenHi = hi;
%     end
%     
%     if lo < tenLo || isnan(tenLo)
%         tenLo = lo;
%     end
%     
%     currentTime = datestr(da,15);
%     if sum(str2double(currentTime(1,[1:2,4:5])) == tenTimes)
%         tenly = [tenly; nan,nan,nan,nan];
%         tenOp = op; 
%     end
%     
%     tenCl = cl;
%     tenVo = tenVo + vo;
%     
%     tenly(end,:) = [tenOp, tenHi, tenLo, tenCl]
%     
%     if sum(str2double(currentTime(1,[1:2,4:5])) == tenTimes+9)
%         tenHi = nan;
%         tenLo = nan;
%         tenOp = nan;
%         tenCl = nan;
%         tenVo = 0;
%     end
   
  
%     disp([op,cl])
    
%     pause
    
end

data.(stock) = timeseries(ib, ibContract, startDate, endDate, '10 mins', '', true);
disp([op, ten.data(:,1), op == ten.data(:,1)])
disp([hi, ten.data(:,2), hi == ten.data(:,2)])
disp([lo, ten.data(:,3), lo == ten.data(:,3)])
disp([cl, ten.data(:,4), cl == ten.data(:,4)])










