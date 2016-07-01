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
        
        slPercentFirst = 0.75; slPercentSecond = 0.25;
        
        tAnalyze = TurtleAnalyzer;
        
        rsi;
        vwap;
        
        clSma; clAma; clRma;
        clSmaLarge; clAmaLarge; clRmaLarge;
        
        stock;
        enteredStock;
        
        voAvg;
        
        
    end
    
    methods
        
        function obj = TurtleAuto()
            
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
        
        function organizeDataIB(obj, ib_stock, ib_indx)
        
            td = TurtleData;
            [daIB, opIB, hiIB, loIB, clIB, voIB] = td.organizeDataIB(ib_stock);
            obj.hi.STOCK = hiIB;
            obj.lo.STOCK = loIB;
            obj.op.STOCK = opIB;
            obj.cl.STOCK = clIB;
            obj.vo.STOCK = voIB;
            obj.da.STOCK = daIB;
            
            [daIB, opIB, hiIB, loIB, clIB, voIB] = td.organizeDataIB(ib_indx);
            obj.hi.INDX = hiIB;
            obj.lo.INDX = loIB;
            obj.op.INDX = opIB;
            obj.cl.INDX = clIB;
            obj.vo.INDX = voIB;
            obj.da.INDX = daIB;

        end 
        
        function organizeDataGoog(obj, goog_stock, goog_indx, range)
            
            obj.hi.STOCK = goog_stock.high(range);
            obj.lo.STOCK = goog_stock.low(range);
            obj.op.STOCK = goog_stock.open(range);
            obj.cl.STOCK = goog_stock.close(range);
            obj.vo.STOCK = goog_stock.volume(range);
            obj.da.STOCK = goog_stock.date(range);
            
            obj.hi.INDX = goog_indx.high(range);
            obj.lo.INDX = goog_indx.low(range);
            obj.op.INDX = goog_indx.open(range);
            obj.cl.INDX = goog_indx.close(range);
            obj.vo.INDX = goog_indx.volume(range);
            obj.da.INDX = goog_indx.date(range);
            
        end
        
        function setStock(obj, stock)
            
            obj.stock = stock;
            
        end
        
        function checkConditionsUsingInd(obj)
            
            if  obj.nineperma.STOCK(obj.ind) < obj.macdvec.STOCK(obj.ind) && obj.nineperma.INDX(obj.ind) < obj.macdvec.INDX(obj.ind)
                obj.condition.MACD_bull_cross = 1;
            else
                obj.condition.MACD_bull_cross = 0;
            end
            
            if  obj.nineperma.STOCK(obj.ind) > obj.macdvec.STOCK(obj.ind) && obj.nineperma.INDX(obj.ind) > obj.macdvec.INDX(obj.ind)
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
                    ((obj.vo.STOCK(obj.ind) > obj.voAvg.STOCK ||...
                    obj.vo.STOCK(obj.ind-1) > obj.voAvg.STOCK)...
                    && (obj.vo.INDX(obj.ind) > obj.voAvg.INDX ||...
                    obj.vo.INDX(obj.ind-1) > obj.voAvg.INDX))...
                    
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
            
            
            if obj.cl.STOCK(obj.ind) > obj.clSma(obj.ind) && obj.cl.INDX(obj.ind) > obj.clAma(obj.ind)
                obj.condition.Above_MA.BULL = 1;
            else
                obj.condition.Above_MA.BULL = 0;
            end
            
            if obj.cl.STOCK(obj.ind) < obj.clSma(obj.ind) && obj.cl.INDX(obj.ind) < obj.clAma(obj.ind)
                obj.condition.Below_MA.BEAR = 1;
            else
                obj.condition.Below_MA.BEAR = 0;
            end
            
            
            if strcmp(datestr(obj.da.INDX(obj.ind),15), '15:50')
                obj.condition.Not_End_of_Day = 0;
            else
                obj.condition.Not_End_of_Day = 1;
            end
            
            
            if obj.enterMarket.BULL || (obj.condition.Trying_to_Enter.BULL == 1 && obj.lo.STOCK(obj.ind) <= obj.clSma(obj.ind-1))
                obj.condition.Allowed_to_Enter.BULL = 1;
            else
                obj.condition.Allowed_to_Enter.BULL = 1;
            end
            
            if obj.enterMarket.BEAR || (obj.condition.Trying_to_Enter.BEAR == 1 && obj.hi.STOCK(obj.ind) >= obj.clSma(obj.ind-1))
                obj.condition.Allowed_to_Enter.BEAR = 1;
            else
                obj.condition.Allowed_to_Enter.BEAR = 1;
            end
            
            
        end
        
        function calculateData(obj, isFlip)
            
            [obj.macdvec.STOCK, obj.nineperma.STOCK] = macd(obj.cl.STOCK);
            [obj.macdvec.INDX, obj.nineperma.INDX] = macd(obj.cl.INDX);
            
            [obj.clSma, obj.clAma, obj.clRma] = obj.tAnalyze.getMovingStandard(obj.cl.STOCK, obj.cl.INDX, 12, isFlip);
            
            %%%%%% TRY ENTER IN ON 26 AND EXIT ON 12
            
            obj.RSIderv = [NaN; diff(obj.clRma)];
            
            obj.B.STOCK = [NaN; diff(obj.macdvec.STOCK)];
            obj.B.INDX  = [NaN; diff(obj.macdvec.INDX)];
            
            obj.rsi.STOCK = rsindex(obj.cl.STOCK);
            
            obj.vwap = getVWAP(obj.cl.STOCK, obj.vo.STOCK, obj.da.STOCK);
            
            obj.voAvg.STOCK = mean(obj.vo.STOCK(~isnan(obj.vo.STOCK(1:end))));  
            obj.voAvg.INDX = mean(obj.vo.INDX(~isnan(obj.vo.INDX(1:end)))); 
            
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
                    && obj.condition.MACD_bull_cross...
                    && obj.condition.Above_MA.BULL...
                    %&& obj.condition.MACD_bull_derv...
                  
                %&& obj.condition.MACD_Positive.BULL...
                %obj.condition.RSI_to_indx.BULL...
                %&& obj.condition.RSI_to_stock.BULL...
                %&& obj.condition.vwap.BULL...
                
                obj.condition.Trying_to_Enter.BULL = 1;
                
                if obj.condition.Allowed_to_Enter.BULL == 1
                    
                    if obj.enterMarket.BULL == 0
                        obj.enterPrice.BULL = obj.cl.STOCK(end); %obj.clSma(obj.ind-1)
                        obj.trades.BULL = [obj.trades.BULL; obj.enterPrice.BULL, NaN, length(obj.cl.STOCK), NaN];
