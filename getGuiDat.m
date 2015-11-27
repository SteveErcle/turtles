
clc
clear all
close all



stock = 'MENT';
c = yahoo;
w = fetch(c,stock,now, now-2000, 'w');
close(c)

handles = guihandles(giua);


highlowFlex(handles.axesG, w(:,3), w(:,4),...
    w(:,3), w(:,4),'blue',w(:,1));



initView = 150;
set(handles.slider1, 'Value', 0);
set(handles.slider1, 'Max', size(w,1)-initView-1, 'Min', 0);
set(handles.slider1, 'SliderStep', [1/size(w,1), 10/size(w,1)]);


levels = [0 12.5 25 33 37.5 50 62.5 67 75 87.5 100 150 250]';
bottomLevs = 8.21*(1+levels/100);

for i = 1:length(bottomLevs)
    set(handles.axesG, 'NextPlot', 'add');
    tLevs = w(end,1):w(1,1);
    plot(handles.axesG, tLevs , ones(1,length(tLevs))*bottomLevs(i), 'k')
end


while(true)
   
    val = get(handles.slider1,'Value')
    startIndx = ceil(val);
    endIndx  = ceil(val)+initView;
    set(handles.axesG, 'XLim', [w(end - startIndx,1)+4, w(end - endIndx,1)+4]);
    set(handles.axesG, 'YLim', [min(w(end-endIndx:end-startIndx,4))*0.9, max(w(end-endIndx:end-startIndx,3))*1.1]);
    datetick(handles.axesG,'x',12, 'keeplimits');
    
    pause(0.025) 
end
