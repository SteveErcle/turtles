
classdef TurtleVal
    
    properties
        
        hi;
        lo;
        cl;
        op;
        da;
        
    end
    
    
    methods
        
        function obj = TurtleVal(t)
            
            tf = TurtleFun;
            [hiT, loT, clT, opT, daT] = tf.returnOHLCDarray(t);
            
            obj.hi  = hiT;
            obj.lo  = loT;
            obj.cl  = clT;
            obj.op  = opT;
            obj.da  = daT;


        end
        
        function [obj] = reset(obj, indxBack, hlcoTs)
                   
            obj.hi = hlcoTs.hi(indxBack:end);
            obj.lo = hlcoTs.lo(indxBack:end);
            obj.cl = hlcoTs.cl(indxBack:end);
            obj.op = hlcoTs.op(indxBack:end);
            obj.da = hlcoTs.da(indxBack:end);
            
        end 
            
     
    end
    
end