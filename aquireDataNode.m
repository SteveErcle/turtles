
clear all; close all; clc;

tf = TurtleFun;
td = TurtleData;

stock = 'CLDX'
exchange = 'NYSE';

past = '1/1/15';
simulateFrom = '11/15/15';
simulateTo = '1/1/16';


% [mAll, mCong, wAll, wCong, dAll, dCong] = td.getData(stock, past, simulateFrom, simulateTo);
% td.saveData(stock, mAll, mCong, wAll, wCong, dAll, dCong);

[mAll, mCong, wAll, wCong, dAll, dCong] = td.loadData(stock);

hlcoDs = TurtleVal(dAll);

figure()
[figM, pHandle] = tf.plotHiLoMultiple(mAll(2:end,:))
figure()
[figW, pHandle] = tf.plotHiLoMultiple(wAll(2:end,:))


checkDateFrom = hlcoDs.da(10);
checkDateTo = hlcoDs.da(10);


dateIndx = td.getDateIndx(mCong, checkDateTo)

tf = TurtleFun;

tf.plotOp(wCong(dateIndx,:), 3);
pause
tf.plotHiLoSolo(wCong(dateIndx,:), 3);

pause
ok = td.checkData(stock, wCong, hlcoDs, checkDateFrom, checkDateTo, 1, figW)

p = 0;


simDates = flipud(dAll(:,1))'

for i = simDates
    
    
    isNewDay = ts.isNewTimePeriod(dateIndx, dCong);
    isNewWeek = ts.isNewTimePeriod(dateIndx, wCong);
    isNewMonth = ts.isNewTimePeriod(dateIndx, mCong);
    
    
    if p(1) ~= 0 && isempty(find(mCong(:,1) == i))
        delete(p)
    end
    
    i
    
    pause
    s
end



