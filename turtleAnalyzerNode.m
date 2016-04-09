% testGet data

clear all; clc; close all;

delete(slider);
handles = guihandles(slider);
tf = TurtleFun;
ta = TurtleAnalyzer;

simFrom = 1;
simTo = 100;
len = simTo - simFrom;
axisView = 50;
setOff = 50;

set(handles.axisView, 'Max', len, 'Min', setOff);
set(handles.axisView, 'SliderStep', [1/len, 10/len]);
set(handles.axisView, 'Value', axisView);

set(handles.wSize, 'Max', 30 , 'Min', 1);
set(handles.wSize, 'SliderStep', [1/30, 10/30]);
set(handles.wSize, 'Value', 10);


        
past = '1/1/01';
simulateTo = now;

stock = 'AXL';

c = yahoo;

dAll = (fetch(c,stock,past, simulateTo, 'd'));
wAll = fetch(c,stock,past, simulateTo, 'w');
mAll = fetch(c,stock,past, simulateTo, 'm');

averages = '^GSPC';
dAvg = fetch(c,averages,past, simulateTo, 'd');

close(c);


dAll = dAll(simFrom:simTo,:);
dAvg = dAvg(simFrom:simTo,:);



disp('Beta: ')
beta = ta.calcBeta(dAll, dAvg)


% load('tslaOffline');


p = 0;

while(true)
    
    [hi, lo, cl, op, da] = tf.returnOHLCDarray(dAll);
    
    [~,~,clD,~,~] = tf.returnOHLCDarray(dAvg);
    
    wSize = floor(get(handles.wSize, 'Value'));
    set(handles.printSize, 'String', num2str(wSize));
    
    [ScbS, SioS, SroS] = ta.getMovingAvgs(dAll, dAvg, wSize, beta);
    
    numSub = 2;
    
    subplot(2,1,2)
    cla
    hold on
   
   
    
    [stockStandardCl, avgStandardCl] = ta.getStandardized(dAll, dAvg);
    
    plot(stockStandardCl)
    plot(avgStandardCl)
    
    return
    
    [RSI, RSIma] = ta.getRSI(dAll, dAvg, wSize);
    plot(da,RSI,'c.')
    hold on
    plot(da,RSIma,'m.')
    
    subplot(numSub,1,1)
    cla
    hold on
    plot(da,SioS, 'b.')
    plot(da,ScbS,'r.')
    plot(da,SroS, 'k.')
    %     plot(da(1:end-1),flipud(diff(flipud(SioS))), 'b')
    %     plot(da(1:end-1),flipud(diff(flipud(SroS))), 'k')
    %     plot([da(1),da(end)], [0,0], 'm')
        
    subplot(numSub,1,1)
    [hi, lo, cl, op, da] = tf.returnOHLCDarray(dAll);
    highlow(hi, lo, op, cl, 'red', da);
    hold on;
    
    

    xLen = floor(get(handles.axisView, 'Value'));
    offSet = xLen - setOff;
    subplot(numSub,1,1)
    xlim([da(end-offSet), da(end-xLen)]);
    subplot(numSub,1,2)
    xlim([da(end-offSet), da(end-xLen)]+0.25);
    
    
    pause(0.2)
    h = gcf;
    axesObjs = get(h, 'Children');
    axesObjs = findobj(axesObjs, 'type', 'axes');
    dataTips = findall(axesObjs, 'Type', 'hggroup', 'HandleVisibility', 'off');
    
    if length(dataTips) > 0
        
        cursor = datacursormode(gcf);
        values = cursor.getCursorInfo;
        
        tData = values.Position;
        if ishandle(p) & p(1) ~= 0
            delete(p)
        end
        subplot(numSub,1,2)
        p(1) = plot([tData(1),tData(1)], [-0.5, 0.5], 'c');
        subplot(numSub,1,1)
        p(2) = plot([tData(1),tData(1)], [220, 260], 'c');
        %         p(2) = plot(tData(1), tData(2), 'bo');
        %         subplot(numSub,1,3)
        %         p(3) = plot(tData(1), tData(2), 'bo');
        delete(dataTips);
    end
    
    
end
