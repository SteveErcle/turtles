
% volumeStudy


clc; 
clear all; 
close all;

simPres         = 1;
aniLen          = 1;
axisLen         = 100;
aniSpeed        = 0.1;

daysForCrossVal = 10;
daysIntoPast    = 400;

stock = 'CLDX'
exchange = 'NYSE';


past = '1/1/08';
simulateFrom = '1/1/12';
simulateTo = '2/1/12';

arduinoControl = 1;

%%

ts = TurtleSim;
tf = TurtleFun;
td = TurtleData;
delete(turtleSimGui)


[mAll, mCong, wAll, wCong, dAll, dCong] = td.getData(stock, past, simulateFrom, simulateTo);
% td.saveData(stock, mAll, mCong, wAll, wCong, dAll,dCong);

% [mAll, mCong, wAll, wCong, dAll, dCong] = td.loadData(stock);
% 
% startDay = dCong(end,1);
% 
% simPres = td.getDateIndx(dAll(:,1), startDay)-20;
% aniLen = 20;
% 
% handles = guihandles(turtleSimGui);
% 
% dPast = td.resetPast(dCong, dAll, startDay);
% wPast = td.resetPast(wCong, wAll, startDay);
% mPast = td.resetPast(mCong, mAll, startDay);
% 
% hlcoDs = TurtleVal(dCong);
% hlcoDp = TurtleVal(dAll);
