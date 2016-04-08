% portfolioSelectionNode


clear all; clc; close all;


tf = TurtleFun;
ta = TurtleAnalyzer;
FETCH = 0;


delete(slider);
handles = guihandles(slider);
tf = TurtleFun;
td = TurtleData;
ta = TurtleAnalyzer;

simFrom = 1;
simTo = 300;

axisView = now-50;
offSet = 200;

past = '1/1/01';
simulateTo = now;
len = now-datenum(past);

set(handles.axisView, 'Max', now, 'Min', datenum(past));
set(handles.axisView, 'SliderStep', [1/len, 10/len]);
set(handles.axisView, 'Value', axisView);

set(handles.axisLen, 'Max', len, 'Min', 25);
set(handles.axisLen, 'SliderStep', [1/len, 10/len]);
set(handles.axisLen, 'Value', offSet);

set(handles.axisSecondary, 'Max', now, 'Min', datenum(past));
set(handles.axisSecondary, 'SliderStep', [1/len, 10/len]);
set(handles.axisSecondary, 'Value', axisView);

set(handles.wSize, 'Max', 30 , 'Min', 1);
set(handles.wSize, 'SliderStep', [1/30, 10/30]);
set(handles.wSize, 'Value', 10);

hp = 0;


% portfolio = {'NKE'; 'K'; 'CVX'; 'COF'; 'CELG'; 'ETN'; 'AA'; 'DUK'; 'GOOG'; 'WFC'; 'AMT'};
portfolio = {'XLY'; 'XLP'; 'XLE'; 'XLF'; 'XLV'; 'XLI'; 'XLB'; 'XLU'; 'XLK'; '^GSPC';'^NYA'; '^DJI'}; %'XLFS'; 'XLRE'};
averages = '^GSPC';



for hide_getData = 1:1
    
    if FETCH == 1
        
        c = yahoo;
        
        dAvg = fetch(c,averages,past, simulateTo, 'd');
        wAvg = fetch(c,averages,past, simulateTo, 'w');
        mAvg = fetch(c,averages,past, simulateTo, 'm');
        
        for i = 1:length(portfolio)
            
            stock = portfolio{i}
            stockName = stock;
            if stockName(1) == '^'
                stockName = stockName(2:end);
                portfolio{i}= stockName;
            end
            
            dAll.(stockName) = (fetch(c,stock,past, simulateTo, 'd'));
            wAll.(stockName) = fetch(c,stock,past, simulateTo, 'w');
            mAll.(stockName) = fetch(c,stock,past, simulateTo, 'm');
            
            beta.(stockName) = ta.calcBeta(dAll.(stockName), dAvg);
        end
        
        close(c);
        
        save(strcat('portfolio', 'Data'), 'portfolio', 'mAll', 'wAll', 'dAll', 'dAvg', 'wAvg', 'mAvg', 'beta');
    else
        load('portfolioData')
    end
    
end


primaryRange = simFrom:simTo;

p = 0;

figure(1)
subplot(3,2,1)
figure(2)
subplot(3,2,1)
figure(3)
[hiA, loA, clA, opA, daA] = tf.returnOHLCDarray(wAvg);
hl = highlow(hiA, loA, opA, clA, 'red', daA);
hold on

