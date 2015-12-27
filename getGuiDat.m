
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

for initSubPlots = 1:1
    subplot(3,1,1)
    hi = m(:,3); lo = m(:,4); cl = m(:,5); op = m(:,2); da = m(:,1);
    highlow(hi, lo, hi, lo,'blue', da);
    hold on
    highlow(hi, lo, cl, op, 'blue', da);
    title('Monthly')
    
    subplot(3,1,2)
    hi = w(:,3); lo = w(:,4); cl = w(:,5); op = w(:,2); da = w(:,1);
    highlow(hi, lo, hi, lo,'blue', da);
    hold on
    highlow(hi, lo, cl, op, 'blue', da);
    title('Weekly')
    
    subplot(3,1,3)
    hi = d(:,3); lo = d(:,4); cl = d(:,5); op = d(:,2); da = d(:,1);
    highlow(hi, lo, hi, lo,'blue', da);
    hold on
    highlow(hi, lo, cl, op, 'blue', da);
    title('Daily')
end

for initProps = 1:1
    % set(gcf, 'Position', [0, 0, 1460, 700]);
    set(gcf, 'Position', [-1077,1017,1077,1822]);
    set(giua, 'Position', [44.5,60.41,150.7,10]);
    
    initView = 100;
    set(handles.slider1, 'Value', 0);
    set(handles.slider1, 'Max', size(w,1)-initView-1, 'Min', 0);
    set(handles.slider1, 'SliderStep', [1/(size(w,1)-initView), 10/(size(w,1)-initView)]);
    set(handles.button, 'Value', 0);
    set(handles.view, 'Value', 0);
    
    tLevs = m(end,1):m(1,1);
    enter = 0;
    loss  = 0;
    limit = 0;
    highest = 0;
    lowest  = 0;
    position = [0,0];
    
    values = [];
    flagView = -1;
    flagHi = -1;
    flagFluct = -1;
    flagTrade = 0;
    
    h = gcf;
    axesObjs = get(h, 'Children');
    axesObjs = findobj(axesObjs, 'type', 'axes');
    
end

for initLines = 1:1
    
    lineHiLo  = lineSetter(gcf, 1);
    
    for i = 1:3
        subplot(3,1,i)
        showFluctLevs(highest, lowest, tLevs)
    end
    linFluct = lineSetter(gcf, 14);
    
    for i = 1:3
        subplot(3,1,i)
        showHighLevs(highest, tLevs)
    end
    linHi = lineSetter(gcf, 14);
    
    for i = 1:3
        subplot(3,1,i)
        plot(position(1), position(2), 'go');
    end
    linGo = lineSetter(gcf, 1);
    
    for i = 1:3
        subplot(3,1,i)
        plot(tLevs , ones(1,length(tLevs))*enter, 'r')
        plot(tLevs , ones(1,length(tLevs))*loss, 'r')
        plot(tLevs , ones(1,length(tLevs))*limit, 'r')
    end
    linTrade = lineSetter(gcf, 3);
end


while(true)
    
    for setViewOptions = 1:1
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
    
    for setFoundLevel = 1:1
        if get(handles.button, 'Value')
            
            dataTips = findall(axesObjs, 'Type', 'hggroup', 'HandleVisibility', 'off');
            
            if exist('cursor_info', 'var')
                for i = 1:length(cursor_info)
                    value = getfield(cursor_info, {i},'Position');
                    datestr(value)
                    values = [values;value(2)];
                    for i = 1:3
                        subplot(3,1,i)
                        hold on
                        plot(tLevs , ones(1,length(tLevs))*value(2), 'k')
                    end
                end
                clear cursor_info
            else
                if length(dataTips) > 0
                    cursor = datacursormode(gcf);
                    value = cursor.CurrentDataCursor.getCursorInfo.Position(2)
                    for i = 1:3
                        subplot(3,1,i)
                        hold on
                        plot(tLevs , ones(1,length(tLevs))*value, 'k')
                    end
                end %length
            end %else
            delete(dataTips);
            set(handles.button, 'Value', 0);
        end %get
    end
    
    for setNaturalLevels = 1:1
        if get(handles.setHiLo, 'Value')
            dataTips = findall(gca, 'Type', 'hggroup', 'HandleVisibility', 'off');
            if length(dataTips) > 0
                delete(dataTips);
            end
            
            highest = str2double(get(handles.HiLevView,'String'));
            lowest = str2double(get(handles.LoLevView,'String'));
            
            for i = 1:3
                subplot(3,1,i)
                showFluctLevs(highest, lowest, tLevs)
                
            end
            linFluct = lineSetter(gcf, 14);
            for i = 1:3
                subplot(3,1,i)
                showHighLevs(highest, tLevs)
                
            end
            linHi = lineSetter(gcf, 14);
            
            set(handles.setHiLo, 'Value', 0);
        end
    end
    
    for showCurrentPosition = 1:1
        
        if get(handles.currentPos, 'Value')
            
            set(linGo,'Visible','off');
            dataTips = findall(axesObjs, 'Type', 'hggroup', 'HandleVisibility', 'off');
            if length(dataTips) > 0
                
                cursor = datacursormode(gcf);
                position = cursor.CurrentDataCursor.getCursorInfo.Position(1:2);
                for i = 1:3
                    subplot(3,1,i)
                    plot(position(1), position(2), 'go');
                end
                linGo = lineSetter(gcf, 1);
                set(linGo,'Visible','on');
                delete(dataTips);
            end
            set(handles.currentPos, 'Value', 0);
        end
    end
    
    for showTrade = 1:1
        
        if flagTrade ~= get(handles.trade, 'Value')
            if get(handles.trade, 'Value')
                enter = str2double(get(handles.edit_entered,'String'));
                loss = str2double(get(handles.edit_loss,'String'));
                limit = str2double(get(handles.edit_limit,'String'));
                for i = 1:3
                    subplot(3,1,i)
                    plot(tLevs , ones(1,length(tLevs))*enter, 'b')
                    plot(tLevs , ones(1,length(tLevs))*loss, 'r')
                    plot(tLevs , ones(1,length(tLevs))*limit, 'g')
                end
                linTrade = lineSetter(gcf, 3);
                set(linTrade, 'Visible', 'on');
                dataTips = findall(axesObjs, 'Type', 'hggroup', 'HandleVisibility', 'off');
                delete(dataTips);  
            else
                set(linTrade,'Visible','off');
            end
            flagTrade = get(handles.trade, 'Value');
        end
    end
    
    for setAxisLimits = 1:1
        val = get(handles.slider1,'Value');
        startIndx = ceil(val);
        endIndx  = ceil(val)+initView;
        
        subplot(3,1,1)
        axis([w(end - startIndx,1), w(end - endIndx,1)+2,...
            min(w(end-endIndx:end-startIndx,4))*0.95, max(w(end-endIndx:end-startIndx,3))*1.05]);
        datetick('x',12, 'keeplimits');
        
        %     subplot(3,1,3)
        %     axis([w(end - (startIndx+90),1), w(end - endIndx,1)+2,...
        %         min(w(end-endIndx:end-(startIndx+90),4))*0.95,...
        %         max(w(end-endIndx:end-(startIndx+90),3))*1.05]);
        %     datetick('x',12, 'keeplimits');
        
        subplot(3,1,2)
        axis([w(end - startIndx,1), w(end - (endIndx+4),1)+2,...
            min(w(end-(endIndx+4):end-startIndx,4))*0.95, max(w(end-(endIndx+4):end-startIndx,3))*1.05]);
        datetick('x',12, 'keeplimits');
    end
    
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
