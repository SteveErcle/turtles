% intraDayPractice

clc; close all; clear all;

delete(intraDayGui);
handles = guihandles(intraDayGui);


stockList = {'AMRN', 'NETE', 'XCO', 'SPY'};
% stockList = {'AMRN'};
dateSelected = '04/12/16';
LEVELS = 0;
view = 14;

exchange = 'NASDAQ';


set(handles.enterList, 'String', stockList);
td = TurtleData;
tf = TurtleFun;
ta = TurtleAnalyzer;

for i_setCharts = 1:length(stockList)
    
    stock = stockList{i_setCharts}
    
    c = yahoo;
    dAll.(stock) = fetch(c,stock,datenum(dateSelected)-170, dateSelected, 'd');
    close(c)
    
    thirtyAll.(stock) = IntraDayStockData(stock,exchange,'1800','100d');
    fiveAll.(stock) = IntraDayStockData(stock,exchange,'300','100d');
    
    uniqueDates = unique(datenum(datestr(thirtyAll.(stock).date,2)));
    simYesterday = find(datenum(dateSelected) == uniqueDates)-1;
    
    hi.(stock) = []; lo.(stock) = []; cl.(stock) = []; op.(stock) = [];
    
    for i = simYesterday - view : simYesterday
        
        datePulled = datestr(uniqueDates(i),2);
        thirty.(stock) = td.getIntraForDate(thirtyAll.(stock), datePulled);
        thirty.(stock) = td.getAdjustedIntra(thirty.(stock));
        
        hi.(stock) = [hi.(stock); thirty.(stock).high];
        lo.(stock) = [lo.(stock); thirty.(stock).low];
        cl.(stock) = [cl.(stock); thirty.(stock).close];
        op.(stock) = [op.(stock); thirty.(stock).open];
        
    end
    
    
    thirty.(stock) = td.getIntraForDate(thirtyAll.(stock), dateSelected);
    thirty.(stock) = td.getAdjustedIntra(thirty.(stock));
    five.(stock) = td.getIntraForDate(fiveAll.(stock), dateSelected);
    five.(stock) =  td.getAdjustedIntra(five.(stock));
    
    hiHold.(stock) = hi.(stock);
    loHold.(stock) = lo.(stock);
    clHold.(stock) = cl.(stock);
    opHold.(stock) = op.(stock);
    
    figure
    subplot(2,1,1)
    hold on
    [hiD.(stock), loD.(stock), clD.(stock), opD.(stock), daD.(stock)] = tf.returnOHLCDarray(dAll.(stock)(2:end,:));
    candle(hiD.(stock), loD.(stock), clD.(stock), opD.(stock), 'blue', daD.(stock));
    title({stock});
    
    subplot(2,1,2)
    candle(hi.(stock), lo.(stock), cl.(stock), op.(stock), 'blue')
    title({stock});
    hold on
    xlimits.(stock) = xlim;
    
    levels.(stock) = [];
    trade.(stock) = [];
    reset.(stock) = -1;
    
end


