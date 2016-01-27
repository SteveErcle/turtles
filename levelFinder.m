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

numFound = [];
for i = 1:length(hi)
    numFound = [numFound; i, length(find(hi(i) == hi))];
end



numFound = sortrows(numFound,-2)

i = numFound(22,1);
dots = find(hi(i) == hi);

plot(da(dots), hi(dots), 'ro')