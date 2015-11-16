clear all;
close all;
clc;


yearlyHL = [];


dayMonth = '1/1/';
dayMonth2 = '12/31/';
c = yahoo;

stock = 'DOW';


for i = 1985:2010
    year1 = i
    year2 = i;
    
    d = fetch(c,stock,strcat(dayMonth, num2str(year1)), strcat(dayMonth2, num2str(year2)), 'm');
    
    high = max(d(:,3));
    low = min(d(:,4));
    
    datestr(d(end,1));
    
    
    
    yearlyHL = [yearlyHL; year1, high, low, d(end,1)];
    
%     highlow(yearlyHL(:,2), yearlyHL(:,3), yearlyHL(:,2),...
%         yearlyHL(:,3),'blue',yearlyHL(:,4));
%     title('Yearly High and Low Prices')
%     text(yearlyHL(:,4),yearlyHL(:,2), num2str(yearlyHL(:,2)),...
%         'HorizontalAlignment','right', 'Color', 'k', 'FontSize' , 10)
%     text(yearlyHL(:,4),yearlyHL(:,3), num2str(yearlyHL(:,3)),...
%         'HorizontalAlignment','right', 'Color', 'k', 'FontSize' , 10)
%     dateFormat = 10;
%     datetick('x',dateFormat)
    
    
%     pause
    
end



% plot(yearlyHL(:,1), yearlyHL(:,2:3))
% hold on
% plot(yearlyHL(:,1), yearlyHL(:,2:3), 'x')
% subplot(2,1,1)
highlow(yearlyHL(:,2), yearlyHL(:,3), yearlyHL(:,2),...
    yearlyHL(:,3),'blue',yearlyHL(:,4));
title('Yearly High and Low Prices')
text(yearlyHL(:,4),yearlyHL(:,2), num2str(yearlyHL(:,2)),...
    'HorizontalAlignment','right', 'Color', 'k', 'FontSize' , 10)
text(yearlyHL(:,4),yearlyHL(:,3), num2str(yearlyHL(:,3)),...
    'HorizontalAlignment','right', 'Color', 'k', 'FontSize' , 10)
dateFormat = 10;
datetick('x',dateFormat)

% d = fetch(c,stock,'1/1/1988', '1/1/2012', 'm');
% subplot(2,1,2)
% plot(d(:,1),d(:,6)/100000,'b')
% dateFormat = 10;
% datetick('x',dateFormat)

% figure()

% plot(d(:,1),d(:,5),'k')
% hold on


figure()
for j = 0:9
    
    for i = 1:12
        year1 = 2001;
        year2 = 2006 + j;
        dayMonth = '1/1/';
        month = i;
        dayMonth2 = strcat(num2str(month),'/28/');
        d = fetch(c,stock,strcat(dayMonth, num2str(year1)), strcat(dayMonth2, num2str(year2)), 'm');
        strcat(dayMonth, num2str(year1))
        strcat(dayMonth2, num2str(year2))
        % plot(d(:,1), d(:,5))
        % datestr(d(1,1))
        % dateFormat = 6;
        % datetick('x',dateFormat)
        
        
        highlow(d(:,3), d(:,4), d(:,3), d(:,4),'blue',d(:,1));
        
        pause
        
        
    end
    
end



close(c);


% div = fetch(c,'JPM','11/12/2005', '11/12/2010', 'v');
% open = d(:,2);
% cclose = d(:,5);

d = fetch(c,stock,'1/1/1995', '2/1/1995', 'm')

w = [d];

d = fetch(c,stock,'1/1/1995', '2/29/1995', 'm')

w = [w;d]

datestr(w(:,1))



%
% dateP = d(:,1)/100;
%
% dividend =  div(:,2)*100;
% dateD = div(:,1)/100;
%
%
% hold on;
% plot(dateP,price)
% plot(dateD,dividend)


% priceNorm = normalizer(d(:,7));
% volNorm = normalizer(d(:,6));
%
% priceNormDiff = normalizer(diff(d(:,7)));
% priceNorm = normalizer((d(:,7)));
% volNorm = normalizer(d(:,6));
%
% [priceFilt] = getFiltered(priceNorm, 0.02, 'low');
% [volFilt] = getFiltered(volNorm, 0.1, 'low');
%
% hold on
%
%
% plot(priceNorm,'k')
% plot(volNorm,'g')
% plot(priceFilt,'r');
%
% plot(volFilt)
%
% plot(1:length(volNorm),mean(volNorm),'k');
