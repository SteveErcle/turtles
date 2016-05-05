% forexPractice

clc; close all; clear all;

tc = TurtleCall;

forex = csvread('EURUSD0316.csv', 0,2);


op = forex(:,1); hi = forex(:,2); lo = forex(:,3); cl = forex(:,4);

figure('Color',[0.1 0.1 0.1]);
set (gcf, 'WindowButtonMotionFcn', @tc.callMouse);
set (gcf, 'KeyPressFcn', @tc.callKey);
set(gca, 'XColor', [0.8 0.8 0.8]); set(gca, 'YColor', [0.8 0.8 0.8]);

cla; hold on; set(gca,'Color',[0 0 0]);
candle(hi, lo, cl, op, 'cyan');

xlimit = xlim;

pHandle = 0;

while(true)
    
    if pHandle ~= 0
        delete(pHandle)
    end 
    
    if ~isempty(tc.P)
       pHandle = plot([xlimit(1), xlimit(2)], [tc.P(1,2), tc.P(1,2)]);
    end
    
    pause(0.025)
    
end