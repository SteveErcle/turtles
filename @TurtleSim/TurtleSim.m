
classdef TurtleSim < handle
    
    properties
        
        dAll;
        iAll;
        runnerUpArr = [];
        runnerDownArr = [];
        volumeArr = [];
        maxStop = [];
        positionRef = 0;
        i_dateH = 0;
        i_intraH;
        dCong;
        wCong;
        mCong;
        dayAnnotation = 0;
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
                y1 = min(lo(I2:I1))*0.99;
                y2 = max(hi(I2:I1))*1.01;
                
                [Md Id1] = min(abs(obj.dAll(:,1) - (date - offset - axisLen/3)));
                [Md Id2] = min(abs(obj.dAll(:,1) - (date - offset)));
                
             
                if OpCl == 1
                    hi(Id2) = op(Id2);
                    lo(Id2) = op(Id2);
                end
                
                xd1 = date - offset - axisLen/3;
                xd2 = date - offset + 35;
                yd1 = min(lo(Id2:Id1))*0.99;
                yd2 = max(hi(Id2:Id1))*1.01;
                

                for i = 1:3
                    
                    set(0,'CurrentFigure',i)
                    if i == 1
                        axis([xd1, xd2, yd1, yd2]);
                    else
                        axis([x1, x2, y1, y2]);
                    end
                    
                end
                
                axisParams = [x1, x2, y1, y2];
                
            end
            
            x1 = axisParams(1);
            x2 = axisParams(2);
            y1 = axisParams(3);
            y2 = axisParams(4);
            
%             axis([x1, x2, y1, y2]);
            
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
                digitalLimit = 1;
            elseif digitals == [0,0,0,1]
                digitalResetStop = 1;
%                 set(handles.next, 'Value', 1);
            elseif digitals == [0,0,0,1]
                ;
            elseif digitals == [0,0,1,1]
%                 digitalResetStop = 1;
            end 
    
            if OpCl == 1
                toBeEnter = op(dateIndx);
            elseif OpCl == 2
                toBeEnter = cl(dateIndx);
            elseif OpCl == 0;
                toBeEnter = obj.iAll.close(obj.i_intraH);
            end 
            
            if (obj.positionRef == 1 || obj.positionRef == -1) & digitalMarket == 1
                digitalExit = 1;
                digitalMarket = 0;
            end 
                
            
            if digitalMarket == 1
                set(handles.setEnteredAt,'String', num2str(toBeEnter));
                set(handles.setStopRef,'String', num2str(toBeEnter));
                set(handles.setLimit,'String', '-');
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
                set(handles.setDateRef,'String', strcat(num2str(dateIndx), '-', num2str(OpCl)));
                
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
            
            
            if ~strcmp(get(handles.setLimit,'String'), '-') &...
                    ~strcmp(get(handles.setDateRef,'String'),strcat(num2str(dateIndx), '-', num2str(OpCl)))
              
                if OpCl == 1
                    hi(dateIndx) = op(dateIndx);
                    lo(dateIndx) = op(dateIndx);
                end 
                
                if limit > stop 
                    if hi(dateIndx) > limit & lo(dateIndx) <= limit
                        set(handles.setEnteredAt,'String', num2str(limit));
                        enteredAt = limit;
                        set(handles.setLimit,'String', '-');
                        obj.positionRef = 1;
                        position = 1;
                    end
                else
                    if lo(dateIndx) < limit & hi(dateIndx) >= limit
                        set(handles.setEnteredAt,'String', num2str(limit));
                        enteredAt = limit;
                        set(handles.setLimit,'String', '-');
                        obj.positionRef = -1;
                        position = -1;
                    end
                    
                end
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
                    
                    if str2num(pr) <= -obj.maxStop
                        filename = strcat(datestr(now),'.fig');
                        path = strcat('/Losing Trades/', filename, '-', num2str(obj.maxStop), '.fig');
                        saveas(figure(1),[pwd path]);
                    else
                        filename = strcat(datestr(now));
                        path = strcat('/Winning Trades/', filename, '-', num2str(obj.maxStop), '.fig');
                        saveas(figure(1),[pwd path]);
                    end 
                    
                    
                end
            end
            
            if pMarket(1) ~= 0
                if ishandle(pMarket(10))
                    delete(pMarket)
                else
                    delete(pMarket(1:9))
                end
            end
            
            for i = 1:4
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
        
        function [runnerUp, runnerDown] = trackTime(obj, handles, tAll, runnerUp, runnerDown, OpCl, fT)
            
            tRunnerUp = runnerUp(fT);
            tRunnerDown = runnerDown(fT);
            
            td = TurtleData;
            dateIndx_tomorrow = td.getDateIndx(obj.dAll(:,1), obj.i_dateH) - 1;
            i_date_tomorrow = obj.dAll(dateIndx_tomorrow);
            
            if fT == 1
                isNew =  obj.isNewTimePeriod(obj.dCong, i_date_tomorrow);
                tCong = obj.dCong;
            elseif fT == 2
                isNew = obj.isNewTimePeriod(obj.wCong, i_date_tomorrow);
                tCong = obj.wCong;
            elseif fT == 3
                isNew = obj.isNewTimePeriod(obj.mCong, i_date_tomorrow);
                tCong = obj.mCong;
            end
                
            
            if isNew & OpCl == 2
                tf = TurtleFun;
                [hi, lo, cl, op, da] = tf.returnOHLCDarray(tAll);
                
                dateIndx = td.getDateIndx(tCong(:,8), obj.i_dateH);
                timePeriod_today = tCong(dateIndx,1);
                dateIndx = td.getDateIndx(tAll(:,1), timePeriod_today);
                
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
                text(da(dateIndx), hi(dateIndx)*1.01, strcat(num2str(tRunnerUp)));
                text(da(dateIndx), lo(dateIndx)*0.99, strcat(num2str(tRunnerDown)));
                
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
        
        function [] = trackVolume(obj, handles, OpCl)
            
            td = TurtleData;
            
            
            if isempty(obj.volumeArr)
                cla(handles.axes4)
            end
            
            if OpCl == 2
                
                dateIndx = td.getDateIndx(obj.dAll(:,1), obj.i_dateH);
                
                disp(strcat('Volume Date: ', datestr(obj.dAll(dateIndx,1))));
                disp(strcat('Volume Amount: ', num2str(obj.dAll(dateIndx,6))));
                
                obj.volumeArr = [obj.volumeArr; obj.i_dateH, obj.dAll(dateIndx,6)];
                
                bar(handles.axes4, obj.volumeArr(:,1), obj.volumeArr(:,2));
