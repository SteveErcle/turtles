% turtleSim
clear all
close all
clc


gain = 4;
price = 100;
A = 1000;
B = 1000;
M = 0;

figure()
allPrice = [];
capital = 0;
s=0;
b=0;
for i = 1:100
    
    
    i
    
    if s <= b
        s = input('s: ');
        A = A-s;
    end
    
%     b = input('b: ')
b = rand(1)*15

    M = M + s-b
    
   
    B = B+b;
    
    if s>=b
        s = s-b;
        capital = capital+price*b
    else
        capital = capital+price*s
        s = 0;
    end
    
%     display([s,b,M]);
%     display([A,B]);
    
    equl = -M/(A+B+M);
    
    rateOfChange = equl;
    price = price*(1+rateOfChange)
    
    
    
    vol = min(s,b);
    
    allPrice = [allPrice; price];
    plot(allPrice);
    %     hold on
    %     plot(vol,'g')
    
    
end




% insiderNumShares = 1000;
% publicNumShares = 1000;
%
% totalShares = insiderNumShares + publicNumShares;
%
%
% insider = Shark(insiderNumShares);
% public = Shark(publicNumShares);
%
%
% seaTurtle = TurtleMarket(totalShares, 100);
%
%
% price = 100;
%
%
%     x = input('insider sell')
%     y = input('public buy')
%     insider = insider.sellOrder(x);
%     public = public.buyOrder(y);
%
%     sellOrders = insider.sell;
%     buyOrders = public.buy;
%
%
%     equl = (insider.hold+public.hold)/2;
%
%     if sellOrders >= buyOrders
%         rateOfChange = (sellOrders+equl)/(buyOrders+equl);
%         price = price-rateOfChange;
%
%         returnOrderToSeller = sellOrders-buyOrders;
%         insider.sell = returnOrderToSeller;
%
%     end
%
%
%
%
%
%
%
% %     [seaTurtle, insider, public] = seaTurtle.equalizeMarket(insider, public)
%
%
% % price = 100;
% %
% % sellOrders = 500;
% %
% % buyOrders = 100;
% %
% % equl = (insider+public)/2;
% %
% %
% % if sellOrders >= buyOrders
% %     rateOfChange = (sellOrders+equl)/(buyOrders+equl);
% %     price = price-rateOfChange
% %     sellOrders = sellOrders-buyOrders
% %     buyOrders = buyOrders - buyOrders;
% % else
% %     rateOfChange = (buyOrders+equl)/(sellOrders+equl);
% %     price = price+rateOfChange
% %     buyOrders = buyOrders - sellOrders
% %     sellOrders = sellOrders-sellOrders
% % end
%
%
