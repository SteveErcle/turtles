classdef Eaton
    
    properties 
        a = 1;
        b = 2;
        c;
    end
    
    methods
        
%         function EadMulter(obj)
%             obj.a = obj.a*10;
%         end
        
        function cat =  EadMulter(obj)
            cat = obj.a+obj.b+obj.c;
        end
        
    end
    
    
end 
