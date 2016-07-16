clc; close all; clear all;




td = TurtleData;
ta = TurtleAnalyzer;

allData = td.pullData(21, '50d', '600');


% STANDARDIZE IN REAL TIME

allData.ENDP.stand = (allData.ENDP.close - mean(allData.ENDP.close)) ./ std(allData.ENDP.close);
allData.SPY.stand = (allData.SPY.close - mean(allData.SPY.close)) ./ std(allData.SPY.close);

rebound = allData.ENDP.stand - allData.SPY.stand;

window_size = 12;

ma.ENDP = tsmovavg(allData.ENDP.stand,'e',window_size,1);
ma.SPY = tsmovavg(allData.SPY.stand,'e',window_size,1);
ma.REBD = tsmovavg(rebound,'e',9,1);

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
enter = 0;
setterUpper = [];

x = B;
z = find(x~= 1);

setterUpper = [];
for i = 1:length(z)-1
    setterUpper = [setterUpper; upper(z(i)), upper(z(i+1)-1)];
end 

% for i = 2:length(upper)-1
%     
%     if B(i) ~= 1
%         setterUpper = [setterUpper; upper(i), nan];
%         enter = 1;
%     end
%     
%     if B(i+1) ~= 1 && enter == 1
%         setterUpper(end,2) = upper(i);
%         enter = 0;
%     end
%     
% end


B = [nan; diff(lower)];
enter = 0;
setterLower = [];

x = B;
z = find(x~= 1);

setterLower = [];
for i = 1:length(z)-1
    setterLower = [setterLower; lower(z(i)), lower(z(i+1)-1)];
end 
% for i = 2:length(lower)-1
%     
%     if B(i) ~= 1
%         setterLower = [setterLower; lower(i), nan];
%         enter = 1;
%     end
%     
%     if B(i+1) ~= 1 && enter == 1
%         setterLower(end,2) = lower(i);
%         enter = 0;
%     end
%     
% end


figure
% plot(ma.ENDP, 'b')
% plot(ma.SPY, 'r')
% plot(ma.REBD, 'k')
subplot(2,1,1)
hold on
plot(allData.ENDP.stand,'b')
plot(allData.SPY.stand,'r')
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
        yLo = ylimits(1);
        yHi = ylimits(2);
        
        xShort = [xLo xHi xHi xLo];
        yShort = [yLo yLo yHi yHi];
        
        hp = patch(xShort,yShort, 'c', 'FaceAlpha', 0.05);
        
    end
    
    for i = 1:size(setterLower,1)
        
        xLo = setterLower(i,1);
        xHi = setterLower(i,2);
        ylimits = ylim;
        yLo = ylimits(1);
        yHi = ylimits(2);
        
        xShort = [xLo xHi xHi xLo];
        yShort = [yLo yLo yHi yHi];
        
        hp = patch(xShort,yShort, 'm', 'FaceAlpha', 0.05);
        
    end
    
end

roi.BULL = [];

for i = 1:size(setterUpper,1)
    
    
    first = allData.ENDP.close(setterUpper(i,1));
    second = allData.ENDP.close(setterUpper(i,2));
    
    if first == nan || second == nan
        i
    end 
    
    roi.BULL = [roi.BULL; ta.percentDifference(first, second)];
    
end 

roi.BEAR = [];
for i = 1:size(setterLower,1)
    
    
    first = allData.ENDP.close(setterLower(i,1));
    second = allData.ENDP.close(setterLower(i,2));
    
     if first == nan || second == nan
        i
    end 
    
    
    roi.BEAR = [roi.BEAR; -ta.percentDifference(first, second)];
    
end 
    
    
    


            
            
            
            
            