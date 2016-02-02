clear; close all; clc;

stock = 'AXL'
exchange = 'NYSE';


[~,allStocks] = xlsread('listOfStocks')

for i = 19:length(allStocks)
    
    stock = allStocks(i)
   
    c = yahoo;
    m = fetch(c,stock,now, now-500, 'm');
    d = fetch(c,stock,now, now-500, 'd');
    d = getTodaysOHLC(stock, exchange, d);
    close(c)
    
    
    datestr(d(1))
    tf = TurtleFun;
    
    
    tf.plotHiLo(d);
    set(gcf, 'Position', [9,5,1423,800])
    title(strcat(stock,' Daily'))
    
    [hi, lo, cl, op, da] = tf.returnOHLCDarray(d);
    [foundRes, foundSup, foundDates, closestRes, closestSup] = tf.getContainerLevels(100, hi, lo, da);
    
    
    tf.plotContainer([foundRes, foundSup, foundDates])
    
    sprintf('Closest Resistant: %0.2f',closestRes*100)
    sprintf('Closest Support:   %0.2f',closestSup*100)
    pause
    close all
    
end



% Use series filtering not weighing. Return all under X%, sort by longest
% time first