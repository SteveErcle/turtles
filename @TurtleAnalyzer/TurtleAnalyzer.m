classdef TurtleAnalyzer < handle
    
    properties
        
        tf = TurtleFun;
        
    end
    
    methods
        
        function beta = calcBeta(obj, dAll ,dAvg)
            
            cl = dAll(:,7);
            clD = dAvg(:,7);
            
            perCl = [];
            perClD = [];
            
            for i = 1:size(cl)-1
                perCl = [perCl; (cl(i) - cl(i+1)) / cl(i+1)*100];
                perClD = [perClD; (clD(i) - clD(i+1)) / clD(i+1)*100];
            end
            
            beta = cov(perCl, perClD) / var(perClD);
            beta = beta(1,2);
            
        end
        
        function [ScbS, SioS, SroS] = getMovingAvgs(obj, stockData, avgData, window_size, beta)
            
            Idx = avgData(:,2:5);
            Scb = stockData(:,2:5);
            
            per = [];
            
            for i = size(Idx,1) - 1 : -1 : 1
                per = [per; beta * ((Idx(i,:) - Idx(i+1,:)) ./ Idx(i+1,:))];
            end
            per = flipud(per);
            
            Sio = zeros(size(Scb));
            Sio(end,:) = Scb(end,:);
            
            for i = size(Idx,1) - 1 : -1 : 1
                Sio(i,:) = Sio(i+1,:).*(per(i,:)+1);
            end
            
            Sro = Scb(end) + (Scb - Sio);
            
            ScbS = flipud(tsmovavg(flipud(Scb(:,4)),'e',window_size,1));
            SioS = flipud(tsmovavg(flipud(Sio(:,4)),'e',window_size,1));
            SroS = flipud(tsmovavg(flipud(Sro(:,4)),'e',window_size,1));
            
            
        end
        
        function [RSI, RSIma] = getRSI(obj, stockData, avgData, window_size)
        
            cl = stockData(:,5);
            clD = avgData(:,5);
            
            RSI = (cl./clD)*100;
            RSI = (RSI - mean(RSI)) ./ std(RSI);
            RSIma = flipud(tsmovavg(flipud(RSI),'e',window_size,1));
          
        end
        
        function [stockStandardCl, avgStandardCl, rawStandardCl] = getStandardized(obj, stockData, avgData, window_size)
            
            stockStandardCl = (stockData(:,5) - mean(stockData(:,5))) ./ std(stockData(:,5));
            avgStandardCl = (avgData(:,5) - mean(avgData(:,5))) ./ std(avgData(:,5));
            
            rawStandardCl = stockStandardCl(end) + (stockStandardCl - avgStandardCl);
            
            stockStandardCl = flipud(tsmovavg(flipud(stockStandardCl),'e',window_size,1));
            avgStandardCl = flipud(tsmovavg(flipud(avgStandardCl),'e',window_size,1));
            rawStandardCl = flipud(tsmovavg(flipud(rawStandardCl),'e',window_size,1));
            
        end
   
        function [dateOnPlot] = getDate(obj)
            
            h = gcf;
            axesObjs = get(h, 'Children');
            axesObjs = findobj(axesObjs, 'type', 'axes');
            dataTips = findall(axesObjs, 'Type', 'hggroup', 'HandleVisibility', 'off');
            
            if length(dataTips) > 0
                cursor = datacursormode(gcf);
                dateOnPlot = cursor.CurrentDataCursor.getCursorInfo.Position(1)
                value = cursor.CurrentDataCursor.getCursorInfo.Position(2)
                
                delete(dataTips);
            end
            
        end
        
    end
end
