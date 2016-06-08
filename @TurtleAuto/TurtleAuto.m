classdef TurtleAuto < handle
    
    
    properties
        
        hi; lo; op; cl; vo;
        
        macdvec;
        nineperma;
        
        B;
     
    end
    
    methods
        
        
        function obj = TurtleAuto()
            
            obj.hi.STOCK;
            obj.lo.STOCK;
            obj.op.STOCK;
            obj.cl.STOCK;
            obj.vo.STOCK;
            
            obj.cl.INDX;
            obj.vo.INDX;
            
            obj.macdvec.STOCK;
            obj.nineperma.STOCK;
            
            obj.macdvec.INDX;
            obj.nineperma.INDX;
            
            obj.B.STOCK;
            obj.B.INDX;
            
        end
        
        
        
        function checkConditions(obj)
            
            if  obj.nineperma.INDX(obj.i) < obj.macdvec.INDX(obj.i) %&& nineperma.STOCK(i) < macdvec.STOCK(i)
                obj.condition.MACD_bull_cross = 1;
            else
                obj.condition.MACD_bull_cross = 0;
            end
            
            if obj.B.STOCK(obj.i) >= 0.005 && obj.B.INDX(obj.i) >= 0.0
                obj.condition.MACD_bull_derv = 1;
            else
                obj.condition.MACD_bull_derv = 0;
            end
            
            if obj.lo.STOCK(obj.i) <= stopLoss
                obj.condition.Not_Stopped_Out = 0;
            else
                obj.condition.Not_Stopped_Out = 1;
            end
            
            if obj.vo.STOCK(obj.i) > mean(obj.vo.STOCK)
                obj.condition.Large_Volume = 1;
            else
                obj.condition.Large_Volume = 0;
            end
            
        end
        
        
        
    end
    
    
    
end