%                         obj.ind = obj.ind-1;
%                         obj.savedStops = [obj.savedStops; obj.ind, obj.enterPrice.BULL*(1.00-obj.slPercent/100)];
                    end
                    
                    obj.enterMarket.BULL = 1;
                    obj.enteredStock = obj.stock;
                    %obj.tradeLen.BULL = obj.tradeLen.BULL + 1;
%                     obj.tradeLen.BULL = length(obj.cl.STOCK) - obj.trades.BULL(end,3) + 1;
                    %%% CHANGED TRADELEN TRACKING
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
                
                 if ~obj.enterMarket.BEAR && ~obj.enterMarket.BULL
                    obj.enteredStock = [];
                end 
                
            end
            
        end
        
        function executeBearTrade(obj)
            
            if obj.condition.Not_Stopped_Out.BEAR...
                    && obj.condition.Large_Volume...
                    && obj.condition.Not_End_of_Day...
                    && obj.condition.MACD_bear_cross...
                    && obj.condition.Below_MA.BEAR...
                    %&& obj.condition.MACD_bear_derv...
                  
                    %&& obj.condition.MACD_Negative.BEAR
                %&& obj.condition.RSI_to_indx.BEAR...
                %&& obj.condition.RSI_to_stock.BEAR...
                %&& obj.condition.vwap.BEAR...
                
                obj.condition.Trying_to_Enter.BEAR = 1;
                
                if obj.condition.Allowed_to_Enter.BEAR == 1
                    
                    
                    if obj.enterMarket.BEAR == 0
                        obj.enterPrice.BEAR =  obj.cl.STOCK(end); %obj.clSma(obj.ind-1);
                        obj.trades.BEAR = [obj.trades.BEAR; obj.enterPrice.BEAR, NaN, length(obj.cl.STOCK), NaN];
%                         obj.ind = obj.ind-1;
                    end
                    
                    obj.enterMarket.BEAR = 1;
                    obj.enteredStock = obj.stock;
                    %obj.tradeLen.BEAR = obj.tradeLen.BEAR + 1;
%                    obj.tradeLen.BEAR = length(obj.cl.STOCK) - obj.trades.BEAR(end,3) + 1;
                    
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
                
                if ~obj.enterMarket.BEAR && ~obj.enterMarket.BULL
                    obj.enteredStock = [];
                end 
                
            end
            
        end
        
    end
    
end
