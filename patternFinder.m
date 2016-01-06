close all
clear
clc

c = yahoo;
stock = 'TSLA';
t = fetch(c,stock,now, now-7000, 'w');
close(c)

figure(1)
hi = t(:,3); lo = t(:,4); cl = t(:,5); op = t(:,2); da = t(:,1);
subplot(4,1,1)
highlow(hi, lo, hi, lo,'blue', da);
hold on;

start = 1
final = 10
inv = final - start;

A = [lo(start:final); hi(start:final)];
A = A/A(1);

storeSum = [];
for i = 1:length(da) - inv
    
    if i ~= start:final
        B = [lo(i:i+inv); hi(i:i+inv)];
        B = B/B(1);
        
        storeSum = [storeSum; i, da(i), sum((A-B).^2)];
    end
    
end

storeSum = sortrows(storeSum,3);
datestr(storeSum(1,2))
figure(1)
subplot(4,1,1)
plot(da(start:final), hi(start:final), 'go')
axis([da(final) - 70, da(start) + 70 ,...
    min(lo(start:final))*0.95,...
    max(hi(start:final))*1.05]);

figure(2)
highlow(hi, lo, hi, lo,'blue', da);
hold on;
plot(da(start:final), hi(start:final), 'go')



counter = 2;
for i = storeSum(1:3,1)'
    
    if counter == 2
        c = 'ro';
    elseif counter == 3
        c = 'mo';
    else
        c = 'yo';
    end
    
    figure(1)
    subplot(4,1,counter)
    highlow(hi, lo, hi, lo,'blue', da);
    hold on
    plot(da(i:i+inv), hi(i:i+inv), c)
    
    axis([da(i+inv) - 70, da(i) + 70 ,...
        min(lo(i:i+inv))*0.90,...
        max(hi(i:i+inv))*1.10]);
    
    
    figure(2)
    plot(da(i:i+inv), hi(i:i+inv), c)
    
    
    counter = counter + 1;
end


