
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
    
    
    
    
    
