% bidAskAnalysis

clc; close all; clear all;

load('accumSpread26Day.mat');
load('price26Day.mat');


delete(slider);
handles = guihandles(slider);

set(handles.axisView, 'Max', accumSpread.ti(end), 'Min', accumSpread.ti(1));
set(handles.axisView, 'SliderStep', [1/length(accumSpread.hi), 10/length(accumSpread.hi)]);
set(handles.axisView, 'Value', accumSpread.ti(1));

set(handles.axisLen, 'Max', 1000, 'Min', 0);
set(handles.axisLen, 'SliderStep', [1/1000, 10/1000]);
set(handles.axisLen, 'Value', 0);


priceAction.price = priceAction.price(841:1440,:);
priceAction.op = priceAction.price(:,2);
priceAction.hi = priceAction.price(:,3);
priceAction.lo = priceAction.price(:,4);
priceAction.cl = priceAction.price(:,5);

tf = TurtleFun;
j = 1;

inv = 30;
for i = 1:inv: 600%length(accumSpread.hi)-1

    accumSpread.inv.hi(j) =  max(accumSpread.hi(i:i+inv-1))';
    accumSpread.inv.lo(j) =  min(accumSpread.lo(i:i+inv-1));
    accumSpread.inv.op(j) =  accumSpread.op(i);
    accumSpread.inv.cl(j) =  accumSpread.cl(i+inv-1);
    accumSpread.inv.ti(j) =  accumSpread.ti(i);
    
    
    priceAction.inv.hi(j) =  max(priceAction.hi(i:i+inv-1))';
    priceAction.inv.lo(j) =  min(priceAction.lo(i:i+inv-1));
    priceAction.inv.op(j) =  priceAction.op(i);
    priceAction.inv.cl(j) =  priceAction.cl(i+inv-1);
    
    
    j = j + 1;
    
end 
    
priceAction.inv.ti =  accumSpread.inv.ti;

subplot(2,1,1)
candle(accumSpread.inv.hi', accumSpread.inv.lo', accumSpread.inv.cl', accumSpread.inv.op', 'blue', accumSpread.inv.ti');
hold on
subplot(2,1,2)
candle(priceAction.inv.hi', priceAction.inv.lo', priceAction.inv.cl', priceAction.inv.op', 'blue', priceAction.inv.ti');
hold on
    
% return
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

% figure
% subplot(2,1,1)
% title('AS');
% hold on;
% candle(accumSpread.hi, accumSpread.lo , accumSpread.cl, accumSpread.op, 'blue', accumSpread.ti);
%   
% 
% subplot(2,1,2)
% title('PA')
% hold on;
% candle(priceAction.hi, priceAction.lo , priceAction.cl, priceAction.op, 'blue', priceAction.ti);
%        




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