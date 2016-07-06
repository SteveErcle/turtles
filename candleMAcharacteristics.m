% auto_goog_testForRealTime

clc; close all; clear all;

as1 = ['A',num2str(1)];%1
as2 = ['A',num2str(400)];%400
[~,allStocks] = xlsread('listOfStocks', [as1, ':', as2]);
allStocks = allStocks(10)

td = TurtleData;
ta = TurtleAuto;

exchange = 'NASDAQ';
lenOfData = '50d';

numPlots = 5;

PULL = 1;

if PULL == 1
    for k = 0:length(allStocks)
        
        pause(1)
        
        if k == 0
            stock = 'SPY'
            allData.SPY = IntraDayStockData(stock,exchange,'600',lenOfData);
            allData.SPY = td.getAdjustedIntra(allData.SPY);
            
        else
            stock = allStocks{k}
            try
                temp = IntraDayStockData(stock,exchange,'600',lenOfData);
                
                %         for i_d = 1:length(iAll.INDX.date)
                %             if iAll.STOCK.date(i_d) ~= iAll.INDX.date(i_d)
                %                 iAll.STOCK.close = [iAll.STOCK.close(1:i_d-1); NaN; iAll.STOCK.close(i_d:end)];
                %                 iAll.STOCK.high = [iAll.STOCK.high(1:i_d-1); NaN; iAll.STOCK.high(i_d:end)];
                %                 iAll.STOCK.low = [iAll.STOCK.low(1:i_d-1); NaN; iAll.STOCK.low(i_d:end)];
                %                 iAll.STOCK.volume = [iAll.STOCK.volume(1:i_d-1); NaN; iAll.STOCK.volume(i_d:end)];
                %                 iAll.STOCK.datestring = [iAll.STOCK.datestring(1:i_d-1); NaN; iAll.STOCK.datestring(i_d:end)];
                %                 iAll.STOCK.date = [iAll.STOCK.date(1:i_d-1); NaN; iAll.STOCK.date(i_d:end)];
                %             end
                %         end
                
                temp = td.getAdjustedIntra(temp);
                
                if length(temp.close) ~= length(allData.SPY.close)
                    disp('Length Error')
                else
                    allData.(stock) = temp;
                end
                
            catch
                disp('Failed to pull stock data')
            end
        end
    end
else
    load('allData')
end

% fields = fieldnames(allData);
% stock = fields{10}
% temp.STOCK = allData.(stock);
% temp.INDX = allData.SPY;
% clear allData;
% allData = [];
% allData.SPY = temp.INDX;
% allData.(stock) = temp.STOCK;

range = 1:length(allData.(stock).close);
ta.ind = range(end);
ta.organizeDataGoog(allData.(stock), allData.SPY, range);
ta.setStock(stock);
ta.calculateData(0);

aboves = [];
unders = [];

characteristic.aboves.volume = [];
characteristic.aboves.support= [];
characteristic.aboves.support_1 = [];
characteristic.aboves.support_2 = [];
characteristic.aboves.open = [];
characteristic.aboves.close = [];

characteristic.aboves.volumeIndx = [];
characteristic.aboves.supportIndx = [];
characteristic.aboves.support_1Indx = [];
characteristic.aboves.support_2Indx = [];
characteristic.aboves.openIndx = [];

characteristic.unders.volume = [];
characteristic.unders.support = [];
characteristic.unders.support_1 = [];
characteristic.unders.support_2 = [];
characteristic.unders.open = [];
characteristic.unders.close = [];

characteristic.unders.volumeIndx = [];
characteristic.unders.supportIndx = [];
characteristic.unders.support_1Indx = [];
characteristic.unders.support_2Indx = [];
characteristic.unders.openIndx = [];

characteristic.aboves.B = [];
characteristic.aboves.BIndx = [];
characteristic.unders.B = [];
characteristic.unders.BIndx = [];


