
classdef TurtleSim
    
    properties
        
    end
    
    methods
        
        function [] = resetButtons(obj, handles)
            
            set(handles.M, 'Value', 0);
            set(handles.W, 'Value', 0);
            set(handles.D, 'Value', 0);
            set(handles.I, 'Value', 0);
            set(handles.V, 'Value', 0);
            
        end
        
        function [hlcoM] = updateMonth(obj, hlcoM, hlcoMs, hlcoD)
            
            
            if sum((hlcoD.da(1) == hlcoMs.da)) == 1
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
            
            if sum((hlcoD.da(1) == hlcoWs.da)) == 1
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
        
    end
    
end





