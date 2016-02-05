
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
        
        
        function [hlcoM] = updateMonth(obj, curIndx, hlcoM, hlcoMs, hlcoDs)
            
            
            if sum((hlcoDs.da(curIndx) == hlcoMs.da)) == 1
                1
                hlcoM.op = [hlcoDs.op(curIndx); hlcoM.op]
                hlcoM.cl = [hlcoDs.cl(curIndx); hlcoM.cl]
                hlcoM.hi = [hlcoDs.hi(curIndx); hlcoM.hi]
                hlcoM.lo = [hlcoDs.lo(curIndx); hlcoM.lo]
            else
                hlcoM.cl(1) = hlcoDs.cl(curIndx);
            end
            
            if hlcoDs.hi(curIndx) > hlcoM.hi(1)
                hlcoM.hi(1) = hlcoDs.hi(curIndx);
            end
            
            if hlcoDs.lo(curIndx) < hlcoM.lo(1)
                hlcoM.lo(1) = hlcoDs.lo(curIndx);
            end
            %     sum((daDs(curIndx) == daWs)) == 1
            
        end
        
        
        
    end
    
end





