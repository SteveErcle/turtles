
classdef TideFinder
    
    properties
        sigMod;
        A;
        P;
        type = 1;
    end
    
    methods
        
        function obj = TideFinder(sigMod, A, P)
            obj.sigMod  = sigMod;
            obj.A       = A;
            obj.P       = P;
        end
        
        
        [theta] = BFtideFinder(obj);
        
        [theta] = GDtideFinder(obj);
        
        [theta] = FTtideFinder(obj);
        
%         FFTtideFinder()
        
        
        function theta = getTheta(obj, eval_Type_String)
            
            if strcmp(eval_Type_String, 'GD')
                theta = GDtideFinder(obj);
            elseif strcmp(eval_Type_String, 'BF')
                theta = BFtideFinder(obj);
            end
            
        end
        
        
    end
end


