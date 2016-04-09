clc; close all; clear all;

past = '1/1/01';
simulateTo = now;
stock = '^GSPC';

url1 = 'http://finance.yahoo.com/d/quotes.csv?s=TSLA&f=b';

% url2 = ['http://ichart.finance.yahoo.com/table.csv?',...
%     's=WU&a=01&b=19&c=2010&d=01&e=19&f=2010&g=d&ignore=.csv'];

% url3 = 'http://marketdata.websol.barchart.com/getHistory.csv?key=62d3930b91bd9eb96bc053a405fe3412&symbol=IBM&type=daily&startDate=20150409000000'
for i = 1:100
tic 
f = urlwrite(url1, 'tempStockPrice.csv');
data = importdata(f)
toc
end


% stockexchange = 'NYSE';
% data.symbol = upper(symbol);
% data.stockexchange = upper(stockexchange);
% data.field = 'd,c,h,l,v';
% 
% 
% f = urlwrite(['http://www.google.com/finance/getprices?q=',data.symbol,'&x=',...
%     data.stockexchange,'&i=',data.interval,'&p=',data.prevdays,'&f=',data.field],'tempStockPrice.csv');
% 
% googledata = importdata(f);
% data.close = googledata.data(:,1);
% data.high = googledata.data(:,2);
% data.low = googledata.data(:,3);
% data.volume = googledata.data(:,4);