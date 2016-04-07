% portfolioSelectionNode


clear all; clc; close all;


tf = TurtleFun;
ta = TurtleAnalyzer;
FETCH = 0;


delete(slider);
handles = guihandles(slider);
tf = TurtleFun;
ta = TurtleAnalyzer;

simFrom = 1;
simTo = 300;
len = simTo - simFrom;
axisView = 50;
offSet = 50;


set(handles.axisView, 'Max', len, 'Min', 1);
set(handles.axisView, 'SliderStep', [1/len, 10/len]);
set(handles.axisView, 'Value', axisView);

set(handles.axisLen, 'Max', len, 'Min', 25);
set(handles.axisLen, 'SliderStep', [1/len, 10/len]);
set(handles.axisLen, 'Value', offSet);


set(handles.wSize, 'Max', 30 , 'Min', 1);
set(handles.wSize, 'SliderStep', [1/30, 10/30]);
set(handles.wSize, 'Value', 10);

hp = 0;


% portfolio = {'NKE'; 'K'; 'CVX'; 'COF'; 'CELG'; 'ETN'; 'AA'; 'DUK'; 'GOOG'; 'WFC'; 'AMT'};
portfolio = {'XLY'; 'XLP'; 'XLE'; 'XLF'; 'XLV'; 'XLI'; 'XLB'; 'XLU'; 'XLK'; '^GSPC';'^NYA'; '^DJI'}; %'XLFS'; 'XLRE'};
averages = '^GSPC';

past = '1/1/01';
simulateTo = now;

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


range = simFrom:simTo;

p = 0;

figure(1)
subplot(3,2,1)
figure(2)
subplot(3,2,1)
figure(3)
[hiA, loA, clA, opA, daA] = tf.returnOHLCDarray(wAvg);
highlow(hiA, loA, opA, clA, 'red', daA);
hold on

while(true)
    
    windSize = floor(get(handles.wSize, 'Value'));
    set(handles.printSize, 'String', num2str(windSize));
    
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
            stockData = wAll.(stock)(range,:);
            avgData = wAvg(range,:);
        else
            stockData = dAll.(stock)(range,:);
            avgData = dAvg(range,:);
        end
        
        stockBeta = beta.(stock);
        [hi, lo, cl, op, da] = tf.returnOHLCDarray(stockData);
        
        
        [ScbS, SioS, SroS] = ta.getMovingAvgs(stockData, avgData, windSize, stockBeta);
        
        
        subplot(3,2,j)
        cla
        hold on
        
        if get(handles.movingAverage, 'Value')
            plot(da, ScbS, 'r.')
            plot(da, SioS, 'b.')
            plot(da, SroS, 'k.')
        end
        
        if get(handles.RSI, 'Value')
            set(handles.movingAverage, 'Value',0);
            [RSI, RSIma] = ta.getRSI(stockData, avgData, windSize);
            plot(da,RSI,'c.');
            plot(da,RSIma,'m.');
        end
        
        if get(handles.hiLo, 'Value')
            highlow(hi, lo, lo, hi, 'red', da);
        elseif get(handles.ohlc, 'Value')
            highlow(hi, lo, op, cl, 'red', da);
        end
        
        
        title(portfolio{i});
        
        xLen = floor(get(handles.axisView, 'Value'));
        
        offSet = floor(get(handles.axisLen, 'Value'));
        
        if offSet > xLen
            offSet = xLen;
        end
        
        xlim([da(end-xLen+offSet), da(end-xLen)+0.25]);
        
    end
    
    
    set(0,'CurrentFigure',3)
    xLo = da(end-xLen+offSet);
    xHi = da(end-xLen)+0.25;
    yLimits = ylim(gca);
    yLo = yLimits(1);
    yHi = yLimits(2);
    
    x = [xLo xHi xHi xLo];
    y = [yLo yLo yHi yHi];
    
    if hp ~= 0 & ishandle(hp)
        delete(hp);
    end 
    hp = patch(x,y, [0.9,1,1]);
    highlow(hiA, loA, opA, clA, 'red', daA);
    
    pause(0.05)
    
end
























