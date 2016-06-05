
clc; close all; clear all;


bid.xLo = 1; bid.xHi = 4;
bid.yLo = 0; bid.yHi = 5;

bid.x = [bid.xLo bid.xHi bid.xHi bid.xLo];
bid.y = [bid.yLo bid.yLo bid.yHi bid.yHi];

ask.xLo = 6; ask.xHi = 9;
ask.yLo = 0; ask.yHi = 7;

ask.x = [ask.xLo ask.xHi ask.xHi ask.xLo];
ask.y = [ask.yLo ask.yLo ask.yHi ask.yHi];


plot([5,5], [0,10])

hp = patch(bid.x,bid.y, [0.9,1,1]);

hp = patch(ask.x,ask.y, [0.9,1,1]);