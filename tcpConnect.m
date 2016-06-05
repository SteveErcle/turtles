
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
    accumSpread.ask = zeros(10,2);
    accumSpread.bid = zeros(10,2);
    
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
    
    
    spreadSentiment.op = [];
    spreadSentiment.hi = [];
    spreadSentiment.lo = [];
    spreadSentiment.cl = [];
    spreadSentiment.total = [];
    spreadSentiment.minute = [];
    
end

figure
figure
prevLen = 0;

while(true)
    
    accumSpread = ttAS.readInAllDataAS(4, 'double', accumSpread);
    
    
    priceAction = ttPA.readInAllDataPA(4, 'double', priceAction);
    
    
    bidSentiment = sum(accumSpread.bid(:,1).*accumSpread.bid(:,2))/ sum(accumSpread.bid(:,2));
    askSentiment = sum(accumSpread.ask(:,1).*accumSpread.ask(:,2))/ sum(accumSpread.ask(:,2));
    
    
    xLo.bid = bidSentiment*.9999; xHi.bid = bidSentiment;
    yLo.bid = 0; yHi.bid = sum(accumSpread.bid(:,2));
    
    x.bid = [xLo.bid xHi.bid xHi.bid xLo.bid];
    y.bid = [yLo.bid yLo.bid yHi.bid yHi.bid];
    
    xLo.ask = askSentiment; xHi.ask = askSentiment*1.0001;
    yLo.ask = 0; yHi.ask = sum(accumSpread.ask(:,2));
    
    x.ask = [xLo.ask xHi.ask xHi.ask xLo.ask];
    y.ask = [yLo.ask yLo.ask yHi.ask yHi.ask];
    
    topSize = sum(accumSpread.ask(:,2))*1.05;
    
    
    spreadSentiment.minute = [spreadSentiment.minute; {datestr(now,15)}];
    %     sSent = (bidSentiment / (sum(accumSpread.bid(:,2))) * 1000000 * -1) +...
    %         (askSentiment / (sum(accumSpread.ask(:,2))) * 1000000)
    
    if ~isempty(priceAction.price)
        
        sSent = ((bidSentiment - priceAction.price(end,4)) + (askSentiment - priceAction.price(end,4))) * 1000000;
        spreadSentiment.total = [spreadSentiment.total; sSent];
    
    end
    
  
    
    unqT = unique(spreadSentiment.minute);
    
    if length(unqT) > 1
        
        spreadSentiment.op = [spreadSentiment.op; spreadSentiment.total(1)];
        spreadSentiment.hi = [spreadSentiment.hi; max(spreadSentiment.total(1:end-1))];
        spreadSentiment.lo = [spreadSentiment.lo; min(spreadSentiment.total(1:end-1))];
        spreadSentiment.cl = [spreadSentiment.cl; spreadSentiment.total(end-1)];
        
        spreadSentiment.total(1:end-1) = [];
        spreadSentiment.minute(1:end-1,:) = [];
        
    end
    
    
    if ~isempty(priceAction.price)
        
        set(0,'CurrentFigure', 1)
        title(num2str(sSent))
        cla
        plot([priceAction.price(end), priceAction.price(end)], [0,topSize])
        hold on;
        
        hp = patch(x.bid, y.bid, [0.5,1,.5]);
        hp = patch(x.ask, y.ask, [1,.5,.5]);
    end
    
    if ~isempty(spreadSentiment.op)
        
        set(0,'CurrentFigure', 2)
        cla
        candle(spreadSentiment.hi, spreadSentiment.lo , spreadSentiment.cl, spreadSentiment.op, 'blue');
    end
    
    pause(1/100)
    
    %     len = length(accumSpread.hi);
    
    %     if len > 3 & len ~= prevLen
    %         set(0, 'CurrentFigure', 1);
    
    %     candle(accumSpread.hi, accumSpread.lo , accumSpread.cl, accumSpread.op, 'blue') %accumSpread.ti);
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




