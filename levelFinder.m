clear; close all; clc;

stock = 'AXL'

minutely = IntraDayStockData(stock,'NYSE','60','1d');
c = yahoo;
m = fetch(c,stock,now, now-500, 'm');
d = fetch(c,stock,now, now-500, 'd');
close(c)
 

for begin = 2:1:100
    
    set(gcf, 'Position', [9,5,1423,800])
    hi = d(:,3); lo = d(:,4); cl = d(:,5); op = d(:,2); da = d(:,1);
    highlow(hi, lo, op, cl, 'black', da);
    % axis([da(100), da(1)+5,...
    %     min(lo(1:100))*0.95, max(hi(1:100))*1.05])
    title(strcat(stock,' Daily'))
    datetick('x',12, 'keeplimits');
    hold on
    
    
    founder = [];
    
    for i = 10:50
        
        res = max(hi(begin:begin+i));
        sup = min(lo(begin:begin+i));
        
        founder = [founder; begin + i, (res-sup)/sup];
        
    end
    
    
    uniqueNY = unique(founder(:,2));
    foundX = [];
    for i = 1:length(uniqueNY)
        
        specific = find(uniqueNY(i) == founder(:,2));
        
        foundX = [foundX; uniqueNY(i), max(founder(specific,1))];
        
      end
    
  
    
    for i = 1: size(foundX,1)
        
        indxStart   = begin;
        indxEnd     = foundX(i,2);
        
        foundDates  = da(indxStart:indxEnd);
        foundRes    = max(hi(indxStart:indxEnd));
        foundSup    = min(lo(indxStart:indxEnd));
        
        plot(foundDates, ones(length(foundDates),1)*foundRes, 'b')
        plot(foundDates, ones(length(foundDates),1)*foundSup, 'b')
        
%         if hi(begin-1)- 
        plot(da(begin-1), hi(begin-1), 'mo')
        
        
    end
    
    pause
    close all
    
end


return








foundMeSalson = [];
for j = 50:1000
    
    founder = [];
    x = j;
    for i = 1 : (length(hi) - x)
        
        res = max(hi(i:x+i));
        sup = min(lo(i:x+i));
        
        founder = [founder; i, x, (res-sup)/sup];
        
    end
    founder = sortrows(founder, 3);
    foundMeSalson = [foundMeSalson; founder(1,:)];
    j
end




for i = 1:length(foundX)
    
    indxStart   = foundX(i,1)
    indxEnd     = foundX(i,1) + foundX(i,2)
    
    foundDates  = da(indxStart:indxEnd);
    foundRes    = max(hi(indxStart:indxEnd));
    foundSup    = min(lo(indxStart:indxEnd));
    
    plot(foundDates, ones(length(foundDates),1)*foundRes, 'r')
    plot(foundDates, ones(length(foundDates),1)*foundSup, 'r')
    pause
end

% numFound = [];
% for i = 1:length(hi)
%     numFound = [numFound; i, length(find(hi(i) == hi))];
% end
%
%
%
% numFound = sortrows(numFound,-2)
%
% i = numFound(22,1);
% dots = find(hi(i) == hi);
%
% plot(da(dots), hi(dots), 'ro')