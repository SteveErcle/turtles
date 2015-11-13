classdef Shark
    
    properties
        
  
        hold;
        buy;
        sell;
        
    end
    
    methods
        
        function obj = Shark(totalShares)
            obj.hold = totalShares;
            obj.buy = 0;
            obj.sell = 0;
        end
        
        function [obj] = sellOrder(obj, sellAmount)
            if sellAmount > obj.hold
                sprintf('Cant sell more shares than you own')
            else
                obj.sell = sellAmount;
                obj.hold = obj.hold-sellAmount;
                obj.buy = 0;
            end
        end
        
        
        function [obj] = buyOrder(obj, buyAmount)
            
            obj.buy = buyAmount;
            obj.hold = obj.hold+buyAmount;
            obj.sell = 0;       
        end
    end
    
end

