
classdef TurtleSim
    
    properties
        
        dAll;
        
    end
    
    
    methods
        
        function obj = TurtelSim(varargin)
            
            if nargin == 1
                obj.dAll = varargin{1};
            end
            
        end
        
        function [] = setButtons(obj, handles, select)
            
            set(handles.M, 'Value', 0);
            set(handles.W, 'Value', 0);
            set(handles.D, 'Value', 0);
            set(handles.I, 'Value', 0);
            set(handles.V, 'Value', 0);
            
            if select == 'M'
                set(handles.M, 'Value', 1);
                
            elseif select == 'W'
                set(handles.W, 'Value', 1);
                
            elseif select == 'D'
                set(handles.D, 'Value', 1);
                
            end
            
        end
        
        function [] = initHandles(obj, handles, simPres, aniLen, axisLen, aniSpeed, dAll)
            
            set(handles.updateAxis, 'Value', 1);
            
            lenD = length(dAll(:,1));
            set(handles.simPres, 'Max', lenD, 'Min', 1);
            set(handles.simPres, 'SliderStep', [1/lenD, 10/lenD]);
            set(handles.simPres, 'Value', get(handles.simPres, 'Max') - simPres + 1);
            
            set(handles.aniLen, 'Max', lenD, 'Min', 0);
            set(handles.aniLen, 'SliderStep', [1/lenD, 10/lenD]);
            set(handles.aniLen, 'Value', get(handles.aniLen, 'Max') - aniLen);
            
            lenOfTime = dAll(1,1) - dAll(end,1);
            set(handles.axisLen, 'Max', lenOfTime, 'Min', 1);
            set(handles.axisLen, 'SliderStep', [1/lenOfTime, 10/lenOfTime]);
            set(handles.axisLen, 'Value', axisLen);
            
            set(handles.aniSpeed, 'Max', 1, 'Min', 0.01);
            set(handles.aniSpeed, 'SliderStep', [1/100, 10/100]);
            set(handles.aniSpeed, 'Value', get(handles.aniSpeed, 'Max') - aniSpeed);
            
            set(handles.offsetAxis, 'Max', lenOfTime, 'Min', 0);
            set(handles.offsetAxis, 'SliderStep', [1/lenOfTime, 10/lenOfTime]);
            set(handles.offsetAxis, 'Value', 0);
            
        end
        
        function [simPres] = getSimulationPresent(obj, handles)
            
            if get(handles.play, 'Value')
                newSimPres = floor(get(handles.simPres, 'Value')+1);
                set(handles.simPres, 'Value', newSimPres);
            end
            
            simPres = get(handles.simPres, 'Max') - floor(get(handles.simPres, 'Value')) + 1;
        end
        
        function [aniSpeed, aniLen] = setAnimation(obj, handles, i_date, simDates)
            
            aniSpeed = get(handles.aniSpeed, 'Max') - (get(handles.aniSpeed, 'Value'));
            aniLen   = get(handles.aniLen, 'Max') - floor(get(handles.aniLen, 'Value'));
            
            if ~get(handles.runAnimation, 'Value')
                aniSpeed = 0;
            end
            
            if get(handles.play, 'Value')
                
                %                 if i_date ~= simDates(end)
                %
                %                     maxMinusMin = get(handles.aniSpeed,'Max') - get(handles.aniSpeed,'Min');
                %                     set(handles.aniSpeed,'Value', maxMinusMin);
                %                     aniSpeed = 0;
                %                 else
                %                     set(handles.aniSpeed,'Value', 0.75);
                %                 end
                set(handles.aniLen, 'Value', get(handles.aniLen, 'Max'));
                
            end
            
        end
        
        function [axisLen, axisParams] = setAxis(obj, handles, axisLen, axisParams, date)
            
            if get(handles.updateAxis, 'Value')
                
                axisLen = floor(get(handles.axisLen, 'Value'));
                
                offset = floor(get(handles.offsetAxis, 'Value'));
                
                [M I1] = min(abs(obj.dAll(:,1) - (date - offset - axisLen)));
                [M I2] = min(abs(obj.dAll(:,1) - (date - offset)));
                
                tf = TurtleFun;
                [hi, lo, cl, op, da] = tf.returnOHLCDarray(obj.dAll);
                
                x1 = date - offset - axisLen;
                x2 = date - offset + 15;
                y1 = min(lo(I2:I1))*0.995;
                y2 = max(hi(I2:I1))*1.005;
                
                axis([x1, x2, y1, y2]);
                
                axisParams = [x1, x2, y1, y2];
                
            end
            
            x1 = axisParams(1);
            x2 = axisParams(2);
            y1 = axisParams(3);
            y2 = axisParams(4);
            
            axis([x1, x2, y1, y2]);
            
        end
        
        function [hlcoDs, hlcoWs, hlcoMs] = initData(obj, stock, daysForCrossVal, daysIntoPast)
            
            c = yahoo;
            m = fetch(c,stock,now-daysForCrossVal, now-daysIntoPast, 'm');
            w = fetch(c,stock,now-10, now-400, 'w');
            d = fetch(c,stock,now-10, now-400, 'd');
            
            hlcoMs = TurtleVal(m);
            hlcoWs = TurtleVal(w);
            hlcoDs = TurtleVal(d);
            close(c)
            
        end
        
        function [newTimePeriod] = isNewTimePeriod(obj, tCong, i_date)
            
            
            td = TurtleData;
            
            dateIndx = td.getDateIndx(tCong, i_date);
            
            if tCong(dateIndx,1) == tCong(dateIndx,end) == 1
                newTimePeriod = 1;
            else
                newTimePeriod = 0;
            end
            
        end
        
        function [pTo, axisLen, axisParams] = animateOpen(obj, aniSpeed, isT, isNew, tCong, i_date,...
                fT, tickSize, handles, axisLen, axisParams)
            
            tf = TurtleFun;
            td = TurtleData;
            
            dateIndx = td.getDateIndx(tCong, i_date);
            tSim = tCong(dateIndx,:);
            
            pTo = 0;
            
            if isT
                figure(fT)
            end
            if isNew
                set(0,'CurrentFigure',fT)
                [~,pTo] = tf.plotOp(tSim,tickSize);
            end
            
            [axisLen, axisParams] = obj.setAxis(handles, axisLen, axisParams, i_date);
            
            pause(aniSpeed);
            
        end
        
        function [pT, axisLen, axisParams] = animateClose(obj, aniSpeed, isT, isNew, tCong, i_date,...
                fT, pT, pTo, tickSize, handles, axisLen, axisParams)
            
            tf = TurtleFun;
            td = TurtleData;
            
            dateIndx = td.getDateIndx(tCong, i_date);
            tSim = tCong(dateIndx,:);
            
            
            if isT
                figure(fT)
            end
            
            if isNew & pTo ~= 0
                delete(pTo);
            end
            
            if ~isNew & pT(1) ~= 0
                set(0,'CurrentFigure',fT)
                delete(pT);
            end
            
            set(0,'CurrentFigure',fT)
            [~,pT] = tf.plotHiLoSolo(tSim, tickSize);
            
            [axisLen, axisParams] = obj.setAxis(handles, axisLen, axisParams, i_date);
            
            pause(aniSpeed);
            
        end
        
        function [pMarket, levels] = playTurtles(obj, handles, pMarket, levels, simDates, i_date, dAll)
            
            if get(handles.play, 'Value') % & i_date == simDates(end)
                while ~get(handles.next, 'Value')
                    
                    pause(0.1);
                    
                    pMarket = obj.plotTrade(handles, pMarket, i_date, dAll);
                    
                    levels = obj.plotLevel(handles, levels, dAll);
                    
                end
                
            end
            
            set(handles.next, 'Value', 0);
        end
        
        function [pMarket] = plotTrade(obj, handles, pMarket, i_date, dAll)
            
            if get(handles.setTrade, 'Value')
                
                ub = str2double(get(handles.ub,'String'));
                enter = str2double(get(handles.enter,'String'));
                lb = str2double(get(handles.lb,'String'));c
                
                if pMarket(1) ~= 0
                    delete(pMarket)
                end
                
                for i = 1:3
                    figure(i)
                    pMarket(i) = plot([dAll(end,1), dAll(1,1)], [1,1]*ub, 'k');
                    pMarket(i+1) = plot([dAll(end,1), dAll(1,1)], [1,1]*enter, 'b');
                    pMarket(i+2) = plot([dAll(end,1), dAll(1,1)], [1,1]*lb, 'k');
                    set(handles.setLevel, 'Value', 0);
                    
                end
            end
        end
        
        function [levels] = plotLevel(obj, handles, levels, dAll)
            
            if get(handles.setLevel, 'Value')
                
                h = gcf;
                axesObjs = get(h, 'Children');
                axesObjs = findobj(axesObjs, 'type', 'axes');
                
                dataTips = findall(axesObjs, 'Type', 'hggroup', 'HandleVisibility', 'off');
                
                if length(dataTips) > 0
                    cursor = datacursormode(gcf);
                    dateOnPlot = cursor.CurrentDataCursor.getCursorInfo.Position(1)
                    value = cursor.CurrentDataCursor.getCursorInfo.Position(2)
                    levels = [levels; value];
                    
                    for i = 1:3
                        set(0,'CurrentFigure',i)
                        plot([dAll(end,1), dAll(1,1)], [1,1]*value, 'k');
                    end
                    
                    delete(dataTips);
                    set(handles.setLevel, 'Value', 0);
                    
                end
                
            end
            
%             if get(handles.setLevel, 'Value')
%                 
%                 if exist('cursor_info', 'var')
%                     
%                     for j = 1:length(cursor_info)
%                         
%                         values = getfield(cursor_info, {j},'Position');
%                         x_value = values(1);
%                         y_value = values(2);
%                         levels = [levels; y_value];
%                         for i = 1:3
%                             set(0,'CurrentFigure',i)
%                             plot([dAll(end,1), dAll(1,1)], [1,1]*y_value, 'r');
%                         end
%                         
%                     end
%                     clear cursor_info
%                 end
%                 
%             end
            
        end
        
   
        
    end
    
end





