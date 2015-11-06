classdef Construction
    
    properties
        
        A;
        P;
        theta;
        predLen;
        sigMod;
        
        
    end
    
    methods
    
        function obj = Construction(A, P, theta, predLen, sigMod)
            obj.A = A;
            obj.P = P;
            obj.theta = theta;
            obj.predLen = predLen;
            obj.sigMod = sigMod;
        end
       
        [model, prediction, projection] = constructPro(obj);
        
        plotPro(obj, projection, sigPlt);
        
        plotPlay(obj, projection, sigPlt)
        
    end
    
end
