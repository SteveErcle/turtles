% intraDayPractice

clc; close all; clear all;

stock = 'AMD';
exchange = 'NASDAQ';

td = TurtleData;

thirty = IntraDayStockData(stock,exchange,'1800','100d');
thirty = td.getAdjustedIntra(thirty);
five = IntraDayStockData(stock,exchange,'300','1d');
five =  td.getAdjustedIntra(five);


for finished5 = 1:length(five.date)
    
    
    finished30 = max(find(five.date(finished5) >= thirty.date))
    
    range5 = 1:finished5;
    range30 = 1:finished30-1;
    
    
    subplot(2,1,1)
    cla
    if finished5 == 1
        tickSize = 0.001;
        hold on;
        plot([five.date(1),five.date(1)], [five.low(1),five.high(1)]);
        plot([five.date(1)-tickSize,five.date(1)], [five.open(1),five.open(1)]);
        plot([five.date(1),five.date(1)+tickSize], [five.close(1),five.close(1)]);
    else
        candle(five.high(range5), five.low(range5), five.close(range5), five.open(range5), 'blue', five.date(range5));
    end
    
    subplot(2,1,2)
    cla
    if finished30 == 2
        tickSize = 0.001;
        hold on;
        plot([thirty.date(1),thirty.date(1)], [thirty.low(1),thirty.high(1)]);
        plot([thirty.date(1)-tickSize,thirty.date(1)], [thirty.open(1),thirty.open(1)]);
        plot([thirty.date(1),thirty.date(1)+tickSize], [thirty.close(1),thirty.close(1)]);
    elseif finished30 > 2
        candle(thirty.high(range30), thirty.low(range30), thirty.close(range30), thirty.open(range30), 'blue', thirty.date(range30));
    end
    
    pause
    
end

