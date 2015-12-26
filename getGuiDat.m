
clc
clear all
close all
delete(giua)

stock = 'USO'; %XLE
c = yahoo;
m = fetch(c,stock,now, now-7000, 'm');
w = fetch(c,stock,now, now-7000, 'w');
d = fetch(c,stock,now, now-7000, 'd');
close(c)


handles = guihandles(giua);

subplot(3,1,1)
highlow(m(:,3), m(:,4),...
    m(:,3), m(:,4),'blue',m(:,1));
title('Monthly')


subplot(3,1,2)
hi = d(:,3); lo = d(:,4); cl = d(:,3); op = d(:,4); da = d(:,1);
highlow(hi, lo, cl, op, 'blue', da);
title('Daily')

subplot(3,1,3)
highlow(w(:,3), w(:,4),...
    w(:,3), w(:,4),'blue',w(:,1));
title('Weekly')
hold on

subplot(3,1,3)
hi = w(:,3); lo = w(:,4); cl = w(:,5); op = w(:,2); da = w(:,1);
highlow(hi, lo, cl, op, 'blue', da);


lineHiLo  = lineSetter(gcf, 1)
set(lineHiLo,'Visible','off')

% set(gcf, 'Position', [0, 0, 1460, 700]);
set(gcf, 'Position', [-1077,-1017,1077,1822]);
set(giua, 'Position', [15, 210, 210, 5]);

initView = 100;
set(handles.slider1, 'Value', 0);
set(handles.slider1, 'Max', size(w,1)-initView-1, 'Min', 0);
set(handles.slider1, 'SliderStep', [1/(size(w,1)-initView), 10/(size(w,1)-initView)]);
set(handles.button, 'Value', 0);
set(handles.view, 'Value', 0);

tLevs = m(end,1):m(1,1);

subplot(3,1,3)
highest = 0;
lowest  = 0;
showFluctLevs(highest, lowest, tLevs)
linFluct = lineSetter(gcf, 14);
set(linFluct,'Visible','off')

subplot(3,1,3)
showHighLevs(highest, tLevs)
linHi = lineSetter(gcf, 14);
set(linHi,'Visible','off')



values = [];
flagView = -1;
flagHi = -1;
flagFluct = -1;
while(true)
    
    val = get(handles.slider1,'Value');
    startIndx = ceil(val);
    endIndx  = ceil(val)+initView;
    
    if get(handles.button, 'Value')
        if exist('cursor_info', 'var')
            for i = 1:length(cursor_info)
                
                value = getfield(cursor_info, {i},'Position');
                datestr(value)
                values = [values;value(2)];
                subplot(3,1,1)
                hold on
                plot(tLevs , ones(1,length(tLevs))*value(2), 'k')
                
                subplot(3,1,2)
                hold on
                plot(tLevs , ones(1,length(tLevs))*value(2), 'k')
                
                subplot(3,1,3)
                hold on
                plot(tLevs , ones(1,length(tLevs))*value(2), 'k')
                
            end
            clear cursor_info
        end
        set(handles.button, 'Value', 0);
    end
    
    for ihide = 1:1
        if get(handles.view, 'Value')
            if flagView == -1
                set(lineHiLo,'Visible','on')
                flagView = flagView*-1;
            else
                set(lineHiLo,'Visible','off')
                flagView = flagView*-1;
            end
            set(handles.view, 'Value', 0);
        end
        
        if get(handles.viewHiLevs, 'Value')
            if flagHi == -1
                set(linHi,'Visible','on')
                flagHi = flagHi*-1;
            else
                set(linHi,'Visible','off')
                flagHi = flagHi*-1;
            end
            set(handles.viewHiLevs, 'Value', 0);
        end
        
        if get(handles.viewFluctLevs, 'Value')
            if flagFluct == -1
                set(linFluct,'Visible','on')
                flagFluct = flagFluct*-1;
            else
                set(linFluct,'Visible','off')
                flagFluct = flagFluct*-1;
            end
            set(handles.viewFluctLevs, 'Value', 0);
        end
    end
    
    if get(handles.setHiLo, 'Value')
        
        dataTips = findall(gca, 'Type', 'hggroup', 'HandleVisibility', 'off');
        if length(dataTips) > 0
            delete(dataTips);
        end
        
        set(linFluct,'Visible','off')
        set(linHi,'Visible','off')
        
        highest = str2double(get(handles.HiLevView,'String'));
        lowest = str2double(get(handles.LoLevView,'String'));
        
        subplot(3,1,3)
        showFluctLevs(highest, lowest, tLevs);
        linFluct = lineSetter(gcf, 14);
        set(linFluct,'Visible','off')
        
        subplot(3,1,3)
        showHighLevs(highest, tLevs);
        linHi = lineSetter(gcf, 14);
        set(linHi,'Visible','off')
        
        set(handles.setHiLo, 'Value', 0);
    end
    
    
    
    subplot(3,1,1)
    axis([w(end - startIndx,1), w(end - endIndx,1)+2,...
        min(w(end-endIndx:end-startIndx,4))*0.95, max(w(end-endIndx:end-startIndx,3))*1.05]);
    datetick('x',12, 'keeplimits');
  
%     subplot(3,1,2)
%     axis([w(end - (startIndx+90),1), w(end - endIndx,1)+2,...
%         min(w(end-endIndx:end-(startIndx+90),4))*0.95,...
%         max(w(end-endIndx:end-(startIndx+90),3))*1.05]);
%     datetick('x',12, 'keeplimits');
    
    subplot(3,1,3)
    axis([w(end - startIndx,1), w(end - (endIndx+4),1)+2,...
        min(w(end-(endIndx+4):end-startIndx,4))*0.95, max(w(end-(endIndx+4):end-startIndx,3))*1.05]);
    datetick('x',12, 'keeplimits');
    
    pause(0.025)
    
end





% FOR ADDITIONAL Y AXIS FOR VOLUME

% ax1 = gca;
% hold on
%
% ax2 = axes('Position',get(ax1,'Position'),...
%     'XAxisLocation','top',...
%     'YAxisLocation','right',...
%     'Color','none',...
%     'XColor','k','YColor','k');
% set(ax2, 'YLim', [0 80000000])
% linkaxes([ax1 ax2],'x');
% hold on
% bar(m(:,1),m(:,6),'Parent',ax2);
% hold off




% Add feature to delete previous level
% Build strategies in walk through for sideways and trending markets
% Test those strategies by playing
% Build macro viewer
% Build micro viewer
