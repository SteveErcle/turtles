% analyzeBidAsk
clc; close all; clear all;

load('bidAskData');


delete(slider);
handles = guihandles(slider);


volume(volume == 0) = [];
price(price == 0) = [];
bid(bid == 0) = [];
ask(ask == 0) = [];
bidSize(bidSize == 0) = [];
askSize(askSize == 0) = [];
timeCollected(timeCollected == 0) = [];
tradeSize(tradeSize == 0) = [];

set(handles.axisView, 'Max', timeCollected(end), 'Min', timeCollected(1));
set(handles.axisView, 'SliderStep', [1/length(timeCollected), 10/length(timeCollected)]);
set(handles.axisView, 'Value', timeCollected(1));

set(handles.axisLen, 'Max', 1000, 'Min', 0);
set(handles.axisLen, 'SliderStep', [1/1000, 10/1000]);
set(handles.axisLen, 'Value', 0);


range = 1:1986;

figure
hold all;
plot(tradeSize(range), '.')
plot(bidSize(range), '.')
plot(askSize(range), '.')
legend('Trade', 'Bid', 'Ask')

waterLevel = 0;
waterRecord = [];

for i = range
    
    %     disp('Trade, Bid, Ask, Volume, Price')
    %     disp([bidSize(i), askSize(i), volume(i)-volume(i-1), price(i)])
    
    %     volDelta = volume(i) - volume(i-1);
    %     bidCalc  = volDelta*(bidSize(i)/ (bidSize(i) + askSize(i)));
    %     askCalc  = volDelta*(askSize(i)/ (bidSize(i) + askSize(i)));
    
    %     sprintf('%0.2f', bidCalc*bid(i));
    %     sprintf('%0.2f', askCalc*ask(i));
    
    flowRate = bidSize(i)*bid(i) - askSize(i)*ask(i);
    waterLevel  = waterLevel + flowRate;
    waterRecord = [waterRecord; waterLevel];
    
    
    
    
    
    
    %     pause
    
end

window_size = 200;

priceMA = tsmovavg(price(range),'e',window_size,1);


waterRecordMA = tsmovavg((waterRecord),'e',window_size,1);



cla
subplot(2,1,1)
hold on;
plot(timeCollected(range), waterRecordMA, 'r')
plot(timeCollected(range),waterRecord)
plot([timeCollected(1), timeCollected(end)], [0,0], 'k')

ylimit1 = ylim
subplot(2,1,2)
hold on;
plot(timeCollected(range), price(range))
plot(timeCollected(range), priceMA, 'r')
ylimit2 = ylim

figure(2)
hold on;

p = 0;
while(true)
    
    set(0, 'CurrentFigure', 1)
    timeSlide = get(handles.axisView, 'Value')
    subplot(2,1,1)
    p(1) = plot([timeSlide, timeSlide], [ylimit1(1), ylimit1(2)]);
    subplot(2,1,2)
    p(2) = plot([timeSlide, timeSlide], [ylimit2(1), ylimit2(2)]);
    
    pause(0.1)
    
    if p ~= 0
        delete(p)
    end
    
    
    set(0, 'CurrentFigure', 2)
    cla
    zeroSlide = floor(get(handles.axisLen, 'Value'));
    wStand = [];
    pStand = [];
    wrnn = [];
    pnn = [];
    wrnn = waterRecordMA(~isnan(waterRecordMA));
    pnn  = priceMA(~isnan(priceMA));
    wStand = (wrnn - mean(wrnn)) ./ std(wrnn);
    pStand = (pnn - mean(pnn)) ./ std(pnn);
    
    wStand = [zeros(zeroSlide,1); wStand];
    
    plot(wStand,'b')
    plot(pStand,'r')

    pause(0.1)
    
    
end
