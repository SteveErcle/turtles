clear all;
close all;
clc;


yearlyHL = [];
quarterlyHL = [];

c = yahoo;

stock = 'IWM';

% figure
% hold on
% trades = []
% while(true)
%     trades = [trades; get_last_trade_google(stock)];
%     plot(trades)
%     pause(10)
% end


m = fetch(c,stock,now, now-17000, 'm');

close(c)

years = str2num(datestr(m(:,1), 10))

start = years(end)
final = years(1)

for i_year = start:final
    
    indx = find(years == i_year);
    
    
    yearlyHL = [yearlyHL; min(m(indx,1)), max(m(indx,3)), min(m(indx,4))];
    
end
figure
highlow(yearlyHL(:,2), yearlyHL(:,3), yearlyHL(:,2),...
    yearlyHL(:,3),'blue',yearlyHL(:,1));
title('Yearly High and Low Prices')
dateFormat = 12;
datetick('x',dateFormat)


quarters = datestr(m(:,1), 27);

for i_year = start:final
    for i_quarter = 1:4
        
        quarterToMatch = strcat('Q', num2str(i_quarter), '-', num2str(i_year));
        indx = strmatch(quarterToMatch, quarters, 'exact');
        quarterlyHL = [quarterlyHL; min(m(indx,1)), max(m(indx,3)), min(m(indx,4))];
        
        max(m(indx,3));
        
        min(m(indx,4));
    end
end

figure
highlow(quarterlyHL(:,2), quarterlyHL(:,3), quarterlyHL(:,2),...
    quarterlyHL(:,3),'blue',quarterlyHL(:,1));
title('Quarterly High and Low Prices')
dateFormat = 12;
datetick('x',dateFormat)
