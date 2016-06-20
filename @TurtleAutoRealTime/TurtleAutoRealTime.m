classdef TurtleAutoRealTime < handle
    
    
    properties
        
        hi; lo; op; cl; vo; da;
        
        macdvec;
        nineperma;
        RSIderv
        
        B;
        
        condition;
        
        ind;
        
        tradeLen;
        enterPrice;
        enterMarket;
        stopLoss;
        trades;
        
        slPercentFirst;
        slPercentSecond;
        
        tAnalyze = TurtleAnalyzer;
        
        rsi;
        vwap;
        
        clSma;
        clAma;
        clRma;
        
        currentTime;
        
        
    end
    
    methods
        
        function obj = TurtleAutoRealTime()
            
            obj.stopLoss.BULL = NaN;
            obj.tradeLen.BULL = 0;
            obj.enterPrice.BULL = NaN;
            obj.enterMarket.BULL = 0;
            obj.trades.BULL = [];
            obj.condition.Trying_to_Enter.BULL = 0;
            
            
            obj.stopLoss.BEAR = NaN;
            obj.tradeLen.BEAR = 0;
            obj.enterPrice.BEAR = NaN;
            obj.enterMarket.BEAR = 0;
            obj.trades.BEAR = [];
            obj.condition.Trying_to_Enter.BEAR = 0;
            
            
        end
        
        function checkConditions(obj)

            if obj.cl.STOCK(end) <= obj.stopLoss.BULL
                obj.condition.Not_Stopped_Out.BULL = 0;
            else
                obj.condition.Not_Stopped_Out.BULL = 1;
            end
            
            if obj.cl.STOCK(end) >= obj.stopLoss.BEAR
                obj.condition.Not_Stopped_Out.BEAR = 0;
            else
                obj.condition.Not_Stopped_Out.BEAR = 1;
            end
            
            
            if (obj.enterMarket.BULL == 1 || obj.enterMarket.BEAR) || ...
                    (((obj.vo.STOCK(end-1) > mean(obj.vo.STOCK(~isnan(obj.vo.STOCK(1:end-1)))) ||...
                    obj.vo.STOCK(end-2) > mean(obj.vo.STOCK(~isnan(obj.vo.STOCK(1:end-1))))))...
                    && ((obj.vo.INDX(end-1) > mean(obj.vo.INDX(~isnan(obj.vo.INDX(1:end-1)))) ||...
                    obj.vo.INDX(end-2) > mean(obj.vo.INDX(~isnan(obj.vo.INDX(1:end-1)))))))
                
                %ADDED INDX TRACKING TO VOLUME
                
                obj.condition.Large_Volume = 1;
            else
                obj.condition.Large_Volume = 0;
            end
            
           
            if obj.cl.STOCK(end-1) > obj.clSma(end-1) &&  obj.cl.INDX(end-1) > obj.clAma(end-1)
                obj.condition.Above_MA.BULL = 1;
            else
                obj.condition.Above_MA.BULL = 0;
            end
            
            if obj.cl.STOCK(end-1) < obj.clSma(end-1) && obj.cl.INDX(end-1) < obj.clAma(end-1)
                obj.condition.Below_MA.BEAR = 1;
            else
                obj.condition.Below_MA.BEAR = 0;
            end
            
            
            if obj.currentTime > 1556 %strcmp(datestr(obj.da.INDX(obj.ind),15), '16:00')
                obj.condition.Not_End_of_Day = 0;
            else
                obj.condition.Not_End_of_Day = 1;
            end
            
            %VERIFY THAT END OF DAY CONDITION IS WORKING 
            
            
            if obj.enterMarket.BULL || (obj.condition.Trying_to_Enter.BULL == 1 && obj.cl.STOCK(end) <= obj.clSma(end-1))
                obj.condition.Allowed_to_Enter.BULL = 1;
            else
                obj.condition.Allowed_to_Enter.BULL = 0;
            end
            
            if obj.enterMarket.BEAR || (obj.condition.Trying_to_Enter.BEAR == 1 && obj.cl.STOCK(end) >= obj.clSma(end-1))
                obj.condition.Allowed_to_Enter.BEAR = 1;
            else
                obj.condition.Allowed_to_Enter.BEAR = 0;
            end
            
            
        end
        
        function calculateData(obj, isFlip)
            
             [obj.clSma, obj.clAma, obj.clRma] = obj.tAnalyze.getMovingStandard(obj.cl.STOCK, obj.cl.INDX, 12, isFlip);
             %%%%%% TRY ENTER IN ON 26 AND EXIT ON 12
             
             obj.currentTime = datestr(now,15); obj.currentTime(3) = [];
  
        end
        
        function setStopLoss(obj)
            
            %NEEDS TO CHECK THE EXTREME OF THE ENTER CANDLE
            
            if obj.enterMarket.BULL == 1
                obj.tradeLen.BULL = length(obj.cl.STOCK) - obj.trades.BULL(end,3) + 1;
            end
            
            if obj.enterMarket.BEAR == 1
                obj.tradeLen.BEAR = length(obj.cl.STOCK) - obj.trades.BEAR(end,3) + 1;
            end
            
            
            if obj.tradeLen.BULL <= 1
                obj.stopLoss.BULL = obj.enterPrice.BULL*(1.00-obj.slPercentFirst/100);
            elseif obj.tradeLen.BULL == 2
                obj.stopLoss.BULL = obj.enterPrice.BULL*(1.00-obj.slPercentSecond/100);
            else
                
                if obj.lo.STOCK(end-2) > obj.stopLoss.BULL
                    obj.stopLoss.BULL = obj.lo.STOCK(end-2);
                end
            end
            
            if obj.tradeLen.BEAR <= 1
                obj.stopLoss.BEAR = obj.enterPrice.BEAR*(1.00+obj.slPercentFirst/100);
            elseif obj.tradeLen.BEAR == 2
                obj.stopLoss.BEAR = obj.enterPrice.BEAR*(1.00+obj.slPercentSecond/100);
            else
                if  obj.hi.STOCK(end-2) < obj.stopLoss.BEAR
                    obj.stopLoss.BEAR = obj.hi.STOCK(end-2);
                end
            end
            
        end
        
        function executeBullTrade(obj)
            
            if obj.condition.Not_Stopped_Out.BULL...
                    && obj.condition.Large_Volume...
                    && obj.condition.Not_End_of_Day...
                    && obj.condition.Above_MA.BULL...
                    %&& obj.condition.MACD_bull_cross...
                %&& obj.condition.MACD_bull_derv...
                %&& obj.condition.MACD_Positive.BULL...
                %obj.condition.RSI_to_indx.BULL...
                %&& obj.condition.RSI_to_stock.BULL...
                %&& obj.condition.vwap.BULL...
                
                obj.condition.Trying_to_Enter.BULL = 1;
                
                if obj.condition.Allowed_to_Enter.BULL == 1
                    
                    if obj.enterMarket.BULL == 0
                        obj.enterPrice.BULL = obj.cl.STOCK(end);
                        obj.trades.BULL = [obj.trades.BULL; obj.enterPrice.BULL, NaN, length(obj.cl.STOCK), NaN];
                    end
                    
                    obj.enterMarket.BULL = 1;
