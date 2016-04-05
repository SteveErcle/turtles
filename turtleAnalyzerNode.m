% testGet data

clear all; clc; close all;

delete(slider);
handles = guihandles(slider);


simFrom = 230;
simTo = 330;
len = simTo - simFrom;
axisView = 50;
setOff = 50;

set(handles.axisView, 'Max', len, 'Min', setOff);
set(handles.axisView, 'SliderStep', [1/len, 10/len]);
set(handles.axisView, 'Value', axisView);

set(handles.wSize, 'Max', 30 , 'Min', 1);
set(handles.wSize, 'SliderStep', [1/30, 10/30]);
set(handles.wSize, 'Value', 10);

% past = '1/1/13';
% simulateTo = now;
%
% stock = '^GSPC';
%
% c = yahoo;
%
% dAll = (fetch(c,stock,past, simulateTo, 'd'));
% wAll = fetch(c,stock,past, simulateTo, 'w');
% mAll = fetch(c,stock,past, simulateTo, 'm');
%
% averages = '^GSPC';
% dAvg = fetch(c,averages,past, simulateTo, 'd');
%
% close(c);


load('tslaOffline');
dAll = dAll(simFrom:simTo,:);
dAvg = dAvg(simFrom:simTo,:);


beta = 1.29;


tf = TurtleFun;

p = 0;

while(true)
    
    [hi, lo, cl, op, da] = tf.returnOHLCDarray(dAll);
    
    
    
    Idx = dAvg(:,2:5);
    Scb = dAll(:,2:5);
    
    
    % Scb = ([8 8 7 6 5 4 3 2 2])';
    % Idx = ([9 8 7 6 5 4 3 2 1])';
    % Idx = [Idx, Idx*2];
    % Scb = Idx;
    % Scb(end,:) = [4,3];
    
    per = [];
    
    for i = size(Idx,1) - 1 : -1 : 1
        per = [per; beta * ((Idx(i,:) - Idx(i+1,:)) ./ Idx(i+1,:))];
    end
    per = flipud(per);
    
    Sio = zeros(size(Scb));
    Sio(end,:) = Scb(end,:);
    
    for i = size(Idx,1) - 1 : -1 : 1
        Sio(i,:) = Sio(i+1,:).*(per(i,:)+1);
    end
    
    
    
    Sro = Scb(end) + (Scb - Sio);
    
    
    wSize = floor(get(handles.wSize, 'Value'))
    ScbS = flipud(tsmovavg(flipud(Scb(:,4)),'e',wSize,1));
    SioS = flipud(tsmovavg(flipud(Sio(:,4)),'e',wSize,1));
    SroS = flipud(tsmovavg(flipud(Sro(:,4)),'e',wSize,1));
    
    
    numSub = 2;
    
    
    subplot(2,1,2)
    cla
    hold on
    plot(da(1:end-1),flipud(diff(flipud(SioS))), 'b')
    plot(da(1:end-1),flipud(diff(flipud(SroS))), 'k')
    plot([da(1),da(end)], [0,0], 'm')
    
    
    subplot(numSub,1,1)
    cla
    hold on
    plot(da,SioS, 'b.')
    plot(da,ScbS,'r.')
    plot(da,SroS, 'k.')
    
    % plot(da,Sio(:,4), 'b')
    % plot(da,Scb(:,4),'r')
    % plot(da,Sro(:,4), 'k')
    
    
    
    subplot(numSub,1,1)
    [hi, lo, cl, op, da] = tf.returnOHLCDarray([da,Scb]);
    highlow(hi, lo, op, cl, 'red', da);
    hold on;
    
    
    % subplot(numSub,1,2)
    % [hi, lo, cl, op, da] = tf.returnOHLCDarray([da,Sro]);
    % highlow(hi, lo, op, cl, 'black', da);
    % hold on;
    %
    % subplot(numSub,1,2)
    % [hi, lo, cl, op, da] = tf.returnOHLCDarray([da,Sio]);
    % highlow(hi, lo, op, cl, 'blue', da);
    % hold on;
    
    
    % while(true)
    %
    xLen = floor(get(handles.axisView, 'Value'));
    offSet = xLen - setOff;
    subplot(numSub,1,1)
    xlim([da(end-offSet), da(end-xLen)]);
    %     subplot(numSub,1,2)
    %     xlim([da(end-offSet), da(end-xLen)]+0.25);
    %
    
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
