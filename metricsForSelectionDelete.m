% MetricsForSelection

clear; close all; clc;

stock = 'TSLA';
c = yahoo;
m = fetch(c,stock,now, now-7000, 'm');
w = fetch(c,stock,now, now-7000, 'w');
d = fetch(c,stock,now, now-7000, 'd');
close(c)

for initSubPlots = 1:1
    
    subplot(3,1,1)
    hi = m(:,3); lo = m(:,4); cl = m(:,5); op = m(:,2); da = m(:,1);
    highlow(hi, lo, hi, lo,'blue', da);
    hold on
    highlow(hi, lo, op, cl, 'blue', da);
    title('Monthly')
    
    subplot(3,1,2)
    hi = w(:,3); lo = w(:,4); cl = w(:,5); op = w(:,2); da = w(:,1);
    highlow(hi, lo, hi, lo,'blue', da);
    hold on
    title('Weekly')
    
    subplot(3,1,3)
    hi = d(:,3); lo = d(:,4); cl = d(:,5); op = d(:,2); da = d(:,1);
    highlow(hi, lo, hi, lo,'blue', da);
    hold on
    title('Daily')
end

set(gcf, 'Position', [1441,1,1080,1824]);

hi = d(:,3); lo = d(:,4); cl = d(:,5); op = d(:,2); da = d(:,1);

closePercents = [];
for i = 1:length(d)-1
    closePercents = [closePercents; da(i), (cl(i)-cl(i+1))/cl(i+1)];
end

closePercents = sortrows(closePercents, -2)

for i = 1:10
    indxOfLargestPercent = find(closePercents(i,1) == da)
    
    
    subplot(3,1,3)
    plot(closePercents(i,1), cl(indxOfLargestPercent), 'go');
end



