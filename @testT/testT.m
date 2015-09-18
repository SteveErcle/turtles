classdef testT
    
    properties
        A = 1;
        B = 2;
        C = 3;
        
        EE;
 
        
    end
    
    methods
        
        
        function obj = testT(A,B,C)
            obj.A = A;
            obj.B = B;
            obj.C = C;
        end 
            
            
        function W = t1(obj)
            
            D = tinside1(obj);
            W = D;
            
        end
        
        function A = t2(obj)
            
            A = 3;
        end 
        
        
         [D] = tinside1(obj, cc,dd,rr)
    end
    
            
     
        
    
    
end
