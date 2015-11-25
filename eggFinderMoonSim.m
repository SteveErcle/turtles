% eggFinderMoonSim

clear all;
close all;
clc;


c = yahoo;
stock = 'CMG';


yearlyHL = [];


year1 = 2014;
year2 = year1+1;
month = 1;




monthDay = strcat(num2str(month),'/33/');


w = fetch(c,stock,now, now-300);


 highlow(w(:,3), w(:,4),...
        w(:,3), w(:,4),'blue',w(:,1));
    
    


pause



w = fetch(c,stock,strcat('1/1/', num2str(year1)),...
    strcat(monthDay, num2str(year2)), 'w');

d = fetch(c,stock,strcat('1/1/', num2str(year1)),...
    strcat(monthDay, num2str(year2)), 'd');

for i = 50:200
    
    subplot(1,2,2)
    highlow(w(end-i:end,3), w(end-i:end,4),...
        w(end-i:end,3), w(end-i:end,4),'blue',w(end-i:end,1));
    
    hold on
    volNorm = normalizer(w(end-i:end,6))*(std(w(end-i:end,4))/5)...
        +mean(w(end-i:end,4))*0.75;
    plot(w(end-i:end,1), volNorm, 'k');
    plot(w(end-i:end,1), mean(volNorm), 'k');
    
    hold off
    
    
    
    dateFormat = 12;
    datetick('x',dateFormat);
    title('Weekly HighLow');
    
    
    f1 = (find(w(end-(i+1),1) == d(:,1)))+1
    subplot(1,2,1)
    highlow(d(f1:end,3), d(f1:end,4),...
        d(f1:end,3), d(f1:end,4),'blue',d(f1:end,1));
    
    
    
    dateFormat = 12;
    datetick('x',dateFormat);
    title('Daily HighLow');
    
    minos = min(d(f1:f1+20,4))*0.9;
    maxos = max(d(f1:f1+20,3))*1.1;
    axis([d(f1+20,1), d(f1,1)+3, minos, maxos]);
    
    pause
    
    subplot(1,2,2)
    text(w(end-i:end-i+10,1),w(end-i:end-i+10,3), num2str(w(end-i:end-i+10,3)),...
        'HorizontalAlignment','left', 'Color', 'k', 'FontSize' , 9)
    text(w(end-i:end-i+10,1),w(end-i:end-i+10,4), num2str(w(end-i:end-i+10,4)),...
        'HorizontalAlignment','left', 'Color', 'k', 'FontSize' , 9)
    
    subplot(1,2,1)
    text(d(f1:f1+10,1),d(f1:f1+10,3), num2str(d(f1:f1+10,3)),...
        'HorizontalAlignment','left', 'Color', 'k', 'FontSize' , 9)
    text(d(f1:f1+10,1),d(f1:f1+10,4), num2str(d(f1:f1+10,4)),...
        'HorizontalAlignment','left', 'Color', 'k', 'FontSize' , 9)
    
    
    %     plot(d(f1:end,1), d(f1:end,3),'b');
    %     plot(d(f1:end,1), d(f1:end,4),'r');
    
    
    pause
end




close(c);