if LEVELS == 1
    
     for j = 1:length(stockList)
         
         stock = stockList{j};
         
         stockData = [dAll.(stock)(:,2); dAll.(stock)(:,3); dAll.(stock)(:,4); dAll.(stock)(:,5)];
         prelimLevels.(stock) = ta.getLevels(stockData);
         stockData = [hiHold.(stock); loHold.(stock); clHold.(stock)];
         prelimLevels.(stock) = [prelimLevels.(stock); ta.getLevels(stockData)];
         
         set(0, 'CurrentFigure',j)
         
         for k = 1:2
             subplot(2,1,k)
             xlimit = xlim;
             
             for i = 1:length(prelimLevels.(stock))
                 plot([xlimit(1), xlimit(2)], [prelimLevels.(stock)(i), prelimLevels.(stock)(i)], 'color', [0.70,0.70,0.70]);
             end
         end
         
         
     end 
    
    while (~get(handles.next,'Value'))
        
        for j = 1:length(stockList)
            
            stock = stockList{j};
            
            set(0, 'CurrentFigure',j)
            h = gcf;
            axesObjs = get(h, 'Children');
            axesObjs = findobj(axesObjs, 'type', 'axes');
            
            dataTips = findall(axesObjs, 'Type', 'hggroup', 'HandleVisibility', 'off');
            
            if length(dataTips) > 0
                
                cursor = datacursormode(gcf);
                dateOnPlot = cursor.CurrentDataCursor.getCursorInfo.Position(1)
                value = cursor.CurrentDataCursor.getCursorInfo.Position(2)
                levels.(stock) = [levels.(stock); value];
                
                
                set(0, 'CurrentFigure',j)
                subplot(2,1,1)
                plot([daD.(stock)(end), daD.(stock)(1)], [value, value], 'k')
                subplot(2,1,2)
                plot([xlimits.(stock)(1), xlimits.(stock)(2)], [value, value], 'k')
                
                delete(dataTips);
            end
        end
        pause(0.1);
    end
    set(handles.next,'Value', 0);
    try save('levels','levels'); catch, disp('Failed to save levels'); end
else
    try load('levels'); catch, disp('Failed to load levels'); end
end


for i = 1:length(five.(stock).date)
    
    
    for j = 1:length(stockList)
        
        stock = stockList{j}
        
        five.(stock).datestring(i)
        
        finished30.(stock) = max(find(five.(stock).date(i) >= thirty.(stock).date)) - 1;
        
        if isempty(finished30.(stock))
            finished30.(stock) = 0;
        end
        
        if reset.(stock) ~= finished30.(stock)
            curHi.(stock) = five.(stock).high(i);
            curLo.(stock) = five.(stock).low(i);
            curOp.(stock) = five.(stock).open(i);
            reset.(stock) = finished30.(stock);
        end
        
        if (five.(stock).high(i) > curHi.(stock)), curHi.(stock) = five.(stock).high(i); end
        if (five.(stock).low(i) > curLo.(stock)), curLo.(stock) = five.(stock).low(i); end
        curCl.(stock) = five.(stock).close(i);
        
        hi.(stock) = [hiHold.(stock); thirty.(stock).high(1:finished30.(stock)); curHi.(stock)];
        lo.(stock) = [loHold.(stock); thirty.(stock).low(1:finished30.(stock)); curLo.(stock)];
        cl.(stock) = [clHold.(stock); thirty.(stock).close(1:finished30.(stock)); curCl.(stock)];
        op.(stock) = [opHold.(stock); thirty.(stock).open(1:finished30.(stock)); curOp.(stock)];
        
        
        set(0, 'CurrentFigure',j);
        subplot(2,1,2)
        cla
        candle(hi.(stock), lo.(stock), cl.(stock), op.(stock), 'blue')
        hold on
        xlimits.(stock) = xlim;
        for k = 1:length(levels.(stock))
            plot([xlimits.(stock)(1), xlimits.(stock)(2)], [levels.(stock)(k), levels.(stock)(k)], 'k')
        end
        
        if ~isempty(trade.(stock))
            for k = 1:size(trade.(stock),1)
                plot(trade.(stock)(k,1)+0.3, trade.(stock)(k,2), 'gx');
            end
        end
        
    end
    
    
    
    while (~get(handles.next,'Value'))
        if get(handles.execute, 'Value')
            enterList = get(handles.enterList, 'String');
            enterIndx = get(handles.enterList, 'Value');
            enterSelected = enterList{enterIndx};
            trade.(enterSelected) = [trade.(enterSelected); length(cl.(enterSelected)), cl.(enterSelected)(end)];
            set(handles.execute, 'Value', 0);
        end
        
        pause(0.1);
    end
    
    set(handles.next,'Value', 0);
    
    
end