while(true)
    
    windSize = floor(get(handles.wSize, 'Value'));
    set(handles.printSize, 'String', num2str(windSize));
    
    if get(handles.W, 'Value')
        [primaryRange, secondaryRange, primaryDates, secondaryDates] = td.setRanges(handles, wAll);
    else
        [primaryRange, secondaryRange, primaryDates, secondaryDates] = td.setRanges(handles, dAll);
    end
    
    
    for i = 1:12
        
        if i < 7
            set(0,'CurrentFigure',1)
            j = i;
        else
            set(0,'CurrentFigure',2)
            j = i-6;
        end
        
        stock = portfolio{i};
        
        
        if get(handles.W, 'Value')
            stockData = wAll.(stock)(primaryRange,:);
            avgData = wAvg(primaryRange,:);
            stockData2 = wAll.(stock)(secondaryRange,:);
            avgData2 = wAvg(secondaryRange,:);
        else
            stockData = dAll.(stock)(primaryRange,:);
            avgData = dAvg(primaryRange,:);
        end
        
        stockBeta = beta.(stock); % Calc beta on the fly
        [hi, lo, cl, op, da] = tf.returnOHLCDarray(stockData);
        
        
        
        subplot(3,2,j)
        cla
        hold on
        
        
        if get(handles.standardize, 'Value')
            [stockStandardCl, avgStandardCl, rawStandardCl] = ta.getStandardized(stockData, avgData, windSize);
            [stockStandard2Cl, avgStandard2Cl, rawStandard2Cl] = ta.getStandardized(stockData2, avgData2, windSize);
            
            plot(da, stockStandardCl, 'r', 'Marker', '.');
            plot(da, avgStandardCl, 'b', 'Marker', '.');
            plot(da, rawStandardCl, 'k', 'Marker', '.');
            
            if get(handles.accessSecondary, 'Value')
                
                plot(da, stockStandard2Cl, 'm', 'Marker', '.');
                plot(da, avgStandard2Cl, 'c', 'Marker', '.');
                plot(da, rawStandard2Cl, 'color', [0.70,0.70,0.70], 'Marker', '.')
            end
        end
        
        if get(handles.movingAverage, 'Value')
            [ScbS, SioS, SroS] = ta.getMovingAvgs(stockData, avgData, windSize, stockBeta);
            plot(da, ScbS, 'r.')
            plot(da, SioS, 'b.')
            plot(da, SroS, 'k', 'Marker', '.')
            
            if get(handles.accessSecondary, 'Value')
                [ScbS, SioS, SroS] = ta.getMovingAvgs(stockData2, avgData2, windSize, stockBeta);
                plot(da, ScbS, 'm.')
                plot(da, SioS, 'c.')
                plot(da, SroS, 'color', [0.70,0.70,0.70], 'Marker', '.')
            end
        end
        
        if get(handles.RSI, 'Value')
            set(handles.movingAverage, 'Value',0);
            [RSI, RSIma] = ta.getRSI(stockData, avgData, windSize);
            plot(da,RSI,'c.');
            plot(da,RSIma,'m.');
            
            if get(handles.accessSecondary, 'Value')
                [RSI, RSIma] = ta.getRSI(stockData2, avgData2, windSize);
                plot(da,RSI,'g.');
                plot(da,RSIma,'b.');
            end
            
        end
        
        if get(handles.hiLo, 'Value')
            highlow(hi, lo, lo, hi, 'red', da);
        elseif get(handles.ohlc, 'Value')
            highlow(hi, lo, op, cl, 'red', da);
        end
        
        
        
        
        title(portfolio{i});
        
        xlim([primaryDates(1), primaryDates(2)]);
        
    end
    
    
    set(0,'CurrentFigure',3)
    xLo = primaryDates(1);
    xHi = primaryDates(2);
    xLo2 = secondaryDates(1);
    xHi2 = secondaryDates(2);
    
    yLimits = ylim(gca);
    yLo = yLimits(1);
    yHi = yLimits(2);
    
    x = [xLo xHi xHi xLo];
    x2 = [xLo2 xHi2 xHi2 xLo2];
    y = [yLo yLo yHi yHi];
    
    
    if hp ~= 0 && ishandle(hp)
        delete(hp);
        delete(hp2);
        delete(hl);
    end
    hp2 = patch(x2,y, [1,0.9,1]);
    hp = patch(x,y, [0.9,1,1]);
    hl = highlow(hiA, loA, opA, clA, 'red', daA);
    
    pause(0.1)
    
end
























