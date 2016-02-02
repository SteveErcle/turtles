clear all
close all
clc

%TSEM 
%EXC
%NBR watch
%AXL watch
%BC watch
%ECPG
%CSX
%PSEC
%ETE
%SWC watch
%HTZ
%KBE
%GIS
%ROK
%WMB
%RY

selection = [];
sortedSupportDistance = [];
[~,allStocks] = xlsread('listOfStocks')

for i = 1:length(allStocks)
    stock = allStocks(i)
    
    c = yahoo;
    m = fetch(c,stock,now, now-17000, 'm');
    w = fetch(c,stock,now, now-17000, 'w');
    d = fetch(c,stock,now, now-17000, 'd');
    close(c)
    
    exchange = 'NYSE';
    d = getTodaysOHLC(stock, exchange, d);
    
    datestr(d(1))
    [quarterlyHL yearlyHL] = getQYHL(m);
    foundSupportLevels = sort([quarterlyHL(2:10,2);quarterlyHL(2:10,3)]);
    
    d_ago = 30;
    w_ago = 12;
    m_ago = 6;
    q_ago = 4;
    y_ago = 2;
    
    py = polyfit((1:length(yearlyHL(1:y_ago,3)))',flipud(yearlyHL(1:y_ago,3)),1);
    pq = polyfit((1:length(quarterlyHL(1:q_ago,3)))',flipud(quarterlyHL(1:q_ago,3)),1);
    pm = polyfit((1:length(m(1:m_ago)))',flipud(m(1:m_ago,4)),1);
    pw = polyfit((1:length(w(1:w_ago,4)))',flipud(w(1:w_ago,4)),1);
    pd = polyfit((1:length(d(1:d_ago,4)))',flipud(d(1:d_ago,4)),1);
    
    if py(1)<0 && pq(1)<0 && pm(1)<0 && pw(1)<0 && pd(1)<0
        dfromlevel = d(1,4)-foundSupportLevels
        compareCurrentToSup = min(abs((dfromlevel)/(d(1,4))));
%         sortedSupportDistance = [sortedSupportDistance; i , compareCurrentToSup];
%         selection = [selection, i];
%         selection
        if compareCurrentToSup <= 0.02
            selection = [selection, i];
            selection
       end
    end
    selection
    
end 

%%
return

    
for i_plot = 1:1
            
            figure
            highlow(yearlyHL(:,2), yearlyHL(:,3), yearlyHL(:,2),...
                yearlyHL(:,3),'blue',yearlyHL(:,1));
            title('Yearly High and Low Prices')
            dateFormat = 12;
            datetick('x',dateFormat)
            %set(gcf, 'Position', [22,24,632,781]);
            
            figure
            highlow(quarterlyHL(:,2), quarterlyHL(:,3), quarterlyHL(:,2),...
                quarterlyHL(:,3),'blue',quarterlyHL(:,1));
            title('Quarterly High and Low Prices')
            dateFormat = 12;
            datetick('x',dateFormat)
            %set(gcf, 'Position', [750,12,690,793]);
            hold on
            autoPlotLevs(quarterlyHL, yearlyHL, quarterlyHL)
            
            
            figure
            hi = m(:,3); lo = m(:,4); cl = m(:,5); op = m(:,2); da = m(:,1);
            highlow(hi, lo, hi, lo,'blue', da);
            axis([da(100), da(1)+15,...
                min(lo(1:100))*0.95, max(hi(1:100))*1.05])
            title('Monthly')
            datetick('x',12, 'keeplimits');
            %set(gcf, 'Position', [1444,1018,1075,799]);
            hold on
            autoPlotLevs(quarterlyHL, yearlyHL, da)
            
            
            figure
            hi = w(:,3); lo = w(:,4); cl = w(:,5); op = w(:,2); da = w(:,1);
            highlow(hi, lo, hi, lo,'blue', da);
            hold on
            highlow(hi, lo, op, cl, 'blue', da);
            axis([da(100), da(1)+5,...
                min(lo(1:100))*0.95, max(hi(1:100))*1.05])
            title(strcat(stock,' Weekly'))
            datetick('x',12, 'keeplimits');
            %set(gcf, 'Position', [1443,4,1075,877]);
            
            autoPlotLevs(quarterlyHL, yearlyHL, da)
            
            
            figure
            hi = d(:,3); lo = d(:,4); cl = d(:,5); op = d(:,2); da = d(:,1);
            highlow(hi, lo, op, cl, 'blue', da);
            axis([da(100), da(1)+5,...
                min(lo(1:100))*0.95, max(hi(1:100))*1.05])
            title(strcat(stock,' Daily'))
            datetick('x',12, 'keeplimits');
            
            hold on
            
            autoPlotLevs(quarterlyHL, yearlyHL, da)
            
            
            pause
            
            close all
            
        end

% (cl(1)-quarterlyHL(2:5,2))./ quarterlyHL(2:5,2);
% (cl(1)-yearlyHL(2:5,2))./ yearlyHL(2:5,2);

% (cl(1)-quarterlyHL(2:5,3))./ quarterlyHL(2:5,3);
% (cl(1)-yearlyHL(2:5,3))./ yearlyHL(2:5,3);


%
for volumeRedDots = 1:1
    
    % stock = 'CHRS'
    % exchange = 'NASDAQ';
    %
    %
    % data = IntraDayStockData(stock,exchange,'300', '60d');
    % hi = data.high; lo = data.low; vo = data.volume; da = data.date;
    %
    % datar = [vo,str2num(datestr(da,7))];
    %
    % storez = [datar(2,1), da(2)];
    %
    % for i = 1:length(datar)-2
    %     if datar(i,2) ~= datar(i+1,2)
    %         storez = [storez; datar(i+2,1), da(i+2)];
    %     end
    % end
    %
    %
    % storez(:,1) = mean(d(:,3))*(storez/max(storez))/1.5
    %
    %
    % hi = d(:,3); lo = d(:,4); cl = d(:,5); op = d(:,2); da = d(:,1);
    % highlow(hi, lo, op, cl, 'blue', da);
    % title('Daily')
    % datetick('x',12, 'keeplimits');
    % hold on
    %
    %
    % bar(storez(:,2),  storez(:,1), 1)
    % datetick('x',12, 'keeplimits');
    %
    %
    % for i = 1:length(storez)
    %     if storez(i) > 2.75
    %
    %         find(da == storez(i,2))
    %
    %         plot(storez(i,2), mean(hi), 'ro')
    %
    %     end
    %
    % end
    
    
    % figure
    % hi = m(:,3); lo = m(:,4); cl = m(:,5); op = m(:,2); da = m(:,1); vo = m(:,6);
    % highlow(hi, lo, hi, lo,'blue', da);
    % axis([da(100), da(1)+15,...
    %     min(lo(1:100))*0.95, max(hi(1:100))*1.05])
    % title('Monthly')
    % datetick('x',12, 'keeplimits');
    % set(gcf, 'Position', [1444,1018,1075,799]);
    %
    %
    % figure
    % subplot(2,1,1)
    % bar(da, vo)
    % axis([da(100), da(1)+15,...
    %     min(vo(1:100))*0.95, max(vo(1:100))*1.05])
    %
    % title('Monthly Volume')
    % datetick('x',12, 'keeplimits');
    %
    %
    % subplot(2,1,2)
    %
    % vo = (vo-mean(vo))/mean(vo);
    %
    % bar(da, vo)
    % axis([da(100), da(1)+15,...
    %     min(vo(1:100))*0.95, max(vo(1:100))*1.05])
    %
    % title('Monthly Volume')
    % datetick('x',12, 'keeplimits');
    
end
%
