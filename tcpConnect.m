
clc; close all; clear all;


ttAS = TurtleTCP(3000);
ttPA = TurtleTCP(3001);


ttAS.connect()
ttPA.connect()

for hide_init = 1:1
    
    priceAction = [];
    priceAction.price = [];
    priceAction.time = [];
    priceAction.minute = [];
    accumSpread = [];
    accumSpread.sum = 0;
    accumSpread.total = [];
    accumSpread.time = [];
    accumSpread.minute = [];
    
    op.AS = [];
    hi.AS = [];
    lo.AS = [];
    cl.AS = [];
    ti.AS = [];
    mi.AS = [];
    
    op.PA = [];
    hi.PA = [];
    lo.PA = [];
    cl.PA = [];
    ti.PA = [];
    mi.PA = [];
    
end


while(true)
    
   accumSpread = ttAS.readInAllDataAS(4, 'double', accumSpread);
   
%    pause(2);
   
   priceAction = ttPA.readInAllDataPA(1, 'double', priceAction);

%     if ~isempty(dataAS)
%         data.position   = dataAS(1);
%         data.side       = dataAS(2);
%         data.price      = dataAS(3);
%         data.size       = dataAS(4)/10000;
%         
%         if data.side == 0
%             accumSpread.sum = accumSpread.sum - data.price*data.size
%             accumSpread.total = [accumSpread.total; accumSpread.sum];
%         elseif data.side == 1
%             accumSpread.sum = accumSpread.sum + data.price*data.size
%             accumSpread.total = [accumSpread.total; accumSpread.sum];
%         end
%         
%         accumSpread.time = [accumSpread.time; now];
%         accumSpread.minute = [accumSpread.minute; {datestr(now,15)}];
%         
%     end
    
%     if ~isempty(dataPA)
%         priceAction.price = [priceAction.price; dataPA];
%         priceAction.time = [priceAction.time; now];
%         priceAction.minute = [priceAction.minute; {datestr(now,15)}];
%     end
%     
%     unqT = unique(accumSpread.minute);
%     
%     if length(unqT) > 1
%         
%         thisT = unqT(i);
%         
%         indxAS = strmatch(thisT, accumSpread.minute);
%         op.AS = [op.AS; accumSpread.total(indxAS(1))];
%         hi.AS = [hi.AS; max(accumSpread.total(indxAS))];
%         lo.AS = [lo.AS; min(accumSpread.total(indxAS))];
%         cl.AS = [cl.AS; accumSpread.total(indxAS(end))];
%         ti.AS = [ti.AS; accumSpread.time(1)];
%         mi.AS = [mi.AS; accumSpread.minute(1)];
%         
%       
%         indxPA = strmatch(thisT, priceAction.minute);
%         op.PA = [op.PA; priceAction.price(indxPA(1))];
%         hi.PA = [hi.PA; max(priceAction.price(indxPA))];
%         lo.PA = [lo.PA; min(priceAction.total(indxPA))];
%         cl.PA = [cl.PA; priceAction.price(indxPA(end))];
%         ti.PA = [ti.PA; priceAction.time(1)];
%         mi.PA = [mi.PA; priceAction.minute(1)];
%         
%       
%         accumSpread.total = [];
%         accumSpread.time = [];
%         accumSpread.minute = [];
%         
%         priceAction.time = [];
%         priceAction.minute = [];
        
        
        %             cla
        %             candle(hi, lo, cl, op, 'blue', ti);
        %         ax = gca;
        %
        %         set(ax,'XTick',char(unqT));
%     end
    
    
    
    
    
end