%                 axis(handles.axes4, 'equal')
                hold(handles.axes4, 'on');
                
            end
            
        end 
            
        function[] = plotAnnotation(obj, OpCl)
            
            tf = TurtleFun;
            td = TurtleData;
            [hi, lo, cl, op, da] = tf.returnOHLCDarray(obj.dAll);
            
            dateIndx = td.getDateIndx(obj.dAll(:,1), obj.i_dateH);
            
            if OpCl == 1
                dayStatus = strcat('op: ', num2str(op(dateIndx)));
            elseif OpCl == 2
                dayStatus = strcat('op: ', num2str(op(dateIndx)), ' hi: ', num2str(hi(dateIndx)),...
                    ' lo: ', num2str(lo(dateIndx)), ' cl: ', num2str(cl(dateIndx)));
            end
          
            dim = [.80 .12 .05 .11];
            
            if obj.dayAnnotation ~= 0
                delete(obj.dayAnnotation);
            end 
            
            set(0,'CurrentFigure',1)
            obj.dayAnnotation = annotation('textbox',dim,'String', dayStatus);

        end 
                  
        function [] = intraDayViewer(obj, handles, fInt)
            
            if get(handles.I, 'Value')
                
                tf = TurtleFun;
                
                simDate = datestr(obj.i_dateH,2);
                intraIndx = strmatch(simDate, obj.iAll.dateDay);
                
                if isempty(intraIndx)
                    disp('** Intraday data not available **')
                else
                    
                    
                    hi = obj.iAll.high(intraIndx);
                    lo = obj.iAll.low(intraIndx);
                    op = obj.iAll.close([intraIndx(1);intraIndx(1:end-1)]);
                    cl = obj.iAll.close(intraIndx);
                    da = obj.iAll.date(intraIndx);
                    
                    intraDay = [da, op, hi, lo, cl];
                    
                    datestr(da(1))
                    
                    set(0,'CurrentFigure',fInt)
                    cla;
                    
                    for i = 1:size(intraDay,1)
                        
                        obj.i_intraH = intraIndx(i);
                        obj.iAll.close(obj.i_intraH)
                        tf.plotHiLoSolo(intraDay(i,:), 0.0003*5);
                        datetick('x',15, 'keeplimits');
                        
                        maxHi = max(hi(1:i))
                        minLo = min(lo(1:i))
                        
                        if get(handles.play, 'Value')
                            while ~get(handles.next, 'Value')
                                pause(0.1);
                            end
                            set(handles.next, 'Value', 0);
                        else
                            aniSpeed = get(handles.aniSpeed, 'Max') - (get(handles.aniSpeed, 'Value'));
                            pause(aniSpeed);
                        end
                    end
                    
                end
            end
            
        end
        
    end
    
end





