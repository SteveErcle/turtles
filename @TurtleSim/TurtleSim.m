
classdef TurtleSim < handle
    
    properties
        
        dAll;
        runnerUpArr = [];
        runnerDownArr = [];
        maxStop = [];
        positionRef = 0;
       
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
        
        function [axisLen, axisParams] = setAxis(obj, handles, axisLen, axisParams, date, OpCl)
            
            if get(handles.updateAxis, 'Value')
               
                
                axisLen = floor(get(handles.axisLen, 'Value'));
                
                offset = floor(get(handles.offsetAxis, 'Value'));
                
                [M I1] = min(abs(obj.dAll(:,1) - (date - offset - axisLen)));
                [M I2] = min(abs(obj.dAll(:,1) - (date - offset)));
                
                tf = TurtleFun;
                [hi, lo, cl, op, da] = tf.returnOHLCDarray(obj.dAll);
                
                if OpCl == 1
                    hi(I2) = op(I2);
                    lo(I2) = op(I2);
                end 
                
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
                fT, tickSize, handles, axisLen, axisParams, OpCl)
            
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
            
            [axisLen, axisParams] = obj.setAxis(handles, axisLen, axisParams, i_date, OpCl);
            
            pause(aniSpeed);
            
        end
        
        function [pT, axisLen, axisParams] = animateClose(obj, aniSpeed, isT, isNew, tCong, i_date,...
                fT, pT, pTo, tickSize, handles, axisLen, axisParams, OpCl)
            
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
            
            [axisLen, axisParams] = obj.setAxis(handles, axisLen, axisParams, i_date, OpCl);
            
            pause(aniSpeed);
            
        end
        
        function [pMarket, levels, axisLen, axisParams] = playTurtles(obj, handles, pMarket, levels, axisLen, axisParams, simDates, i_date, dAll, OpCl, a)
            
            if get(handles.play, 'Value') % & i_date == simDates(end)
                
                timeInterval = 5.9265e-06*2;
                timeStart = now;
                while ~get(handles.next, 'Value')
                    
                    %                     pause(0.050);
                    
                    pMarket = obj.plotTrade(handles, pMarket, i_date, dAll, OpCl, a);
                    
                    levels = obj.plotLevel(handles, levels, dAll);
                    
                    [axisLen, axisParams] = obj.setAxis(handles, axisLen, axisParams, i_date, OpCl);
                    
                    if get(handles.timer, 'Value')
                        if now - timeStart > timeInterval
                            set(handles.next, 'Value',1);
                        end
                    end
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
            
            digitalMarket = 0;
            digitalLimit = 0;
            position = 0;
            digitalResetStop = 0;
            digitalExit = 0;
            voltLoss =  readVoltage(a,0);
            voltLimit = readVoltage(a,1);
            
            digitals = [readDigitalPin(a,7), readDigitalPin(a,6),...
                readDigitalPin(a,5), readDigitalPin(a,4)];
  
            disp(digitals)
            
            if  digitals == [1,0,0,0]
                digitalMarket = 1;
                position = 1;
            elseif digitals == [0,1,0,0]
                digitalMarket = 1;
                position = -1;
            elseif digitals == [0,0,1,0]
                digitalResetStop = 1;
            elseif digitals == [0,0,0,1]
                set(handles.next, 'Value', 1);
            elseif digitals == [0,0,0,1]
              ;
            elseif digitals == [0,0,1,1]
