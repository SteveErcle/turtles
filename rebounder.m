clc; close all; clear all;




td = TurtleData;
ta = TurtleAnalyzer;

allData = td.pullData(11, '5d', '600');


% STANDARDIZE IN REAL TIME

field = fieldnames(allData);

allData.STOCK = allData.(field{2});


allData.STOCK.stand = (allData.STOCK.close - mean(allData.STOCK.close)) ./ std(allData.STOCK.close);
allData.SPY.stand = (allData.SPY.close - mean(allData.SPY.close)) ./ std(allData.SPY.close);



window_size = 12;

ma.STOCK = tsmovavg(allData.STOCK.stand,'e',window_size,1);
ma.SPY = tsmovavg(allData.SPY.stand,'e',window_size,1);

rebound = allData.STOCK.stand - allData.SPY.stand;
ma.REBD = tsmovavg(rebound,'e',9,1);

% rebound = ma.STOCK-ma.SPY;
% ma.REBD = tsmovavg(rebound(~isnan(rebound)),'e',9,1);
% 
% numNan = length(rebound) - length(ma.REBD);
% ma.REBD = [nan(numNan,1);  ma.REBD];

upper =[];
lower = [];

for i = 1:length(rebound)
    
    if rebound(i) > ma.REBD(i) 
        upper = [upper; i];
    else
        lower  = [lower; i];
    end
    
end

B = [nan; diff(upper)];
setterUpper = [];
x = B;
z = find(x~= 1);
setterUpper = [];
for i = 1:length(z)-1
    setterUpper = [setterUpper; upper(z(i)), upper(z(i+1)-1)];
end 


B = [nan; diff(lower)];
setterLower = [];
x = B;
z = find(x~= 1);
setterLower = [];
for i = 1:length(z)-1
    setterLower = [setterLower; lower(z(i)), lower(z(i+1)-1)];
end 


figure
% plot(ma.STOCK, 'b')
% plot(ma.SPY, 'r')
% plot(ma.REBD, 'k')
subplot(2,1,1)
hold 
candle(allData.STOCK.high, allData.STOCK.low, allData.STOCK.close, allData.STOCK.open, 'blue');
% plot(allData.STOCK.stand,'b')
% plot(allData.SPY.stand,'r')
subplot(2,1,2)
hold on
plot(rebound, 'c')
plot(ma.REBD, 'k')


for k = 1:2
    subplot(2,1,k)
    
    for i = 1:size(setterUpper,1)
        
        xLo = setterUpper(i,1);
        xHi = setterUpper(i,2);
        ylimits = ylim;
        yLo = allData.STOCK.close(xLo);
        yHi = allData.STOCK.close(xHi);
        
        xShort = [xLo xHi xHi xLo];
        yShort = [yLo yLo yHi yHi];
        
        hp = patch(xShort,yShort, 'c', 'FaceAlpha', 0.05);
        
    end
    
    for i = 1:size(setterLower,1)
        
        xLo = setterLower(i,1);
        xHi = setterLower(i,2);
        ylimits = ylim;
        yLo = allData.STOCK.close(xLo);
        yHi = allData.STOCK.close(xHi);
        
        xShort = [xLo xHi xHi xLo];
        yShort = [yLo yLo yHi yHi];
        
        hp = patch(xShort,yShort, 'm', 'FaceAlpha', 0.05);
        
    end
    
end

roi.BULL = [];

for i = 1:size(setterUpper,1)
    
    
    first = allData.STOCK.close(setterUpper(i,1));
    second = allData.STOCK.close(setterUpper(i,2));
    
    if first == nan || second == nan
        i
    end 
    
    roi.BULL = [roi.BULL; ta.percentDifference(first, second)];
    
end 

roi.BEAR = [];
for i = 1:size(setterLower,1)
    
    
    first = allData.STOCK.close(setterLower(i,1));
    second = allData.STOCK.close(setterLower(i,2));
    
     if first == nan || second == nan
        i
    end 
    
    
    roi.BEAR = [roi.BEAR; -ta.percentDifference(first, second)];
    
end 
    

disp([sum(roi.BULL), sum(roi.BEAR)])
    
    


            
            
            
            
            