
clc
clear all
close all



stock = 'DBC';
c = yahoo;
w = fetch(c,stock,now, now-6000, 'm');
close(c)

handles = guihandles(giua);


% highlowFlex(handles.axesG, w(:,3), w(:,4),...
%     w(:,3), w(:,4),'blue',w(:,1));


h = highlow(w(:,3), w(:,4),...
    w(:,3), w(:,4),'blue',w(:,1));
set(gcf, 'Position', [0, 0, 1460, 700]);

set(giua, 'Position', [15, 210, 210, 5]);

hold on;


initView = 80
set(handles.slider1, 'Value', 0);
set(handles.slider1, 'Max', size(w,1)-initView-1, 'Min', 0);
set(handles.slider1, 'SliderStep', [1/(size(w,1)-initView), 10/(size(w,1)-initView)]);

highestR = 46.63;
lowestS  = 17.94;
for i = 1:9
    fluctLevs(i) = (highestR-lowestS)*((i-1)/8)+lowestS;
end
fluctLevs(end+1) = (highestR-lowestS)*(1/3)+lowestS
fluctLevs(end+1) = (highestR-lowestS)*(2/3)+lowestS

for i = 1:length(fluctLevs)
    %     set(handles.axesG, 'NextPlot', 'add');
    tLevs = w(end,1):w(1,1);
    %     plot(handles.axesG, tLevs , ones(1,length(tLevs))*fluctLevs(i), 'k')
    if i <= length(fluctLevs) - 2
        plot(tLevs , ones(1,length(tLevs))*fluctLevs(i), 'k')
    else
        plot(tLevs , ones(1,length(tLevs))*fluctLevs(i), 'c')
    end
    
end

for i = 1:9
    highLevs(i) = highestR*((i-1)/8);
end
highLevs(end+1) = highestR*1/3;
highLevs(end+1) = highestR*2/3;


for i = 1:length(highLevs)
    %     set(handles.axesG, 'NextPlot', 'add');
    tLevs = w(end,1):w(1,1);
    %     plot(handles.axesG, tLevs , ones(1,length(tLevs))*highLevs(i), 'g')
    if i <= length(highLevs) - 2
        plot(tLevs , ones(1,length(tLevs))*highLevs(i), 'r')
    else
        plot(tLevs , ones(1,length(tLevs))*highLevs(i), 'm')
    end
end


while(true)
    
    val = get(handles.slider1,'Value');
    
    startIndx = ceil(val);
    endIndx  = ceil(val)+initView;
    
    %     set(h, 'XLim', [w(end - startIndx,1)+4, w(end - endIndx,1)+4]);
    %     set(h, 'YLim', [min(w(end-endIndx:end-startIndx,4))*0.99, max(w(end-endIndx:end-startIndx,3))*1.01]);
    %     datetick(h, 'x',12, 'keeplimits');
    
    axis([w(end - startIndx,1)+4, w(end - endIndx,1)+4,...
        min(w(end-endIndx:end-startIndx,4))*0.99, max(w(end-endIndx:end-startIndx,3))*1.01]);
    
    datetick('x',12, 'keeplimits');
    
    pause(0.025)
end
