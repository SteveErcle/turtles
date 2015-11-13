classdef TurtleMarket
    
    properties
        
        totalShares;
        price;
        exchange;
        
    end
    
    methods
        
        function obj = TurtleMarket(totalShares, price)
            obj.totalShares = totalShares;
            obj.price = price;
        end
        
        
        function [obj, Shark1, Shark2] = equalizeMarket(obj, Shark1, Shark2)
            
            
     
            sellOrders =  Shark1.sell;
            buyOrders =  Shark2.buy;
            equl = (Shark1.hold + Shark2.hold)/2;
            
            
          
            
            if sellOrders >= buyOrders
                rateOfChange = (sellOrders+equl)/(buyOrders+equl);
                obj.price = obj.price - rateOfChange;
                sellOrders = sellOrders - buyOrders;
                buyOrders = buyOrders - buyOrders;
            else
                rateOfChange = (buyOrders + equl)/(sellOrders+equl);
                obj.price = obj.price + rateOfChange;
                buyOrders = buyOrders - sellOrders;
                sellOrders = sellOrders - sellOrders;
            end
            
            
            Shark1.sell = sellOrders;
            Shark2.buy = buyOrders;
            
            
        end
        
        
        
    end
    
end