%                 digitalResetStop = 1;
            end 
    
            if OpCl == 1
                toBeEnter = op(dateIndx);
            else
                toBeEnter = cl(dateIndx);
            end
            
            if (obj.positionRef == 1 || obj.positionRef == -1) & digitalMarket == 1
                digitalExit = 1;
                digitalMarket = 0;
            end 
                
            
            if digitalMarket == 1
                set(handles.setEnteredAt,'String', num2str(toBeEnter));
                set(handles.setStopRef,'String', num2str(toBeEnter));
                obj.positionRef = position;
                set(handles.setDateRef,'String', strcat(num2str(dateIndx), '-', num2str(OpCl)));
            end
            
            if ~strcmp(get(handles.setEnteredAt,'String'), '-') || ~strcmp(get(handles.setLimit,'String'), '-')
                if digitalResetStop
                    set(handles.setStopRef,'String', num2str(toBeEnter));
                end
                stopRef = str2double(get(handles.setStopRef,'String'));
                slPercent = -15+voltLoss/5*30;
                stop = stopRef*(1+(slPercent/100));
                
                if obj.positionRef == 1 & stop < str2double(get(handles.setEnteredAt,'String'))*(1-(obj.maxStop/100))
                  stop = str2double(get(handles.setEnteredAt,'String'))*(1-(obj.maxStop/100));
                elseif obj.positionRef == -1 & stop > str2double(get(handles.setEnteredAt,'String'))*(1+(obj.maxStop/100))
                    stop = str2double(get(handles.setEnteredAt,'String'))*(1+(obj.maxStop/100));
                end 
                
                set(handles.setStop,'String', num2str(stop));
                
                enteredAt = str2double(get(handles.setEnteredAt,'String'));
                exitedAt = toBeEnter;
                
                if obj.positionRef == 1
                    ifExit = ((exitedAt-enteredAt)/ enteredAt)*100;
                elseif obj.positionRef == -1
                    ifExit = ((enteredAt-exitedAt)/ enteredAt)*100;
                else
                    ifExit = 0;
                end 
                
                set(handles.ifExit,'String', num2str(ifExit));
            
            end
            
            if digitalLimit == 1
                slPercent = voltLimit/5*15;
                limit = toBeEnter*(1+(slPercent/100));
                set(handles.setLimit,'String', num2str(limit));
                set(handles.setLimRef,'String', num2str(toBeEnter));
                set(handles.setStopRef,'String', num2str(toBeEnter));
                
            elseif ~strcmp(get(handles.setLimit,'String'), '-')
                limRef = str2double(get(handles.setLimRef,'String'));
                slPercent = -15+voltLimit/5*30;
                limit = limRef*(1+(slPercent/100));
                set(handles.setLimit,'String', num2str(limit));    
            end
            
            enteredAt   = str2double(get(handles.setEnteredAt,'String'));
            stop        = str2double(get(handles.setStop,'String'));
            limit       = str2double(get(handles.setLimit,'String'));
            position    = obj.positionRef;
            
            if isempty(enteredAt) || isnan(enteredAt)
                enteredAt = 0;
            end
            if isempty(stop) || isnan(stop)
                stop = 0;
            end
            if isempty(limit) || isnan(limit)
                limit = 0;
            end
            
            exitNow = 0;
            if (enteredAt ~= 0 & stop ~= 0) &...
                    ~strcmp(get(handles.setDateRef,'String'),strcat(num2str(dateIndx), '-', num2str(OpCl)))
                
                if position == 1
                    if OpCl == 1
                        if stop > op(dateIndx) || digitalExit == 1
                            exitNow = 1;
                        end
                    else
                        if stop > lo(dateIndx) || digitalExit == 1
                            exitNow = 1;
                        end
                    end
                elseif position == -1
                    if OpCl == 1
                        if stop < op(dateIndx) || digitalExit == 1
                            exitNow = 1;
                        end
                    else
                        if stop < hi(dateIndx) || digitalExit == 1
                            exitNow = 1;
                        end
                    end
                end
                
                if exitNow == 1
                    if digitalExit == 1
                        if OpCl == 1
                            exitedAt = op(dateIndx);
                        else
                            exitedAt = cl(dateIndx);
                        end
                    else
                        exitedAt = stop;
                    end
                    if position == 1
                        pr = ((exitedAt-enteredAt)/ enteredAt)*100;
                    elseif position == -1
                        pr = ((enteredAt-exitedAt)/ enteredAt)*100;
                    end
                    pr = num2str(pr + str2num(get(handles.pr,'String')));
                    set(handles.pr,'String', pr)
                    set(handles.setEnteredAt, 'String', '-');
                    enteredAt = 0;
                    stop = 0;
                    obj.positionRef = 0;
                end
            end
            
        
            if pMarket(1) ~= 0
                delete(pMarket)
            end
            
            for i = 1:3
                set(0,'CurrentFigure',i)
                k = 3*i-2:i*3;
                pMarket(k(1)) = plot([dAll(end,1), dAll(1,1)], [1,1]*limit, ':b');
                pMarket(k(2)) = plot([dAll(end,1), dAll(1,1)], [1,1]*enteredAt, 'b');
                pMarket(k(3)) = plot([dAll(end,1), dAll(1,1)], [1,1]*stop, 'r');
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
        
        function [runnerUp, runnerDown] = trackTime(obj, handles, isNew, tAll, i_date, runnerUp, runnerDown, fT)
            
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
            
            if fT == 1
                obj.runnerUpArr = [obj.runnerUpArr; runnerUp];
                obj.runnerDownArr = [obj.runnerDownArr; runnerDown];
                ax = [handles.axes1, handles.axes2, handles.axes3];
                
                for j = 1:3
                histoUp = [];
                for i  = 1:max(obj.runnerUpArr(:,j))       
                    foundLen = length(find(obj.runnerUpArr(:,j) == i));
                    if ~isempty(foundLen)
                    histoUp = [histoUp; foundLen];
                    end 
                end
                
                histoDown = [];
                for i  = 1:max(obj.runnerDownArr(:,j))
                    foundLen = length(find(obj.runnerDownArr(:,j) == i));
                    if ~isempty(foundLen)
                        histoDown = [histoDown; foundLen];
                    end
                end
                histoDown = histoDown*-1;
                
                cla(ax(j))
                
                bar(ax(j), histoUp, 'g');
                hold(ax(j), 'on');
                bar(ax(j), histoDown, 'r');
               
                end 
                
            end
            
        end
        
    end
    
end





