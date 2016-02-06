
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
        
    end
    
end