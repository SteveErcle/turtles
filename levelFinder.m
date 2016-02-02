clear; close all; clc;

stock = 'AXL'
exchange = 'NYSE';


c = yahoo;
m = fetch(c,stock,now, now-500, 'm');
d = fetch(c,stock,now, now-500, 'd');
d = getTodaysOHLC(stock, exchange, d);
close(c)


datestr(d(1))
tf = TurtleFun;


tf.plotHiLo(d);
set(gcf, 'Position', [9,5,1423,800])
title(strcat(stock,' Daily'))

[hi, lo, cl, op, da] = tf.returnOHLCDarray(d);
foundLevels = tf.getContainerLevels(50, hi, lo, da);


tf.plotContainer(foundLevels)




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