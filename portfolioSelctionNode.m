% portfolioSelectionNode

clc; close all; clear all; 


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

set(handles.ref, 'Max', now, 'Min', datenum(past));
set(handles.ref, 'SliderStep', [1/len, 10/len]);
set(handles.ref, 'Value', axisView);

set(handles.wSize, 'Max', 30 , 'Min', 1);
set(handles.wSize, 'SliderStep', [1/30, 10/30]);
set(handles.wSize, 'Value', 10);

randColors = [0.349983765984809,0.196595250431208,0.251083857976031;0.616044676146639,0.473288848902729,0.351659507062997;0.830828627896291,0.585264091152724,0.549723608291140;0.917193663829810,0.285839018820374,0.757200229110721;0.753729094278495,0.380445846975357,0.567821640725221;0.0758542895630636,0.0539501186666072,0.530797553008973;0.779167230102011,0.934010684229183,0.129906208473730;0.568823660872193,0.469390641058206,0.0119020695012414;0.337122644398882,0.162182308193243,0.794284540683907;0.311215042044805,0.528533135506213,0.165648729499781;0.601981941401637,0.262971284540144,0.654079098476782;0.689214503140008,0.748151592823710,0.450541598502498];


for hide_getData = 1:1
    
    portfolio.sectors = {'XLY'; 'XLP'; 'XLE'; 'XLF'; 'XLV'; 'XLI'; 'XLB'; 'XLU'; 'XLK'; '^NYA'; '^DJI'; '^GSPC'}; %'XLFS'; 'XLRE'};
    portfolio.discretionary = {'AMZN';'HD';'CMCSA';'DIS';'MCD';'SBUX';'NKE';'LOW';'PCLN';'TWX';'TWC'; 'TJX'};
    portfolio.staples = {'PG';'KO';'PM';'CVS';'MO';'WMT';'PEP';'WBA';'COST';'CL';'MDLZ';'KMB'};
    portfolio.energy = {'XOM';'CVX';'SLB';'PXD';'EOG';'OXY';'VLO';'PSX';'HAL';'COP';'KMI';'TSO'};
    portfolio.finance = {'BRK-B'; 'WFC'; 'BAC'; 'C'; 'USB'; 'AIG'; 'JPM';  'CB'; 'SPG'; 'AXP'; 'PNC'; 'BK'};
    portfolio.healthcare = {'JNJ';'PFE';'MRK';'GILD';'UNH';'AMGN';'BMY';'MDT';'AGN';'ABBV';'CELG';'LLY'};
    portfolio.industrials = {'GE';'MMM';'HON';'BWA';'UTX';'UPS';'UNP';'LMT';'DHR';'CAT';'FDX';'GD'};
    portfolio.materials = {'DOW';'DD';'MON';'PX';'ECL';'PPG';'LYB';'APD';'SHW';'IP'; 'FCX'; 'VMC'};
    portfolio.utilities = {'NEE';'DUK';'SO';'D';'AEP';'EXC';'PCG';'PPL';'SRE';'PEG';'EIX';'ED'};
    portfolio.technology = {'AAPL'; 'MSFT'; 'FB'; 'T'; 'GOOGL'; 'GOOG'; 'VZ'; 'INTC'; 'V'; 'CSCO'; 'IBM'; 'ACN'};
    
    
    if FETCH == 1
        
        c = yahoo;
        
        dSP = fetch(c,'^GSPC',past, simulateTo, 'd');
       
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
                
                dAll.(stockName) = fetch(c,stock,past, simulateTo, 'd');
                wAll.(stockName) = fetch(c,stock,past, simulateTo, 'w');
                mAll.(stockName) = fetch(c,stock,past, simulateTo, 'm');
                
                beta.(stockName) = ta.calcBeta(dAll.(stockName), dSP);
            end
            
            close(c);
        end
        
        save(strcat('portfolio', 'Data'), 'portfolio', 'mAll', 'wAll', 'dAll', 'beta');
    else
        load('portfolioData')
    end
    
end


primaryRange = simFrom:simTo;

p = 0;

figure(1)
% set(gcf, 'Position', [-1080,1,1079,1824]);
set(gcf, 'Position', [1388,185,680,620]);

subplot(3,2,1)
figure(2)
% set(gcf, 'Position', [-1080,1,1079,1824]);
set(gcf, 'Position', [2068,181,703,624]);

