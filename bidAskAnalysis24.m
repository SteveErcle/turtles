% bidAskAnalysis

clc; close all; clear all;

load('accumSpread24Day');
load('dataCongDay');


delete(slider);
handles = guihandles(slider);

set(handles.axisView, 'Max', length(hi), 'Min', 1);
set(handles.axisView, 'SliderStep', [1/length(hi), 10/length(hi)]);
set(handles.axisView, 'Value', 1);

set(handles.axisLen, 'Max', 1000, 'Min', 0);
set(handles.axisLen, 'SliderStep', [1/1000, 10/1000]);
set(handles.axisLen, 'Value', 0);



tf = TurtleFun;


dataCongDay = dataCong(1054:1386,:);
[hiP, loP, clP, opP, daP] = tf.returnOHLCDarray(dataCongDay);


% windSize = 9;
% 
% clAS =  (cl - mean(cl)) ./ std(cl);
% clASma = tsmovavg((clAS),'s', windSize ,1);
% 
% clPA =  (clP - mean(clP)) ./ std(clP);
% clPAma = tsmovavg((clPA),'s', windSize ,1);
% 
% plot(clAS, 'r')
% hold on
% plot(clPA)

figure
subplot(2,1,1)
title('AS');
hold on;
candle(hi/1000, lo/1000, cl/1000, op/1000, 'blue');

subplot(2,1,2)
title('PA')
hold on;
candle(hiP, loP, clP, opP, 'blue');





p = 0;
while(true)
    
    set(0, 'CurrentFigure', 1)
    timeSlide = get(handles.axisView, 'Value');
    zeroSlide = floor(get(handles.axisLen, 'Value'));
    subplot(2,1,1)
    p(1) = plot([timeSlide, timeSlide], ylim);
    subplot(2,1,2)
    p(2) = plot([timeSlide, timeSlide], ylim);
    
    pause(0.1)
    
    if p ~= 0
        delete(p)
    end
    
%     clAS =  (cl - mean(cl)) ./ std(cl);
%     clASma = tsmovavg((clAS),'s', windSize ,1);
%     clAS = [zeros(zeroSlide,1); clAS];
%     
%     
%     cla
%     plot(clAS, 'r')
%     hold on
%     plot(clPA)
%     
    
    
end