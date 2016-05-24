
clc; close all; clear all;


tt = TurtleTCP(3000);

tt.connect()

data = [];
ask = [];
bid = [];
ask.price   = [];
ask.size    = [];
ask.time    = [];
bid.price   = [];
bid.size    = [];
bid.time    = [];
accumSpread = [];
accumSpread.sum = 0;
accumSpread.total = [];
accumSpread.time = [];
accumSpread.minute = [];
% data.position = [];
% data.side = [];
% data.price = [];
% data.size = [];
op = [];
hi = [];
lo = [];
cl = [];
ti = [];
mi = [];
figure

dataCong = [];

while(true)
    
    dataNow = tt.readInData(4, 'double');
    
%     dataCong = [dataCong; dataNow'];
    
end 

return

while(true)
    
    dataNow = tt.readInData(4, 'double');
    
    if ~isempty(dataNow)
        data.position   = dataNow(1);
        data.side       = dataNow(2);
        data.price      = dataNow(3);
        data.size       = dataNow(4)/10000;
        
%         if data.side == 0
%             ask.price = [ask.price; data.price];
%             ask.size = [ask.size; data.size];
%             ask.time = [ask.time; {datestr(now,15)}];
%         elseif data.side == 1
%             bid.price = [bid.price; data.price];
%             bid.size = [bid.size; data.size];
%             bid.time = [bid.time; {datestr(now,15)}];
%         end
        
        if data.side == 0
            accumSpread.sum = accumSpread.sum - data.price*data.size
            accumSpread.total = [accumSpread.total; accumSpread.sum];
        elseif data.side == 1
            accumSpread.sum = accumSpread.sum + data.price*data.size
            accumSpread.total = [accumSpread.total; accumSpread.sum];
        end
        
        accumSpread.time = [accumSpread.time; now];
        accumSpread.minute = [accumSpread.minute; {datestr(now,15)}];
        
        
        unqT = unique(accumSpread.minute)
        if length(unqT) > 1
            tic
            
            for i = 1:1 %length(unqT)
                thisT = unqT(i);
                indxAS = strmatch(thisT, accumSpread.minute);
                op = [op; accumSpread.total(indxAS(1))];
                hi = [hi; max(accumSpread.total(indxAS))];
                lo = [lo; min(accumSpread.total(indxAS))];
                cl = [cl; accumSpread.total(indxAS(end))];
                ti = [ti; accumSpread.time(1)];
                mi = [mi; accumSpread.minute(1)];
            end
            toc
            
            accumSpread.total = [];
            accumSpread.time = [];
            accumSpread.minute = [];
%             cla
%             candle(hi, lo, cl, op, 'blue', ti);
            %         ax = gca;
            %
            %         set(ax,'XTick',char(unqT));
        end
        
        
        
    end
    
    
    
end