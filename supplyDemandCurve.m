clc; clear all; close all;



A = 0;
B = 0;

capital = 0;
price = 100;
allPrice = [];

supply = 0;
demand = 0;


% for i = 1:50
%     s = input('s: ')
%     b = 10;
%     
%     supply = supply + s;
%     demand = demand + b;
%     
%     equl = (demand-supply)/(20000);
%     
%     rateOfChange = equl;
%     price = price*(1+rateOfChange);
%     
%     allPrice = [allPrice; price];
%     plot(allPrice);
%     
%     if supply >= demand
%         A = A + demand;
%         capital = capital + demand*price;
%         sprintf('Capital: %0.2f',capital)
%         supply = supply - demand
%         demand = demand - demand
%     else
%         A = A + supply;
%         capital = capital + supply*price;
%         sprintf('Capital: %0.2f',capital)
%         demand = demand - supply
%         supply = supply - supply
%     end
%     
%     
%     
% end
% 

fun = @(x)loopClosureTurtleSim(x);


x0 = [ones(50,1)];

lb = [];
ub = [];
options = optimset('Display', 'off');

[x, resnorm] = lsqnonlin(fun, x0, lb, ub, options);

fun = loopClosureTurtleSim(x);

capital = 1/fun




