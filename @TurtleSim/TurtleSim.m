
classdef TurtleSim
    
    properties
        
    end
    
    methods
        
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
            
            set(handles.simPres, 'Max', 150, 'Min', 1);
            set(handles.simPres, 'SliderStep', [1/150, 10/150]);
            set(handles.simPres, 'Value', get(handles.simPres, 'Max') - simPres + 1);
            
            set(handles.aniLen, 'Max', 150, 'Min', 0);
            set(handles.aniLen, 'SliderStep', [1/150, 10/150]);
            set(handles.aniLen, 'Value', get(handles.aniLen, 'Max') - aniLen);
            
            set(handles.axisLen, 'Max', dAll(1,1), 'Min', dAll(end,1));
            lenOfTime = dAll(1,1) - dAll(end,1);
            set(handles.axisLen, 'SliderStep', [1/lenOfTime, 10/lenOfTime]);
            set(handles.axisLen, 'Value', dAll(1,1) - axisLen);
            
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
        
        function [aniSpeed, aniLen] = setAnimation(obj, handles, curIndx, simPres)
            
            aniSpeed = get(handles.aniSpeed, 'Max') - (get(handles.aniSpeed, 'Value'));
            aniLen   = get(handles.aniLen, 'Max') - floor(get(handles.aniLen, 'Value'));
            
            if ~get(handles.runAnimation, 'Value')
                aniSpeed = 0;
            end
            
            if get(handles.play, 'Value')
                
                if curIndx ~= simPres
                    
                    maxMinusMin = get(handles.aniSpeed,'Max') - get(handles.aniSpeed,'Min');
                    set(handles.aniSpeed,'Value', maxMinusMin);
                    aniSpeed = 0;
                else
                    set(handles.aniSpeed,'Value', 0.75);
                end
                set(handles.aniLen, 'Value', get(handles.aniLen, 'Max'));
                
            end
            
        end
        
        function [axisLen, axisParams] = setAxis(obj, handles, axisLen, axisParams, date)

            if get(handles.updateAxis, 'Value')
            
                axisLen = floor(get(handles.axisLen, 'Value'));
                
                offset = floor(get(handles.offsetAxis, 'Value'));

%                 if view > length(dAll(:,1))
%                     view = length(dAll(:,1));
%                 end
%                 
%                 if offset + 1 > length(dAll(:,1))
%                     offset = length(dAll(:,1)) - 1;
%                 end
% %                 

                x1 = date - offset;
                x2 = date;
                y1 = 0;
                y2 = 30;

%                 x1 = dAll(:,1)(view);
%                 x2 = dAll(:,1)(1+offset)+7;
%                 y1 = min(dAll.lo(1+offset:view))*.995;
%                 y2 = max(dAll.hi(1+offset:view))*1.005;
%                 
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
        
        function [pMarket] = playTurtles(obj, handles, pMarket, curIndx, simPres, hlcoDs_lev)
            
            if get(handles.play, 'Value') & curIndx == simPres
                while ~get(handles.next, 'Value')
                    
                    pause(0.1);
                    
                    pMarket = obj.plotTrade(handles, pMarket, hlcoDs_lev);
                    
                end
                
            end
            
            set(handles.next, 'Value', 0);
        end
        
        function [pMarket] = plotTrade(obj, handles, pMarket, hlcoDs_lev)
            
            if get(handles.setLevel, 'Value')
                
                ub = str2double(get(handles.ub,'String'));
                enter = str2double(get(handles.enter,'String'));
                lb = str2double(get(handles.lb,'String'));
                
                if pMarket(1) ~= 0
                    delete(pMarket)
                end
                
                for i = 1:3
                    figure(i)
                    pMarket(i) = plot([hlcoDs_lev.da(end), hlcoDs_lev.da(1)], [1,1]*ub, 'k');
                    pMarket(i+1) = plot([hlcoDs_lev.da(end), hlcoDs_lev.da(1)], [1,1]*enter, 'b');
                    pMarket(i+2) = plot([hlcoDs_lev.da(end), hlcoDs_lev.da(1)], [1,1]*lb, 'k');
                    set(handles.setLevel, 'Value', 0);
                    
                end
            end
        end
 
    end
    
end





