classdef TurtleAuto < handle
    
    
    properties
        
        hi; lo; op; cl; vo;
        
        macdvec;
        nineperma;
        
        B;
        
        condition;
        
        ind;
        
        tradeLen;
        enterPrice;
        enterMarket;
        stopLoss;
        trades;
        
        slPercent;
        
    end
    
    methods
        
        function obj = TurtleAuto()
            
            obj.stopLoss.BULL = NaN;
            obj.tradeLen.BULL = 0;
            obj.enterPrice.BULL = NaN;
            obj.enterMarket.BULL = 0;
            obj.trades.BULL = [];
            
            
            obj.stopLoss.BEAR = NaN;
            obj.tradeLen.BEAR = 0;
            obj.enterPrice.BEAR = NaN;
            obj.enterMarket.BEAR = 0;
            obj.trades.BEAR = [];
            
            
        end
        
        function checkConditions(obj)
            
            if  obj.nineperma.INDX(end) < obj.macdvec.INDX(end) %&& nineperma.STOCK(end) < macdvec.STOCK(end)
                obj.condition.MACD_bull_cross = 1;
            else
                obj.condition.MACD_bull_cross = 0;
            end
            
            if  obj.nineperma.INDX(end) > obj.macdvec.INDX(end) %&& nineperma.STOCK(end) < macdvec.STOCK(end)
                obj.condition.MACD_bear_cross = 1;
            else
                obj.condition.MACD_bear_cross = 0;
            end
            
            
            
            
            if obj.B.STOCK(end) >= 0.000 && obj.B.INDX(end) >= 0.0
                obj.condition.MACD_bull_derv = 1;
            else
                obj.condition.MACD_bull_derv = 0;
            end
            
            if obj.B.STOCK(end) <= -0.000 && obj.B.INDX(end) <= 0.0
                obj.condition.MACD_bear_derv = 1;
            else
                obj.condition.MACD_bear_derv = 0;
            end
            
            
            
            
            if obj.lo.STOCK(end) <= obj.stopLoss.BULL
                obj.condition.Not_Stopped_Out.BULL = 0;
            else
                obj.condition.Not_Stopped_Out.BULL = 1;
            end
            
            if obj.hi.STOCK(end) >= obj.stopLoss.BEAR
                obj.condition.Not_Stopped_Out.BEAR = 0;
            else
                obj.condition.Not_Stopped_Out.BEAR = 1;
            end
            
            
            if obj.vo.STOCK(end) > mean(obj.vo.STOCK)
                obj.condition.Large_Volume = 1;
            else
                obj.condition.Large_Volume = 0;
            end
            
            
            
        end
        
        function calculateData(obj)
            
            [obj.macdvec.STOCK, obj.nineperma.STOCK] = macd(obj.cl.STOCK);
            [obj.macdvec.INDX, obj.nineperma.INDX] = macd(obj.cl.INDX);
            
            obj.B.STOCK = [NaN; diff(obj.macdvec.STOCK)];
            obj.B.INDX  = [NaN; diff(obj.macdvec.INDX)];
            
            if obj.tradeLen.BULL <= 2
                obj.stopLoss.BULL = obj.enterPrice.BULL*(1.00-obj.slPercent/100);
            else
                
                if obj.lo.STOCK(end-2) > obj.stopLoss.BULL
                    obj.stopLoss.BULL = obj.lo.STOCK(end-2);
                end
                %%%%% IF NOT LOWER %%%%%
            end
            
            if obj.tradeLen.BEAR <= 2
                obj.stopLoss.BEAR = obj.enterPrice.BEAR*(1.00+obj.slPercent/100);
            else
                if  obj.hi.STOCK(end-2) < obj.stopLoss.BEAR
                    obj.stopLoss.BEAR = obj.hi.STOCK(end-2);
                end 
            end
            
        end
        
        function executeBullTrade(obj)
            
            if obj.condition.MACD_bull_cross && obj.condition.MACD_bull_derv...
                    && obj.condition.Not_Stopped_Out.BULL %&& obj.condition.Large_Volume
                
                if obj.enterMarket.BULL == 0
                    obj.enterPrice.BULL = obj.cl.STOCK(end);
                    obj.trades.BULL = [obj.trades.BULL; obj.enterPrice.BULL, NaN, length(obj.cl.STOCK), NaN];
                end
                
                obj.enterMarket.BULL = 1;
                obj.tradeLen.BULL = obj.tradeLen.BULL + 1;
                
            else
                
                if obj.enterMarket.BULL == 1
                    
                    if obj.condition.Not_Stopped_Out.BULL
                        obj.trades.BULL(end,2) = obj.cl.STOCK(end);
                    else
                        obj.trades.BULL(end,2) = obj.stopLoss.BULL;
                    end
                    
                    obj.trades.BULL(end,4) = length(obj.cl.STOCK);
                    
                    obj.ind = obj.ind-1;
                end
                
                obj.enterMarket.BULL = 0;
                obj.enterPrice.BULL = NaN;
                obj.tradeLen.BULL = 0;
                obj.stopLoss.BULL = NaN;
                
            end
            
        end
        
        function executeBearTrade(obj)
            
            if obj.condition.MACD_bear_cross && obj.condition.MACD_bear_derv...
                    && obj.condition.Not_Stopped_Out.BEAR %&& obj.condition.Large_Volume
                
                if obj.enterMarket.BEAR == 0
                    obj.enterPrice.BEAR = obj.cl.STOCK(end);
                    obj.trades.BEAR = [obj.trades.BEAR; obj.enterPrice.BEAR, NaN, length(obj.cl.STOCK), NaN];
                end
                
                obj.enterMarket.BEAR = 1;
                obj.tradeLen.BEAR = obj.tradeLen.BEAR + 1;
                
            else
                
                if obj.enterMarket.BEAR == 1
                    
                    if obj.condition.Not_Stopped_Out.BEAR
                        obj.trades.BEAR(end,2) = obj.cl.STOCK(end);
                    else
                        obj.trades.BEAR(end,2) = obj.stopLoss.BEAR;
                    end
                    
                    obj.trades.BEAR(end,4) = length(obj.cl.STOCK);
                    
                    obj.ind = obj.ind-1;
                end
                
                obj.enterMarket.BEAR = 0;
                obj.enterPrice.BEAR = NaN;
                obj.tradeLen.BEAR = 0;
                obj.stopLoss.BEAR = NaN;
                
            end
            
        end

    end
    
end
