
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
        
        function [] = setButtons(oxbj, handles, select)
            
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
            
            set(handles.pr,'String', 0)
            
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
                x2 = date - offset + 35;
                y1 = min(lo(I2:I1))*0.995;
                y2 = max(hi(I2:I1))*1.005;
                
                for i = 1:3
                    set(0,'CurrentFigure',i)
                    axis([x1, x2, y1, y2]);
                    
                end
                
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
        
        function [pMarket, levels, axisLen, axisParams] = playTurtles(obj, handles, pMarket, levels, axisLen, axisParams, simDates, i_date, dAll, OpCl, a)
            
            if get(handles.play, 'Value') % & i_date == simDates(end)
                while ~get(handles.next, 'Value')
                    
                    pause(0.1);
                    
                    pMarket = obj.plotTrade(handles, pMarket, i_date, dAll, OpCl, a);
                    
                    levels = obj.plotLevel(handles, levels, dAll);
                    
                    [axisLen, axisParams] = obj.setAxis(handles, axisLen, axisParams, i_date);
                    
                    
                end
                
            end
            
            set(handles.next, 'Value', 0);
        end
        
        function [pMarket] = plotTrade(obj, handles, pMarket, i_date, dAll, OpCl, a)
            
            if isempty(a) 
                [pMarket] = obj.plotTradeGuiControl(handles, pMarket, i_date, dAll, OpCl);
            else
                [pMarket] = obj.plotTradeArudinoControl(handles, pMarket, i_date, dAll, OpCl, a);
            end
           
        end 
        
        function [pMarket] = plotTradeGuiControl(obj, handles, pMarket, i_date, dAll, OpCl)
            
            td = TurtleData;
            tf = TurtleFun;
            [hi, lo, cl, op, da] = tf.returnOHLCDarray(dAll);
            dateIndx = td.getDateIndx(dAll(:,1), i_date);
            
            if get(handles.setTrade, 'Value')
                
                if get(handles.cl, 'Value')
                    enter = cl(dateIndx);
                    set(handles.enter,'String', num2str(enter));
                    set(handles.cl, 'Value', 0);
                elseif get(handles.op, 'Value')
                    enter = op(dateIndx);
                    set(handles.enter,'String', num2str(enter));
                    set(handles.op, 'Value', 0);
                else
                    enter = str2double(get(handles.enter,'String'));
                end
    
                if get(handles.stopLoss, 'Value')
                    
                    slPercent = str2double(get(handles.stopLossPercent,'String'));
                    if isempty(slPercent);
                        slPercent = 0;
                    end
                    
                    ub = enter*(1+(slPercent/100));
                    lb = enter*(1-(slPercent/100));
                    
                    set(handles.ub,'String', num2str(ub));
                    set(handles.lb,'String', num2str(lb));
                    set(handles.stopLoss, 'Value', 0)
                    
                else
                    lb = str2double(get(handles.lb,'String'));
                    ub = str2double(get(handles.ub,'String'));
                end
                
                if pMarket(1) ~= 0
                    delete(pMarket)
                end   
                
                for i = 1:3
                    set(0,'CurrentFigure',i)
                    k = 3*i-2:i*3;
                    pMarket(k(1)) = plot([dAll(end,1), dAll(1,1)], [1,1]*ub, 'r');
                    pMarket(k(2)) = plot([dAll(end,1), dAll(1,1)], [1,1]*enter, 'b');
                    pMarket(k(3)) = plot([dAll(end,1), dAll(1,1)], [1,1]*lb, 'r');
                    set(handles.setLevel, 'Value', 0);
                end
                
                set(handles.setTrade, 'Value', 0);
                
            end
            
        end

        function [pMarket] = plotTradeArudinoControl(obj, handles, pMarket, i_date, dAll, OpCl, a)

            td = TurtleData;
            tf = TurtleFun;
            [hi, lo, cl, op, da] = tf.returnOHLCDarray(dAll);
            dateIndx = td.getDateIndx(dAll(:,1), i_date);
            
            voltTrade = readVoltage(a,1);
            voltLoss =  readVoltage(a,0);
            voltLimit = readVoltage(a,2);
            
            if OpCl == 1
                enter = op(dateIndx);
            else
                enter = cl(dateIndx);
            end
 
            if voltTrade > 0.05                     
                set(handles.enter,'String', num2str(enter));    
            end
            
            if voltLimit > 0.05
                slPercent = -15+voltLoss/5*30;
                enter = enter*(1+(slPercent/100));
                set(handles.enter,'String', num2str(enter));
            end
            
            if ~isempty(str2num(get(handles.enter,'String')))
                enter = str2num(get(handles.enter,'String'));
                slPercent = -15+voltLoss/5*30;
                ub = enter*(1+(slPercent/100));
                lb = enter*(1-(slPercent/100));
                ub = 0;
                
                set(handles.ub,'String', num2str(ub));
                set(handles.lb,'String', num2str(lb));
                set(handles.stopLoss, 'Value', 0)
                
                 if pMarket(1) ~= 0
                    delete(pMarket)
                end  
                
                for i = 1:3
                    set(0,'CurrentFigure',i)
                    k = 3*i-2:i*3;
                    pMarket(k(1)) = plot([dAll(end,1), dAll(1,1)], [1,1]*ub, 'r');
                    pMarket(k(2)) = plot([dAll(end,1), dAll(1,1)], [1,1]*enter, 'b');
                    pMarket(k(3)) = plot([dAll(end,1), dAll(1,1)], [1,1]*lb, 'r');
                    set(handles.setLevel, 'Value', 0);
                end
                
            end
            
       
        end 
        
        function [levels] = plotLevel(obj, handles, levels, dAll)
            
            if get(handles.setLevel, 'Value')
                for j = 1:3
                    set(0,'CurrentFigure',j)
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
            end
        end
        
        function [runnerUp, runnerDown] = trackTime(obj, isNew, tAll, i_date, runnerUp, runnerDown, fT)
            
            tRunnerUp = runnerUp(fT);
            tRunnerDown = runnerDown(fT);
            
            if isNew
                td = TurtleData;
                tf = TurtleFun;
                [hi, lo, cl, op, da] = tf.returnOHLCDarray(tAll);
                dateIndx = td.getDateIndx(tAll(:,1), i_date)+1;
                
                if lo(dateIndx) < lo(dateIndx+1)
                    runlo = 1;
                elseif lo(dateIndx) >= lo(dateIndx+1) & hi(dateIndx) < hi(dateIndx+1)
                    runlo = 1;
                else
                    runlo = 0;
                end
                
                
                if hi(dateIndx) > hi(dateIndx+1)
                    runhi = 1;
                elseif hi(dateIndx) <= hi(dateIndx+1) & lo(dateIndx) > lo(dateIndx+1)
                    runhi = 1;
                else
                    runhi = 0;
                end
                
                
                if runlo == 1
                    tRunnerDown = tRunnerDown + 1;
                else
                    tRunnerDown = 1;
                end
                
                if runhi == 1
                    tRunnerUp = tRunnerUp + 1;
                else
                    tRunnerUp = 1;
                end
                
                set(0,'CurrentFigure',fT)
                text(da(dateIndx)+0.5, op(dateIndx), strcat(num2str(tRunnerUp),',',num2str(tRunnerDown)));
                
                
                
            end
            
            runnerUp(fT) = tRunnerUp;
            runnerDown(fT) = tRunnerDown;
            
        end
        
    end
    
end





