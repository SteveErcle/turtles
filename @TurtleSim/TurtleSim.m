
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
        
        function [] = initHandles(obj, handles, simPres, aniLen, axisLen, aniSpeed)
            
            set(handles.updateAxis, 'Value', 1);
            
            set(handles.simPres, 'Max', 150, 'Min', 1);
            set(handles.simPres, 'SliderStep', [1/150, 10/150]);
            set(handles.simPres, 'Value', get(handles.simPres, 'Max') - simPres + 1);
            
            set(handles.aniLen, 'Max', 150, 'Min', 1);
            set(handles.aniLen, 'SliderStep', [1/150, 10/150]);
            set(handles.aniLen, 'Value', get(handles.aniLen, 'Max') - aniLen);
            
            set(handles.axisLen, 'Max', 500, 'Min', 1);
            set(handles.axisLen, 'SliderStep', [1/500, 10/500]);
            set(handles.axisLen, 'Value', axisLen);
            
            set(handles.aniSpeed, 'Max', 1, 'Min', 0.01);
            set(handles.aniSpeed, 'SliderStep', [1/100, 10/100]);
            set(handles.aniSpeed, 'Value', get(handles.aniSpeed, 'Max') - aniSpeed);
            
            set(handles.offsetAxis, 'Max', 500, 'Min', 0);
            set(handles.offsetAxis, 'SliderStep', [1/500, 10/500]);
            set(handles.offsetAxis, 'Value', 0);
            
        end
        
        function [simPres] = getSimulationPresent(obj, handles)
            
            if get(handles.play, 'Value')
                newSimPres = floor(get(handles.simPres, 'Value')+1);
                set(handles.simPres, 'Value', newSimPres);
            end
            
            simPres = get(handles.simPres, 'Max') - floor(get(handles.simPres, 'Value')) + 1;
        end
        
        function [aniSpeed] = setAnimation(obj, handles, curIndx, simPres)
            
            aniSpeed = get(handles.aniSpeed, 'Max') - (get(handles.aniSpeed, 'Value'));
            
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
        
        function [axisLen, axisParams] = setAxis(obj, handles, axisLen, axisParams, hlcoD)
            
            if get(handles.updateAxis, 'Value')
                
                set(handles.axisLen, 'Max', length(hlcoD.da) , 'Min', 1);
                if get(handles.axisLen, 'Max') < axisLen
                    set(handles.axisLen, 'Value', floor(get(handles.axisLen, 'Max')) - 1);
                end
                
                axisLen = floor(get(handles.axisLen, 'Value'));
                
                offset = floor(get(handles.offsetAxis, 'Value'));
                
                view = axisLen + offset;
                
                if view > length(hlcoD.da)
                    view = length(hlcoD.da);
                end
                
                if offset + 1 > length(hlcoD.da)
                    offset = length(hlcoD.da) - 1;
                end
                
                x1 = hlcoD.da(view);
                x2 = hlcoD.da(1+offset)+7;
                y1 = min(hlcoD.lo(1+offset:view))*.995;
                y2 = max(hlcoD.hi(1+offset:view))*1.005;
                
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
        
        function [newTimePeriod] = isNewTimePeriod(obj, hlcoTs, hlcoD)
            
            if sum((hlcoD.da(1) == hlcoTs.da)) == 1
                newTimePeriod = 1;
            else
                newTimePeriod = 0;
            end
            
        end
        
        function [ok] = isUpdateCorrect(obj, hlcoTs, hlcoT)
            
            spot = find(hlcoT.da(2) == hlcoTs.da);
            hiChecker = hlcoT.hi(2:end) == hlcoTs.hi(spot:end);
            loChecker = hlcoT.lo(2:end) == hlcoTs.lo(spot:end);
            clChecker = hlcoT.cl(2:end) == hlcoTs.cl(spot:end);
            opChecker = hlcoT.op(2:end) == hlcoTs.op(spot:end);
            
            if length(hiChecker) ~= sum(hiChecker)
                ok = 0;
                
            elseif length(loChecker) ~= sum(loChecker)
                ok = 0;
                
            elseif   length(clChecker) ~= sum(clChecker)
                ok = 0;
                
            elseif  length(opChecker) ~= sum(opChecker)
                ok = 0;
                
            else
                ok = 1;
            end
            
            if ok == 0
                sprintf('ERROR, updater failed')
            end
            
        end
        
        function [hlcoD] = updateDay(obj, curIndx, hlcoDs, hlcoD)
            
            hlcoD.op = [hlcoDs.op(curIndx); hlcoD.op];
            hlcoD.cl = [hlcoDs.cl(curIndx); hlcoD.cl];
            hlcoD.hi = [hlcoDs.hi(curIndx); hlcoD.hi];
            hlcoD.lo = [hlcoDs.lo(curIndx); hlcoD.lo];
            hlcoD.da = [hlcoDs.da(curIndx); hlcoD.da];
            
        end
        
        function [hlcoT] = update(obj, hlcoT, hlcoTs, hlcoD)
            
            if obj.isNewTimePeriod(hlcoTs, hlcoD)
                hlcoT.op = [hlcoD.op(1); hlcoT.op];
                hlcoT.cl = [hlcoD.cl(1); hlcoT.cl];
                hlcoT.hi = [hlcoD.hi(1); hlcoT.hi];
                hlcoT.lo = [hlcoD.lo(1); hlcoT.lo];
                hlcoT.da = [hlcoD.da(1); hlcoT.da];
            else
                hlcoT.cl(1) = hlcoD.cl(1);
            end
            
            if hlcoD.hi(1) > hlcoT.hi(1)
                hlcoT.hi(1) = hlcoD.hi(1);
            end
            
            if hlcoD.lo(1) < hlcoT.lo(1)
                hlcoT.lo(1) = hlcoD.lo(1);
            end
            
            
        end
        
        function [pT] = animate(obj, aniSpeed, isT, isNew, hlcoT, fT, pT)
            
            tf = TurtleFun;
            
            if isT
                if isNew
                    figure(fT)
                    [~,pTo] = tf.plotOpen(hlcoT);

                end
                
                pause(aniSpeed)
                
                if isNew
                    delete(pTo);
                end
                
                delete(pT);
                figure(fT)
                [~,pT] = tf.plotHiLo(hlcoT);
                
            end
            
        end
        
        function [pTo, axisLen, axisParams] = animateOpen(obj, aniSpeed, isT, isNew, hlcoT, fT,...
                 handles, axisLen, axisParams, hlcoD_axis)
            
            tf = TurtleFun;
            
            pTo = 0;
            
            if isT
                if isNew
                    figure(fT)
                    [~,pTo] = tf.plotOpen(hlcoT); 
                end
                
            end
            
            [axisLen, axisParams] = obj.setAxis(handles, axisLen, axisParams, hlcoD_axis);
                    
            pause(aniSpeed)
            
        end
        
        function [pT, axisLen, axisParams] = animateClose(obj, aniSpeed, isT, isNew, hlcoT, fT, pT, pTo,...
                handles, axisLen, axisParams, hlcoD_axis)
            
            tf = TurtleFun;
            
            if isT
                
                if isNew & pTo ~= 0
                    delete(pTo);
                end
                
                delete(pT);
                figure(fT)
                [~,pT] = tf.plotHiLo(hlcoT);
                
            end
            
            [axisLen, axisParams] = obj.setAxis(handles, axisLen, axisParams, hlcoD_axis);
            
            pause(aniSpeed)
            
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
                    pMarket(i) = plot([hlcoDs_lev.da(end), hlcoDs_lev.da(1)], [1,1]*ub, 'k')
                    pMarket(i+1) = plot([hlcoDs_lev.da(end), hlcoDs_lev.da(1)], [1,1]*enter, 'b')
                    pMarket(i+2) = plot([hlcoDs_lev.da(end), hlcoDs_lev.da(1)], [1,1]*lb, 'k')
                    set(handles.setLevel, 'Value', 0);
                    
                end
            end
        end
        
        function [hlcoT] = resetAnimation(obj, daysFromPresent, hlcoTs, hlcoDs)
            
            i = 0;
            while sum(hlcoDs.da(daysFromPresent+i) == hlcoTs.da) == 0
                i = i+1;
            end
            
            resetDay = hlcoDs.da(daysFromPresent+i);
            
            It = find(resetDay == hlcoTs.da);
            hlcoT = hlcoTs.reset(It, hlcoTs);
            
            Id = find(resetDay == hlcoDs.da);
            hlcoUpdater = hlcoDs.reset(Id, hlcoDs);
            
            startUpdateIndx = Id - 1;
            
            for curIndx = startUpdateIndx:-1:daysFromPresent
                hlcoUpdater = obj.updateDay(curIndx, hlcoDs, hlcoUpdater);
                hlcoT = obj.update(hlcoT, hlcoTs, hlcoUpdater);
            end
            
        end
        
        function [hlcoD, hlcoW, hlcoM] = resetAll(obj, handles, hlcoDs, hlcoWs, hlcoMs)
            
            daysFromCurrent = get(handles.aniLen, 'Max') - floor(get(handles.aniLen, 'Value')) + 1;
            simPres = get(handles.simPres, 'Max') - floor(get(handles.simPres, 'Value')) + 1;
            daysFromPresent = daysFromCurrent + simPres;
            
            [hlcoD] = obj.resetAnimation(daysFromPresent, hlcoDs, hlcoDs);
            [hlcoW] = obj.resetAnimation(daysFromPresent, hlcoWs, hlcoDs);
            [hlcoM] = obj.resetAnimation(daysFromPresent, hlcoMs, hlcoDs);
            
        end
        
    end
    
end