%                     obj.tradeLen.BULL = length(obj.cl.STOCK) - obj.trades.BULL(end,3) + 1;
                    
                end
                
            else
                
                obj.condition.Trying_to_Enter.BULL = 0;
                
                if obj.enterMarket.BULL == 1
                    
                    if obj.condition.Not_Stopped_Out.BULL
                        obj.trades.BULL(end,2) = obj.cl.STOCK(end);
                    else
                        if obj.op.STOCK(end) > obj.stopLoss.BULL
                            obj.trades.BULL(end,2) = obj.stopLoss.BULL;
                        else
                            obj.trades.BULL(end,2) = obj.op.STOCK(end);
                        end
                    end
                    
                    obj.trades.BULL(end,4) = length(obj.cl.STOCK);
                    
                    %obj.ind = obj.ind-1;
                    %%% ^^ DOES THIS ADD FUTUE KNOWLEDGE? ^^
                end
                
                obj.enterMarket.BULL = 0;
                obj.enterPrice.BULL = NaN;
                obj.tradeLen.BULL = 0;
                obj.stopLoss.BULL = NaN;
                
            end
            
        end
        
        function executeBearTrade(obj)
            
            if obj.condition.Not_Stopped_Out.BEAR...
                    && obj.condition.Large_Volume...
                    && obj.condition.Not_End_of_Day...
                    && obj.condition.Below_MA.BEAR...
                    %&& obj.condition.MACD_bear_cross...
                %&& obj.condition.MACD_bear_derv...
                %&& obj.condition.MACD_Negative.BEAR
                %&& obj.condition.RSI_to_indx.BEAR...
                %&& obj.condition.RSI_to_stock.BEAR...
                %&& obj.condition.vwap.BEAR...
                
                obj.condition.Trying_to_Enter.BEAR = 1;
                
                if obj.condition.Allowed_to_Enter.BEAR == 1
                    
                    
                    if obj.enterMarket.BEAR == 0
                        obj.enterPrice.BEAR = obj.cl.STOCK(end);
                        obj.trades.BEAR = [obj.trades.BEAR; obj.enterPrice.BEAR, NaN, length(obj.cl.STOCK), NaN];
                    end
                    
                    obj.enterMarket.BEAR = 1;
%                     obj.tradeLen.BEAR = length(obj.cl.STOCK) - obj.trades.BEAR(end,3) + 1;
                    
                end
                
            else
                
                obj.condition.Trying_to_Enter.BEAR = 0;
                
                if obj.enterMarket.BEAR == 1
                    
                    if obj.condition.Not_Stopped_Out.BEAR
                        obj.trades.BEAR(end,2) = obj.cl.STOCK(end);
                    else
                        if obj.op.STOCK(end) < obj.stopLoss.BEAR
                            obj.trades.BEAR(end,2) = obj.stopLoss.BEAR;
                        else
                            obj.trades.BEAR(end,2) = obj.op.STOCK(end);
                        end
                    end
                    
                    obj.trades.BEAR(end,4) = length(obj.cl.STOCK);
                    
                    %                     obj.ind = obj.ind-1;
                end
                
                obj.enterMarket.BEAR = 0;
                obj.enterPrice.BEAR = NaN;
                obj.tradeLen.BEAR = 0;
                obj.stopLoss.BEAR = NaN;
                
            end
            
        end
        
    end
    
end
