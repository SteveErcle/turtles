clc; close all; clear all;


past = now - 1000;
pres = now - 500;

tf = TurtleFun;
td = TurtleData;

delete(slider);
handles = guihandles(slider);

% portfolio = {'PG';'KO';'PM';'CVS';'MO';'WMT';'PEP';'WBA';'COST';'CL';'MDLZ';'KMB'};
portfolio = {'BAS'}

for j = 1:length(portfolio)
    
    
    stock = portfolio{j}
    
    % c = yahoo;
    
    % dAll = flipud(fetch(c,stock,past, now, 'd'));
    % load('price26Day.mat');
    exchange = 'NASDAQ';
    iAll = IntraDayStockData(stock,exchange,'60','3d');
    iAll = td.getAdjustedIntra(iAll);
    
    
 
    len = length(iAll.high)
    
    set(handles.axisView, 'Max', len, 'Min', 200);
    set(handles.axisView, 'SliderStep', [1/len, 10/len]);
    set(handles.axisView, 'Value', 200);
    
    
    % while(true)
    
    rangeLen = floor(get(handles.axisView, 'Value'));
    
    range = 1:len;
    % [hi, lo, cl, op, da] = tf.returnOHLCDarray(dAll(range,:));
    hi = iAll.high(range);
    lo = iAll.low(range);
    op = iAll.open(range);
    cl = iAll.close(range);
    vo = iAll.volume(range);
    
    magicTarr = [];
    
    atr = mean([hi,lo,op,cl],2);
    
    for i = 2:length(cl)
        
        if atr(i) >= atr(i-1)
            magicTarr = [magicTarr; 1];
        else
            magicTarr = [magicTarr; 0];
        end
        
    end
    
    sum(magicTarr) / length(magicTarr);
    negMagTarr = (magicTarr == 0) * -1;
    magicTarr = magicTarr + negMagTarr;
    
    summer = 0;
    total = [];
    
    for i = 1:length(magicTarr)
        summer = summer + magicTarr(i);
        total = [total; summer];
    end
    
    windSize = 25;
    totalMA = tsmovavg(total,'s', windSize ,1);
    priceMA = tsmovavg(atr,'s', windSize ,1);
    
    [valTP indxTP] = findpeaks(totalMA,'MINPEAKDISTANCE',100);
    [valTPn indxTPn] = findpeaks(-totalMA,'MINPEAKDISTANCE',100);
    
    subplot(2,1,1)
    cla
    bar(vo)
    
%     title('MagicT')
%     plot(total)
%     hold on
%     plot(totalMA,'r')
%     axis([range(1), range(end), min(total), max(total)])
%     for i = 1:length(indxTP)
%         plot( [indxTP(i)+2, indxTP(i)+2], ylim )
%     end
%     for i = 1:length(indxTPn)
%         plot( [indxTPn(i)+2, indxTPn(i)+2], ylim )
%     end
%     
    subplot(2,1,2)
    cla
    title('Price')
    candle(hi, lo, cl, op, 'blue');
    hold on
    plot(priceMA,'r')
    ylimit = ylim;
    for i = 1:length(indxTP)
        plot([indxTP(i), indxTP(i)], ylim)
    end
    for i = 1:length(indxTPn)
        plot([indxTPn(i), indxTPn(i)], ylim)
    end
    ylim(ylimit)
    axis([range(1), range(end), min(lo), max(hi)])
%     
    % pause(0.1)
    
    position = -1;
    maStack = [];
    
    for i = range(1:end-1)
        
        
        
        subplot(2,1,2)
        if priceMA(i) > lo(i) & priceMA(i+1) < op(i+1)
            plot(i+1, priceMA(i+1), 'go')
            
            if position ~= 1 & vo(i) > mean(vo)
                maStack = [maStack; op(i+1), 1];
            end
            
            position = 1;
            priceMA(i+1);
            
        end
        
        if priceMA(i) < hi(i) & priceMA(i+1) > op(i+1)
            plot(i+1, priceMA(i+1), 'ro')
            
            if position ~= 0 & vo(i) > mean(vo)
                maStack = [maStack; op(i+1), 0];
            end
            
            position = 0;
            priceMA(i+1);
            
        end
        
        %     pause
        
    end
    
    
    roiStack = [];
    
    for i = 1:length(maStack)-1
        
        if maStack(i,2) == 0
            roi = (maStack(i,1) - maStack(i+1,1))/ maStack(i,1)*100;
        else
            roi = (maStack(i+1,1) - maStack(i,1))/ maStack(i,1)*100;
        end
        
        roiStack = [roiStack; roi];
        
    end
    
    sum(roiStack)
    length(roiStack)
    
    pause
    
    
end

