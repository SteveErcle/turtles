classdef TurtleAuto < handle
    
    
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
        
        slPercent;
        
        tAnalyze = TurtleAnalyzer;
        
        rsi;
        vwap;
        
        clSma
        clAma
        clRma

        
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
            
            if  obj.nineperma.INDX(end) < obj.macdvec.INDX(end) %&& obj.nineperma.STOCK(end) < obj.macdvec.STOCK(end)
                obj.condition.MACD_bull_cross = 1;
            else
                obj.condition.MACD_bull_cross = 0;
            end
            
            if  obj.nineperma.INDX(end) > obj.macdvec.INDX(end) %&& obj.nineperma.STOCK(end) < obj.macdvec.STOCK(end)
                obj.condition.MACD_bear_cross = 1;
            else
                obj.condition.MACD_bear_cross = 0;
            end
            
            
            if obj.enterMarket.BULL == 1 || sign(obj.macdvec.STOCK(end)) == sign(obj.macdvec.INDX(end))
                obj.condition.MACD_Positive.BULL = 1;
            else
                obj.condition.MACD_Positive.BULL = 0;
            end 
            
            if obj.enterMarket.BEAR == 1 || sign(obj.macdvec.STOCK(end)) == sign(obj.macdvec.INDX(end))
                obj.condition.MACD_Negative.BEAR = 1;
            else
                obj.condition.MACD_Negative.BEAR = 0;
            end 
            
            
            if obj.RSIderv(end) > 0
                obj.condition.RSI_to_indx.BULL = 1;
            else
                obj.condition.RSI_to_indx.BULL = 0;
            end
            
            if obj.RSIderv(end) < 0
                obj.condition.RSI_to_indx.BEAR = 1;
            else
                obj.condition.RSI_to_indx.BEAR = 0;
            end
            
            
            if obj.enterMarket.BULL == 1 || obj.rsi.STOCK(end) <= 50
                obj.condition.RSI_to_stock.BULL = 1;
            else
                obj.condition.RSI_to_stock.BULL = 0;
            end
            
            if obj.enterMarket.BEAR == 1 || obj.rsi.STOCK(end) >= 50
                obj.condition.RSI_to_stock.BEAR = 1;
            else
                obj.condition.RSI_to_stock.BEAR = 0;
            end
            
            
            if obj.B.STOCK(end) >= 0.005 %&& obj.B.INDX(end) >= 0.0
                obj.condition.MACD_bull_derv = 1;
            else
                obj.condition.MACD_bull_derv = 0;
            end
            
            if obj.B.STOCK(end) <= -0.005 %&& obj.B.INDX(end) <= 0.0
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
            
            
            if (obj.enterMarket.BULL == 1 || obj.enterMarket.BEAR) || ...
                    (((obj.vo.STOCK(end) > mean(obj.vo.STOCK(~isnan(obj.vo.STOCK))) ||...
                    obj.vo.STOCK(end-1) > mean(obj.vo.STOCK(~isnan(obj.vo.STOCK)))))...
                    && ((obj.vo.INDX(end) > mean(obj.vo.INDX(~isnan(obj.vo.INDX))) ||...
                    obj.vo.INDX(end-1) > mean(obj.vo.INDX(~isnan(obj.vo.INDX))))))
                
                %ADDED INDX TRACKING TO VOLUME
                
                obj.condition.Large_Volume = 1;
            else
                obj.condition.Large_Volume = 0;
            end
            
            
            if obj.enterMarket.BULL == 1 || obj.cl.STOCK(end) < obj.vwap(end)
                obj.condition.vwap.BULL = 1;
            else
                obj.condition.vwap.BULL = 0;
            end 
            
             if obj.enterMarket.BEAR == 1 || obj.cl.STOCK(end) > obj.vwap(end)
                obj.condition.vwap.BEAR = 1;
            else
                obj.condition.vwap.BEAR = 0;
            end
            
            
        end
        
        function checkConditionsUsingInd(obj)
            
            if  obj.nineperma.STOCK(obj.ind) < obj.macdvec.STOCK(obj.ind) %&& obj.nineperma.INDX(obj.ind) < obj.macdvec.INDX(obj.ind)
                obj.condition.MACD_bull_cross = 1;
            else
                obj.condition.MACD_bull_cross = 0;
            end
            
            if  obj.nineperma.STOCK(obj.ind) > obj.macdvec.STOCK(obj.ind) %&& obj.nineperma.INDX(obj.ind) > obj.macdvec.INDX(obj.ind) 
                obj.condition.MACD_bear_cross = 1;
            else
                obj.condition.MACD_bear_cross = 0;
            end
            
            
            if obj.enterMarket.BULL == 1 || sign(obj.macdvec.STOCK(obj.ind)) == sign(obj.macdvec.INDX(obj.ind))
                obj.condition.MACD_Positive.BULL = 1;
            else
                obj.condition.MACD_Positive.BULL = 0;
            end 
            
            if obj.enterMarket.BEAR == 1 || sign(obj.macdvec.STOCK(obj.ind)) == sign(obj.macdvec.INDX(obj.ind))
                obj.condition.MACD_Negative.BEAR = 1;
            else
                obj.condition.MACD_Negative.BEAR = 0;
            end 
            
            
            if obj.RSIderv(obj.ind) > 0
                obj.condition.RSI_to_indx.BULL = 1;
            else
                obj.condition.RSI_to_indx.BULL = 0;
            end
            
            if obj.RSIderv(obj.ind) < 0
                obj.condition.RSI_to_indx.BEAR = 1;
            else
                obj.condition.RSI_to_indx.BEAR = 0;
            end
            
            
            if obj.enterMarket.BULL == 1 || obj.rsi.STOCK(obj.ind) <= 50
                obj.condition.RSI_to_stock.BULL = 1;
            else
                obj.condition.RSI_to_stock.BULL = 0;
            end
            
            if obj.enterMarket.BEAR == 1 || obj.rsi.STOCK(obj.ind) >= 50
                obj.condition.RSI_to_stock.BEAR = 1;
            else
                obj.condition.RSI_to_stock.BEAR = 0;
            end
            
            
            if obj.B.STOCK(obj.ind) >= 0.000 && obj.B.INDX(obj.ind) >= 0.005
                obj.condition.MACD_bull_derv = 1;
            else
                obj.condition.MACD_bull_derv = 0;
            end
            
            if obj.B.STOCK(obj.ind) <= -0.000 && obj.B.INDX(obj.ind) <= -0.005
                obj.condition.MACD_bear_derv = 1;
            else
                obj.condition.MACD_bear_derv = 0;
            end
            
            
            if obj.lo.STOCK(obj.ind) <= obj.stopLoss.BULL
                obj.condition.Not_Stopped_Out.BULL = 0;
            else
                obj.condition.Not_Stopped_Out.BULL = 1;
            end
            
            if obj.hi.STOCK(obj.ind) >= obj.stopLoss.BEAR
                obj.condition.Not_Stopped_Out.BEAR = 0;
            else
                obj.condition.Not_Stopped_Out.BEAR = 1;
            end
            
            
            if (obj.enterMarket.BULL == 1 || obj.enterMarket.BEAR) || ...
                    (((obj.vo.STOCK(obj.ind) > mean(obj.vo.STOCK(~isnan(obj.vo.STOCK))) ||...
                    obj.vo.STOCK(obj.ind-1) > mean(obj.vo.STOCK(~isnan(obj.vo.STOCK)))))...
                    && ((obj.vo.INDX(obj.ind) > mean(obj.vo.INDX(~isnan(obj.vo.INDX))) ||...
                    obj.vo.INDX(obj.ind-1) > mean(obj.vo.INDX(~isnan(obj.vo.INDX))))))
                
                %ADDED INDX TRACKING TO VOLUME
                
                obj.condition.Large_Volume = 1;
            else
                obj.condition.Large_Volume = 0;
            end
            
            
            if obj.enterMarket.BULL == 1 || obj.cl.STOCK(obj.ind) < obj.vwap(end)
                obj.condition.vwap.BULL = 1;
            else
                obj.condition.vwap.BULL = 0;
            end 
            
             if obj.enterMarket.BEAR == 1 || obj.cl.STOCK(obj.ind) > obj.vwap(end)
                obj.condition.vwap.BEAR = 1;
            else
                obj.condition.vwap.BEAR = 0;
            end
            
            
        end
       
        function calculateData(obj, isFlip)
            
            [obj.macdvec.STOCK, obj.nineperma.STOCK] = macd(obj.cl.STOCK);
            [obj.macdvec.INDX, obj.nineperma.INDX] = macd(obj.cl.INDX);
            
            [obj.clSma, obj.clAma, obj.clRma] = obj.tAnalyze.getMovingStandard(obj.cl.STOCK, obj.cl.INDX, 12, isFlip);
            obj.RSIderv = [NaN; diff(obj.clRma)];
            
            obj.B.STOCK = [NaN; diff(obj.macdvec.STOCK)];
            obj.B.INDX  = [NaN; diff(obj.macdvec.INDX)];
            
            obj.rsi.STOCK = rsindex(obj.cl.STOCK);
                
            obj.vwap = getVWAP(obj.cl.STOCK, obj.vo.STOCK, obj.da.STOCK);
     
        end
        
        function setStopLoss(obj)
            
             if obj.tradeLen.BULL <= 2
                obj.stopLoss.BULL = obj.enterPrice.BULL*(1.00-obj.slPercent/100);
            else
                if obj.lo.STOCK(end-2) > obj.stopLoss.BULL
                    obj.stopLoss.BULL = obj.lo.STOCK(end-2);
                end
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
            
            if obj.condition.MACD_bull_cross...
                && obj.condition.MACD_bull_derv...
                && obj.condition.Not_Stopped_Out.BULL...
                && obj.condition.Large_Volume
                    %obj.condition.RSI_to_indx.BULL... 
                    %&& obj.condition.RSI_to_stock.BULL...
                    %&& obj.condition.vwap.BULL...
                    %&& obj.condition.MACD_Positive.BULL...
                    
                
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
                        if obj.op.STOCK(end) > obj.stopLoss.BULL
                            obj.trades.BULL(end,2) = obj.stopLoss.BULL;
                        else
                            obj.trades.BULL(end,2) = obj.op.STOCK(end);
                        end 
                    end
                    
                    obj.trades.BULL(end,4) = length(obj.cl.STOCK);
                    
%                     obj.ind = obj.ind-1;
                end
                
                obj.enterMarket.BULL = 0;
                obj.enterPrice.BULL = NaN;
                obj.tradeLen.BULL = 0;
                obj.stopLoss.BULL = NaN;
                
            end
            
        end
        
        function executeBearTrade(obj)
            
            if obj.condition.MACD_bear_cross...
                    && obj.condition.MACD_bear_derv...
                    && obj.condition.Not_Stopped_Out.BEAR...
                    && obj.condition.Large_Volume
            
                    %&& obj.condition.RSI_to_indx.BEAR...
                   
                    %&& obj.condition.RSI_to_stock.BEAR...
                    %&& obj.condition.vwap.BEAR...
                    %&& obj.condition.MACD_Negative.BEAR...
                   
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
