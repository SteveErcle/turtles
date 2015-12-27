
clear 
close all
clc


xdata = 1:100;
ydata = 1:100;


plot(xdata, ydata);


cursor = datacursormode(gcf)

position = cursor.CurrentDataCursor.getCursorInfo.Position(1:2)

hold on

plot(position(1), position(2), 'go');


