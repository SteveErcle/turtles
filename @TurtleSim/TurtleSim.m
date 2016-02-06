
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
        
        function [hlcoM] = updateMonth(obj, hlcoM, hlcoMs, hlcoD)
            
            if obj.isNewTimePeriod(hlcoMs, hlcoD)
                hlcoM.op = [hlcoD.op(1); hlcoM.op];
                hlcoM.cl = [hlcoD.cl(1); hlcoM.cl];
                hlcoM.hi = [hlcoD.hi(1); hlcoM.hi];
                hlcoM.lo = [hlcoD.lo(1); hlcoM.lo];
                hlcoM.da = [hlcoD.da(1); hlcoM.da];
            else
                hlcoM.cl(1) = hlcoD.cl(1);
            end
            
            if hlcoD.hi(1) > hlcoM.hi(1)
                hlcoM.hi(1) = hlcoD.hi(1);
            end
            
            if hlcoD.lo(1) < hlcoM.lo(1)
                hlcoM.lo(1) = hlcoD.lo(1);
            end
            
            
        end
        
        function [hlcoW] = updateWeek(obj, hlcoW, hlcoWs, hlcoD)
            
            if obj.isNewTimePeriod(hlcoWs, hlcoD)
                hlcoW.op = [hlcoD.op(1); hlcoW.op];
                hlcoW.cl = [hlcoD.cl(1); hlcoW.cl];
                hlcoW.hi = [hlcoD.hi(1); hlcoW.hi];
                hlcoW.lo = [hlcoD.lo(1); hlcoW.lo];
                hlcoW.da = [hlcoD.da(1); hlcoW.da];
            else
                hlcoW.cl(1) = hlcoD.cl(1);
            end
            
            if hlcoD.hi(1) > hlcoW.hi(1)
                hlcoW.hi(1) = hlcoD.hi(1);
            end
            
            if hlcoD.lo(1) < hlcoW.lo(1)
                hlcoW.lo(1) = hlcoD.lo(1);
            end
            
        end
        
        function [hlcoD] = updateDay(obj, curIndx, hlcoDs, hlcoD)
            
            hlcoD.op = [hlcoDs.op(curIndx); hlcoD.op];
            hlcoD.cl = [hlcoDs.cl(curIndx); hlcoD.cl];
            hlcoD.hi = [hlcoDs.hi(curIndx); hlcoD.hi];
            hlcoD.lo = [hlcoDs.lo(curIndx); hlcoD.lo];
            hlcoD.da = [hlcoDs.da(curIndx); hlcoD.da];
            
        end
        
        function [pT] = animateDay(obj, aniSpeed, isT, hlcoT, fT, pT)
                     
            tf = TurtleFun;
            
            if isT
                figure(fT)
                [~,pTo] = tf.plotOpen(hlcoT);
                pause(aniSpeed)
                delete(pTo);
                delete(pT);
                figure(fT)
                [~,pT] = tf.plotHiLo(hlcoT);
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
     
%         function [pT] = animateMonth(obj, aniSpeed, isT, isNew, hlcoT, fT, pT)
%             
%             tf = TurtleFun;
%             
%             if isT
%                 if isNew
%                     figure(fT)
%                     [~,pTo] = tf.plotOpen(hlcoT);
%                 end
%                 
%                 pause(aniSpeed)
%                 
%                 if isNew
%                     delete(pTo);
%                 end
%                 
%                 delete(pT);
%                 figure(fT)
%                 [~,pT] = tf.plotHiLo(hlcoT);
%                 
%             end
% 
%         end
        
        
    end
    
end