for i = 2:range(end)
    if ta.lo.STOCK(i) < ta.clSma(i) && ta.op.STOCK(i) > ta.clSma(i)...
            && ta.cl.STOCK(i-1) > ta.clSma(i-1)...
            && ~strcmp(datestr(ta.da.STOCK(i),15), '15:50')...
            && ~strcmp(datestr(ta.da.STOCK(i),15), '09:30')...
       
        if ta.cl.STOCK(i) >= ta.clSma(i)
            aboves = [aboves; i, ta.hi.STOCK(i)*1.001];
            
            characteristic.aboves.volume(end+1) = ta.vo.STOCK(i-1)/mean(ta.vo.STOCK);
            characteristic.aboves.volumeIndx(end+1) = ta.vo.INDX(i-1)/mean(ta.vo.INDX);
            
            characteristic.aboves.support(end+1) =  (ta.lo.STOCK(i) - ta.clSma(i))/ ta.clSma(i) * 100;
            characteristic.aboves.support_1(end+1) =  (ta.lo.STOCK(i-1) - ta.clSma(i-1))/ ta.clSma(i-1) * 100;
            characteristic.aboves.support_2(end+1) =  (ta.lo.STOCK(i-2) - ta.clSma(i-2))/ ta.clSma(i-2) * 100;
            
            characteristic.aboves.supportIndx(end+1) =  (ta.lo.INDX(i) - ta.clAma(i))/ ta.clAma(i) * 100;
            characteristic.aboves.support_1Indx(end+1) =  (ta.lo.INDX(i-1) - ta.clAma(i-1))/ ta.clAma(i-1) * 100;
            characteristic.aboves.support_2Indx(end+1) =  (ta.lo.INDX(i-2) - ta.clAma(i-2))/ ta.clAma(i-2) * 100;
            
            characteristic.aboves.open(end+1) =   abs(ta.op.STOCK(i) - ta.clSma(i-1))/ ta.clSma(i-1) * 100;
            characteristic.aboves.openIndx(end+1) =   abs(ta.op.INDX(i) - ta.clAma(i-1))/ ta.clAma(i-1) * 100;
        
            characteristic.aboves.close(end+1) = (ta.cl.STOCK(i) - ta.clSma(i))/ ta.clSma(i) * 100;
           
            characteristic.aboves.B(end+1) = (ta.B.STOCK(i-1));
            characteristic.aboves.BIndx(end+1) = (ta.B.INDX(i-1));
            
            
            
        else
            unders = [unders; i, ta.hi.STOCK(i)*1.001];
            characteristic.unders.volume(end+1) = ta.vo.STOCK(i-1)/mean(ta.vo.STOCK);
            characteristic.unders.volumeIndx(end+1) = ta.vo.INDX(i-1)/mean(ta.vo.INDX);
            
            characteristic.unders.support(end+1) =  (ta.lo.STOCK(i) - ta.clSma(i))/ ta.clSma(i) * 100;
            characteristic.unders.support_1(end+1) =  (ta.lo.STOCK(i-1) - ta.clSma(i-1))/ ta.clSma(i-1) * 100;
            characteristic.unders.support_2(end+1) =  (ta.lo.STOCK(i-2) - ta.clSma(i-2))/ ta.clSma(i-2) * 100;
            
            characteristic.unders.supportIndx(end+1) =  (ta.lo.INDX(i) - ta.clAma(i))/ ta.clAma(i) * 100;
            characteristic.unders.support_1Indx(end+1) =  (ta.lo.INDX(i-1) - ta.clAma(i-1))/ ta.clAma(i-1) * 100;
            characteristic.unders.support_2Indx(end+1) =  (ta.lo.INDX(i-2) - ta.clAma(i-2))/ ta.clAma(i-2) * 100;
            
            characteristic.unders.open(end+1) =   (ta.op.STOCK(i) - ta.clSma(i-1))/ ta.clSma(i-1) * 100;
            characteristic.unders.openIndx(end+1) =   (ta.op.INDX(i) - ta.clAma(i-1))/ ta.clAma(i-1) * 100;
            
            characteristic.unders.close(end+1) = (ta.cl.STOCK(i) - ta.clSma(i))/ ta.clSma(i) * 100;
            
            characteristic.unders.B(end+1) = (ta.B.STOCK(i-1));
            characteristic.unders.BIndx(end+1) = (ta.B.INDX(i-1));
            
        end
        
        
    end
end


clSort = sortrows(characteristic.aboves.close',-1);

found = [];
for i = 1:10
   found(end+1) = find(clSort(i) == characteristic.aboves.close');
end




field = fieldnames(characteristic.aboves);

for j = 1:length(field)
    
    figure(j)
    hold on;
    
    plot(1,characteristic.aboves.(field{j}), 'go')
    plot(1,mean(characteristic.aboves.(field{j})), 'bx')
    plot(1,mean(characteristic.aboves.(field{j})(found)), 'bo')
    text(1,mean(characteristic.aboves.(field{j})), num2str(mean(characteristic.aboves.(field{j}))))
    text(1,mean(characteristic.aboves.(field{j})(found)), num2str(mean(characteristic.aboves.(field{j})(found))))
    
    plot(2,characteristic.unders.(field{j}), 'ro')
    plot(2,mean(characteristic.unders.(field{j})(~isnan(characteristic.unders.(field{j})))), 'bx')
    text(2,mean(characteristic.unders.(field{j})), num2str(mean(characteristic.unders.(field{j}))))
   
    xlim([0,3])
    title(field(j))

    
end


figure(j+1)


subplot(numPlots,1,[1:2])
cla
candle(ta.hi.STOCK, ta.lo.STOCK, ta.cl.STOCK, ta.op.STOCK, 'blue');
hold on
plot(ta.clSma,'b')
plot(aboves(:,1), aboves(:,2),'gx')
plot(unders(:,1), unders(:,2),'rx')
plot(aboves(found,1), aboves(found,2), 'cx')

subplot(numPlots,1,3)
cla
candle(ta.hi.INDX, ta.lo.INDX, ta.cl.INDX, ta.op.INDX, 'red');
hold on
plot(ta.clAma,'r')

subplot(numPlots,1,4)
cla
bar(ta.vo.STOCK)
hold on
plot(xlim, [mean(ta.vo.STOCK), mean(ta.vo.STOCK)])

subplot(numPlots,1,5)
cla
bar(ta.vo.INDX)
hold on
plot(xlim, [mean(ta.vo.INDX), mean(ta.vo.INDX)])








