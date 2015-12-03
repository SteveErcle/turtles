
clc
clear all
close all
delete(giua)


stock = 'XLE';
c = yahoo;
m = fetch(c,stock,now, now-7000, 'm');
w = fetch(c,stock,now, now-7000, 'w');
close(c)

handles = guihandles(giua);

subplot(2,1,1)
h1 = highlow(m(:,3), m(:,4),...
    m(:,3), m(:,4),'blue',m(:,1));

subplot(2,1,2)
h2 = highlow(w(:,3), w(:,4),...
    w(:,3), w(:,4),'blue',w(:,1));


set(gcf, 'Position', [0, 0, 1460, 700]);
set(giua, 'Position', [15, 210, 210, 5]);

initView = 300
set(handles.slider1, 'Value', 0);
set(handles.slider1, 'Max', size(w,1)-initView-1, 'Min', 0);
set(handles.slider1, 'SliderStep', [1/(size(w,1)-initView), 10/(size(w,1)-initView)]);
set(handles.radiobutton2, 'Value', 0)

highestR = 0%91.42;
lowestS  = 0%19.38;
subplot(2,1,1)
hold on;

for i = 1:9
    fluctLevs(i) = (highestR-lowestS)*((i-1)/8)+lowestS;
end
fluctLevs(end+1) = (highestR-lowestS)*(1.5)+lowestS
fluctLevs(end+1) = (highestR-lowestS)*(2)+lowestS;
fluctLevs(end+1) = (highestR-lowestS)*(2.5)+lowestS;
fluctLevs(end+1) = (highestR-lowestS)*(1/3)+lowestS;
fluctLevs(end+1) = (highestR-lowestS)*(2/3)+lowestS;

for i = 1:length(fluctLevs)
    %     set(handles.axesG, 'NextPlot', 'add');
    tLevs = m(end,1):m(1,1);
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
highLevs(end+1) = highestR*1.5;
highLevs(end+1) = highestR*2;
highLevs(end+1) = highestR*2.5;
highLevs(end+1) = highestR*1/3;
highLevs(end+1) = highestR*2/3;


for i = 1:length(highLevs)
    %     set(handles.axesG, 'NextPlot', 'add');
    tLevs = m(end,1):m(1,1);
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
    
    if get(handles.radiobutton2, 'Value')
        
        if exist('cursor_info', 'var')
            values = [];
            for i = 1:length(cursor_info)
                
                value = getfield(cursor_info, {i},'Position');
                datestr(value)
                values = [values;value(2)];
                subplot(2,1,1)
                hold on
                plot(tLevs , ones(1,length(tLevs))*value(2), 'k')
                
                subplot(2,1,2)
                hold on
                plot(tLevs , ones(1,length(tLevs))*value(2), 'k')
                
            end
            clear cursor_info
        end
        set(handles.radiobutton2, 'Value', 0);
    end
    
    subplot(2,1,1)
    axis([w(end - startIndx,1)+1, w(end - endIndx,1)+1,...
        min(w(end-endIndx:end-startIndx,4))*0.95, max(w(end-endIndx:end-startIndx,3))*1.05]);
    datetick('x',12, 'keeplimits');
    
    subplot(2,1,2)
    axis([w(end - startIndx-4,1)+1, w(end - endIndx-4,1)+1,...
        min(w(end-endIndx:end-startIndx,4))*0.95, max(w(end-endIndx:end-startIndx,3))*1.05]);
    datetick('x',12, 'keeplimits');
    
    pause(0.025)
end
