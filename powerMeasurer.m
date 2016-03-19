clc;
clear all;
close all;

stock = 'BAC'


%%

ts = TurtleSim;
tf = TurtleFun;
td = TurtleData;

% [mAll, mCong, wAll, wCong, dAll, dCong] = td.getData(stock, past, simulateFrom, simulateTo);
% td.saveData(stock, mAll, mCong, wAll, wCong, dAll,dCong);
[mAll, mCong, wAll, wCong, dAll, dCong] = td.loadData(stock);

dAllSmall = dAll(1:100,:);
[hi, lo, cl, op, da] = tf.returnOHLCDarray(dAllSmall);

[figHandle, pHandle] = tf.plotHiLoMultiple(dAllSmall);

for i = 1:length(dAllSmall)-1
    
%     cl(i) - op(i) + op(i+1) - cl(i)
    
    power = (cl(i) - cl(i+1) + hi(i) - 2*cl(i) + lo(i)) / cl(i+1)*100
    
    text(da(i), hi(i), strcat(num2str(power)));
    
end