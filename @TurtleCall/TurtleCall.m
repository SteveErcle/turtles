classdef TurtleCall < handle
    
    properties
        
        P = [];
        lastP = [];
        
        mode = 'l';
        
    end
    
    methods
        
        function callMouse(obj, object, eventdata)
            
            obj.P = get(gca, 'CurrentPoint');
            obj.P;
            
        end
        
        
        function callKey(obj, object, eventdata);
            key = eventdata.Key;
            
            obj.mode = key;
           
        end 
        
        
    end
end
