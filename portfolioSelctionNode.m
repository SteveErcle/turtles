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



averages = '^GSPC';


for hide_getData = 1:1
    
    portfolio.sectors = {'XLY'; 'XLP'; 'XLE'; 'XLF'; 'XLV'; 'XLI'; 'XLB'; 'XLU'; 'XLK'; '^NYA'; '^DJI'; '^GSPC'}; %'XLFS'; 'XLRE'};
    portfolio.discretionary = {'AMZN';'HD';'CMCSA';'DIS';'MCD';'SBUX';'NKE';'LOW';'PCLN';'TWX';'TWC'; 'TJX'};
    portfolio.staples = {'PG';'KO';'PM';'CVS';'MO';'WMT';'PEP';'WBA';'COST';'CL';'MDLZ';'KMB'};
    portfolio.energy = {'XOM';'CVX';'SLB';'PXD';'EOG';'OXY';'VLO';'PSX';'HAL';'COP';'KMI';'TSO'};
    portfolio.finance = {'BRK-B'; 'WFC'; 'BAC'; 'C'; 'USB'; 'AIG'; 'JPM';  'CB'; 'SPG'; 'AXP'; 'PNC'; 'BK'};
    portfolio.healthcare = {'JNJ';'PFE';'MRK';'GILD';'UNH';'AMGN';'BMY';'MDT';'AGN';'ABBV';'CELG';'LLY'};
    portfolio.industrials = {'GE';'MMM';'HON';'BA';'UTX';'UPS';'UNP';'LMT';'DHR';'CAT';'FDX';'GD'};
    portfolio.materials = {'DOW';'DD';'MON';'PX';'ECL';'PPG';'LYB';'APD';'SHW';'IP'; 'FCX'; 'VMC'};
    portfolio.utilities = {'NEE';'DUK';'SO';'D';'AEP';'EXC';'PCG';'PPL';'SRE';'PEG';'EIX';'ED'};
    portfolio.technology = {'AAPL'; 'MSFT'; 'FB'; 'T'; 'GOOGL'; 'GOOG'; 'VZ'; 'INTC'; 'V'; 'CSCO'; 'IBM'; 'ACN'};
    
    
    if FETCH == 1
        
        c = yahoo;
        
        dAvg = fetch(c,averages,past, simulateTo, 'd');
        wAvg = fetch(c,averages,past, simulateTo, 'w');
        mAvg = fetch(c,averages,past, simulateTo, 'm');
        
        for i = 1: length(fieldnames(portfolio))
            markets = fieldnames(portfolio);
            market = markets{i};
            
            for j = 1:length(portfolio.(market))
                
                stock = portfolio.(market){j};
                disp(stock);
                
                stockName = stock;
                if stockName(1) == '^'
                    stockName = stockName(2:end);
                    portfolio.(market){j}= stockName;
                elseif sum(stockName == '-') > 0
                    stockName(find(stockName == '-')) = [];
                    portfolio.(market){j}= stockName;
                end
                
                dAll.(stockName) = (fetch(c,stock,past, simulateTo, 'd'));
                wAll.(stockName) = fetch(c,stock,past, simulateTo, 'w');
                mAll.(stockName) = fetch(c,stock,past, simulateTo, 'm');
                
                beta.(stockName) = ta.calcBeta(dAll.(stockName), dAvg);
            end
            
            close(c);
        end
        
        save(strcat('portfolio', 'Data'), 'portfolio', 'mAll', 'wAll', 'dAll', 'dAvg', 'wAvg', 'mAvg', 'beta');
    else
        load('portfolioData')
    end
    
end


primaryRange = simFrom:simTo;

p = 0;

figure(1)
set(gcf, 'Position', [-1080,1,1079,1824]);
subplot(3,2,1)
figure(2)
set(gcf, 'Position', [-1080,1,1079,1824]);
subplot(3,2,1)
figure(3)
[hiA, loA, clA, opA, daA] = tf.returnOHLCDarray(wAvg);
hl = highlow(hiA, loA, opA, clA, 'red', daA);
hp = 0;

hold on

while(true)
    
    windSize = floor(get(handles.wSize, 'Value'));
    set(handles.printSize, 'String', num2str(windSize));
    
    
    idxs = get(handles.idx, 'String');
    selectedIdx = get(handles.idx, 'Value');
    idx = idxs{selectedIdx};
    
    markets = get(handles.market, 'String');
    selectedMarket = get(handles.market, 'Value');
    market = lower(markets{selectedMarket});
    
    indiv = get(handles.indivAnalysis, 'Value');

    
    for i = 1:13
        
        if i < 7
            set(0,'CurrentFigure',1)
            j = i;
            stock = portfolio.(market){i};
        elseif i >= 7 & i ~= 13
            set(0,'CurrentFigure',2)
            j = i-6;
            stock = portfolio.(market){i};
        elseif i == 13 & indiv ~= 1
            set(0,'CurrentFigure',3)
            stock = portfolio.(market){indiv-1};
        elseif i == 13 & indiv == 1
            break;
        end
        
        
        if get(handles.W, 'Value')
            [primaryRange, secondaryRange, primaryDates, secondaryDates] = td.setRanges(handles, wAll);
            primaryRange = primaryRange(2:end);
            secondaryRange = secondaryRange(2:end);
            stockData = wAll.(stock)(primaryRange,:);
            avgData = wAll.(idx)(primaryRange,:);
            stockData2 = wAll.(stock)(secondaryRange,:);
            avgData2 = wAll.(idx)(secondaryRange,:);
        else
            [primaryRange, secondaryRange, primaryDates, secondaryDates] = td.setRanges(handles, dAll);
            primaryRange = primaryRange(2:end);
            secondaryRange = secondaryRange(2:end);
            stockData = dAll.(stock)(primaryRange,:);
            avgData = dAvg(primaryRange,:);
            stockData2 = dAll.(stock)(secondaryRange,:);
            avgData2 = dAvg(secondaryRange,:);
        end
        
        stockBeta = beta.(stock); % Calc beta on the fly
        [hi, lo, cl, op, da] = tf.returnOHLCDarray(stockData);
        
        if i ~= 13
            subplot(3,2,j)
        end
        cla
        hold on
        
        
        if get(handles.standardize, 'Value')
            set(handles.movingAverage, 'Value',0);
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
            plot(da,RSIma, 'k', 'Marker', '.')
            
            if get(handles.accessSecondary, 'Value')
                [RSI, RSIma] = ta.getRSI(stockData2, avgData2, windSize);
                plot(da,RSIma, 'color', [0.70,0.70,0.70], 'Marker', '.')
            end
            
        end
        
        if get(handles.hiLo, 'Value')
            highlow(hi, lo, lo, hi, 'red', da);
        elseif get(handles.ohlc, 'Value')
            highlow(hi, lo, op, cl, 'red', da);
        end
        
        title(stock);
        
        xlim([primaryDates(1), primaryDates(2)+10]);
        
    end
    
    if indiv == 1
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
    end
    
    
    pause(0.1)
    
end






% % % % subplot margin

% pos = get(gca, 'Position');
% pos(1) = 0.055;
% pos(3) = 0.9;
% set(gca, 'Position', pos)

% % % % 















