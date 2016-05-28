
clc; close all; clear all;
format long g

ttAS = TurtleTCP(3000);
ttPA = TurtleTCP(3001);


ttAS.connect()
ttPA.connect()

for hide_init = 1:1
    
    accumSpread = [];
    accumSpread.sum = 0;
    accumSpread.total = [];
    accumSpread.time = [];
    accumSpread.minute = [];
    
    accumSpread.op = [0;0];
    accumSpread.hi = [0;0];
    accumSpread.lo = [0;0];
    accumSpread.cl = [0;0];
    accumSpread.ti = [0;0];
    accumSpread.mi = [0;0];
    
    priceAction = [];
    priceAction.time = [];
    priceAction.price = [];
    priceAction.minute = [];
    
    priceAction.op = [];
    priceAction.hi = [];
    priceAction.lo = [];
    priceAction.cl = [];
    priceAction.ti = [];
    priceAction.mi = [];
    
end

figure
prevLen = 0;

while(true)
    
    accumSpread = ttAS.readInAllDataAS(4, 'double', accumSpread);
    
    
    priceAction = ttPA.readInAllDataPA(4, 'double', priceAction);
    

    len = length(accumSpread.hi);
    
    
%     if len > 3 & len ~= prevLen
%         set(0, 'CurrentFigure', 1);
pause(1/10)
        cla
        candle(accumSpread.hi, accumSpread.lo , accumSpread.cl, accumSpread.op, 'blue') %accumSpread.ti);
%         
%         prevLen = len;
%     end
    
    %      
    
    %             cla
    %             candle(hi.AS, lo.AS, cl.AS, op.AS, 'blue', ti.AS);
%               candle(priceAction.hi, priceAction.lo , priceAction.cl, priceAction.op, 'blue', priceAction.ti);
    %         ax = gca;
    %
    %         set(ax,'XTick',char(unqT));
end




