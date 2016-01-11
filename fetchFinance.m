clear all;
close all;
clc;





stock =  'PBR'

%'SYY - Buy - Trend up, small reaction'
%'TWX - Watch to buy' 
%'IWM - Watch to buy' 

%'PBR - Short - Trend down, close to support'
%'EEM - Short - Just broke out' 
%'FCX - Short - already broke out'
 
 
 %'TVIX' %'MMYT'; %'SGG'

c = yahoo;
m = fetch(c,stock,now, now-17000, 'm');
w = fetch(c,stock,now, now-17000, 'w');
close(c)

for init = 1:1
    
    yearlyHL = [];
    quarterlyHL = [];
    
    
    years = str2num(datestr(m(:,1), 10));
    quarters = datestr(m(:,1), 27);
    
    start = years(end);
    final = years(1);
    
end

for i_year = start:final
    
    indx = find(years == i_year);
    
    yearlyHL = [yearlyHL; min(m(indx,1)), max(m(indx,3)), min(m(indx,4))];
    
end

for i_year = start:final
    for i_quarter = 1:4
        
        quarterToMatch = strcat('Q', num2str(i_quarter), '-', num2str(i_year));
        indx = strmatch(quarterToMatch, quarters, 'exact');
        quarterlyHL = [quarterlyHL; min(m(indx,1)), max(m(indx,3)), min(m(indx,4))];
        
        max(m(indx,3));
        
        min(m(indx,4));
    end
end

for i_plot = 1:1
    
    figure
    highlow(yearlyHL(:,2), yearlyHL(:,3), yearlyHL(:,2),...
        yearlyHL(:,3),'blue',yearlyHL(:,1));
    title('Yearly High and Low Prices')
    dateFormat = 12;
    datetick('x',dateFormat)
    set(gcf, 'Position', [22,24,632,781]);
    
    figure
    highlow(quarterlyHL(:,2), quarterlyHL(:,3), quarterlyHL(:,2),...
        quarterlyHL(:,3),'blue',quarterlyHL(:,1));
    title('Quarterly High and Low Prices')
    dateFormat = 12;
    datetick('x',dateFormat)
    set(gcf, 'Position', [750,12,690,793]);
    
    
    figure
    hi = m(:,3); lo = m(:,4); cl = m(:,5); op = m(:,2); da = m(:,1);
    highlow(hi, lo, hi, lo,'blue', da);
    axis([da(100), da(1)+15,...
        min(lo(1:100))*0.95, max(hi(1:100))*1.05])
    title('Monthly')
    datetick('x',12, 'keeplimits');
    set(gcf, 'Position', [1444,1018,1075,799]);
    
    figure
    hi = w(:,3); lo = w(:,4); cl = w(:,5); op = w(:,2); da = w(:,1);
    highlow(hi, lo, hi, lo,'blue', da);
    hold on
    highlow(hi, lo, op, cl, 'blue', da);
    axis([da(100), da(1)+5,...
        min(lo(1:100))*0.95, max(hi(1:100))*1.05])
    title('Weekly')
    datetick('x',12, 'keeplimits');
    set(gcf, 'Position', [1443,4,1075,877]);
    
    pause
    
    close all
    
end
 