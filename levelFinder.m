clear; close all; clc;

stock = 'PSEC'

minutely = IntraDayStockData(stock,'NYSE','60','1d');
c = yahoo;
m = fetch(c,stock,now, now-17000, 'm');
d = fetch(c,stock,now, now-17000, 'd');
close(c)



hi = d(:,3); lo = d(:,4); cl = d(:,5); op = d(:,2); da = d(:,1);
highlow(hi, lo, op, cl, 'black', da);
% axis([da(100), da(1)+5,...
%     min(lo(1:100))*0.95, max(hi(1:100))*1.05])
title(strcat(stock,' Daily'))
datetick('x',12, 'keeplimits');
hold on

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

uniqueNY = unique(foundMeSalson(:,1));
foundX = [];
for i = 1:length(uniqueNY)

specific = find(uniqueNY(i) == foundMeSalson(:,1));

foundX = [foundX; uniqueNY(i), max(foundMeSalson(specific,2))];

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