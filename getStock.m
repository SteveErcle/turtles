function [y] = getStock(stock, present, numDays, ohlc)

%% Gets stock prices
% ohlc ==> open, high, low, close, volume, adjusted close


if ohlc == 'o'
    row = 1;
elseif ohlc == 'h'
    row = 2
elseif ohlc == 'l'
    row = 3;
elseif ohlc == 'c'
    row = 4;
elseif ohlc == 'v'
    row = 5;
elseif strcmp(ohlc,'ac')
    row = 6;
elseif strcmp(ohlc, 'all')
    row = 1:6;
end 

past = present+1-numDays;

yMtxAll = csvread(strcat(stock,'.csv'),2,1);
yMtxAll = yMtxAll(past-2:present-2,:);

y = yMtxAll(:,row);



