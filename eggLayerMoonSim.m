% eggLayer

clear all;
close all;
clc;


c = yahoo;
stock = 'MENT';


yearlyHL = [];


year1 = 2006;
year2 = 2000 + 11;
month = 1;

monthDay = strcat(num2str(month),'/33/');


w = fetch(c,stock,strcat('1/1/', num2str(year1)),...
    strcat(monthDay, num2str(year2)), 'w');

for i = 100:400
    highlow(w(end-i:end,3), w(end-i:end,4),...
        w(end-i:end,3), w(end-i:end,4),'blue',w(end-i:end,1));
    
    text(w(end-i:end,1),w(end-i:end,3), num2str(w(end-i:end,3)),...
        'HorizontalAlignment','right', 'Color', 'k', 'FontSize' , 9)
    text(w(end-i:end,1),w(end-i:end,4), num2str(w(end-i:end,4)),...
        'HorizontalAlignment','right', 'Color', 'k', 'FontSize' , 9)
    
    w(end-i,5)
    
    pause
end




close(c);

