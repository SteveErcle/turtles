
clc
clear all
close all

c = yahoo;

stock = 'MENT';


w = fetch(c,stock,now, now-2000, 'w');


handles = guihandles(giua);


highlowFlex(handles.axesG, w(:,3), w(:,4),...
    w(:,3), w(:,4),'blue',w(:,1));

startDate = w(end,1);
endDate = w(1,1);

initView = 500;
set(handles.slider1, 'Value', initView);
set(handles.slider1, 'Max', endDate-startDate, 'Min', initView);



levels = [0 12.5 25 33 37.5 50 62.5 67 75 87.5 100 150 250]';
bottomLevs = 8.21*(1+levels/100);

for i = 1:length(bottomLevs)
    set(handles.axesG, 'NextPlot', 'add');
    plot(handles.axesG, startDate:endDate, ones(1,length(startDate:endDate))*bottomLevs(i), 'k')
end


for i = 1:1000
   
    val = get(handles.slider1,'Value');
    set(handles.axesG, 'XLim', [startDate+val-initView, startDate+val]);
    find(w(:,1) == startDate+val-initView)
    set(handles.axesG, 'YLim', [min(w(:,4))*0.9, max(w(:,3))*1.1]);
    datetick(handles.axesG,'x',12, 'keeplimits');
    
    pause(0.025) 
end
