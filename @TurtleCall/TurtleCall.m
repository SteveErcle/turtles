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
            xlimit = xlim;
            plot([xlimit(1), xlimit(2)], [obj.P(1,2), obj.P(1,2)]);
            
        end
        
        
        function callKey(obj, object, eventdata);
            key = eventdata.Key;

            obj.mode = key
           
        end 
        
        
        function callClick(obj, object, eventdata)
          get(gca, 'CurrentPoint')
            
        end 
        
    end
end