subplot(3,2,1)
figure(3)
[hiA, loA, clA, opA, daA] = tf.returnOHLCDarray(wAll.GSPC);
hl = highlow(hiA, loA, opA, clA, 'red', daA);
hp = 0;
hold on;
figure(4)

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
        
        
        if get(handles.M, 'Value')
            set(handles.axisLen,'Value', 800);
            period = 'm';
            [primaryRange, secondaryRange, primaryDates, secondaryDates] = td.setRanges(handles, mAll);
            primaryRange = primaryRange(2:end);
            secondaryRange = secondaryRange(2:end);
            stockData = mAll.(stock)(primaryRange,:);
            avgData = mAll.(idx)(primaryRange,:);
            stockData2 = mAll.(stock)(secondaryRange,:);
            avgData2 = mAll.(idx)(secondaryRange,:);    
        elseif get(handles.W, 'Value')
            period = 'w';
            set(handles.axisLen,'Value', 200);
            [primaryRange, secondaryRange, primaryDates, secondaryDates] = td.setRanges(handles, wAll);
            primaryRange = primaryRange(2:end);
            secondaryRange = secondaryRange(2:end);
            stockData = wAll.(stock)(primaryRange,:);
            avgData = wAll.(idx)(primaryRange,:);
            stockData2 = wAll.(stock)(secondaryRange,:);
            avgData2 = wAll.(idx)(secondaryRange,:);
        else 
            period = 'd';
            set(handles.axisLen,'Value', 50);
            [primaryRange, secondaryRange, primaryDates, secondaryDates] = td.setRanges(handles, dAll);
            primaryRange = primaryRange(1:end);
            secondaryRange = secondaryRange(1:end);
            stockData = dAll.(stock)(primaryRange,:);
            avgData = dAll.(idx)(primaryRange,:);
            stockData2 = dAll.(stock)(secondaryRange,:);
            avgData2 = dAll.(idx)(secondaryRange,:);
        end
        
        set(handles.date, 'String', datestr(stockData(1,1),2));
        
        stockBeta = beta.(stock); % Calc beta on the fly
        [hi, lo, cl, op, da] = tf.returnOHLCDarray(stockData);
        
        if i ~= 13
            subplot(3,2,j)
        end
        cla
        hold on
        
        if get(handles.standardize, 'Value')
            set(handles.movingAverage, 'Value',0);
            [stockStandardCl, avgStandardCl, rawStandardCl] = ta.getMovingStandard(stockData, avgData, windSize, true);
            [stockStandardCldw] = ta.getMovingStandard(stockData, avgData, windSize*2, true);
            
            plot(da, stockStandardCl, 'r', 'Marker', '.');
            plot(da, stockStandardCldw, 'm', 'Marker', '.');
            plot(da, avgStandardCl, 'b', 'Marker', '.');
            plot(da, rawStandardCl, 'k', 'Marker', '.');
%             tick_index = 1:10:length(da); % checks length of the dates with 10 steps in between.
%             tick_label = datestr(da(tick_index), 6); % this is translated to a datestring.
%             %Now we tell the x axis to use the parameters set before.
%             set(gca,'XTick',tick_index);
            
            if get(handles.accessSecondary, 'Value')
                [stockStandard2Cl, avgStandard2Cl, rawStandard2Cl] = ta.getStandardized(stockData2, avgData2, windSize);
            
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
        
        
        if get(handles.corr, 'Value')
            [R] = ta.getCorr(stockData, avgData, windSize);
            plot(da, R, 'k', 'Marker', '.');
        end 
        
        if get(handles.hiLo, 'Value')
            highlow(hi, lo, lo, hi, 'red', da);
        elseif get(handles.ohlc, 'Value')
            highlow(hi, lo, op, cl, 'red', da);
        end
        
        
        ref = get(handles.ref, 'Value');
        ylimit = ylim;
        plot([ref, ref], [ylimit(1), ylimit(2)], 'c');
        
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
    
    
    p4 = 0;
    names = [];
    set(0,'CurrentFigure',4)
    hold off all
    cla
    hold all
    for i = 1:12
        stock = portfolio.(market){i};
        if strcmp(period, 'm')
            stockData = mAll.(stock)(primaryRange,:);
        elseif strcmp(period, 'w')
            stockData = wAll.(stock)(primaryRange,:);
        else
            stockData = dAll.(stock)(primaryRange,:);
        end
        [hi, lo, cl, op, da] = tf.returnOHLCDarray(stockData);
        
        
        if get(handles.RSIcong, 'Value')
            set(handles.movingAverage, 'Value',0);
            [RSI, RSIma] = ta.getRSI(stockData, avgData, windSize);
            p4(i) = plot(da,RSIma+i*.5, 'color', randColors(i,:), 'Marker', '.');
        end 
        
        if  get(handles.corrCong, 'Value')
            [R] = ta.getCorr(stockData, avgData, windSize);
            p4(i) = plot(da, R+i*1.5, 'color', randColors(i,:), 'Marker', '.');
        end
        
            
        if get(handles.standardizeCong, 'Value')
            [stockStandardCl, avgStandardCl, rawStandardCl] = ta.getStandardized(stockData, avgData, windSize);
            [stockStandardCldw] = ta.getStandardized(stockData, avgData, windSize*2);
            
            p4(i) = plot(da, stockStandardCl+i, 'color', randColors(i,:), 'Marker', '.');
            plot(da, stockStandardCldw+i, 'color', randColors(i,:), 'Marker', '.');
            
        end
        names = [names; {stock}];
        xlim([primaryDates(1), primaryDates(2)+10]);
        
    end
    
    
    
    if p4 ~= 0 & ishandle(p4)
        legend(p4, names, 'Location', 'bestoutside');
    end
    
    ref = get(handles.ref, 'Value');
    ylimit = ylim;
    plot([ref, ref], [ylimit(1), ylimit(2)], 'c');
    
    
    
    pause(0.1)
    
    
end






% % % % subplot margin

% pos = get(gca, 'Position');
% pos(1) = 0.055;
% pos(3) = 0.9;
% set(gca, 'Position', pos)

% % % %















