clc; close all; clear all;

past = '1/1/01';
simulateTo = now;
stock = '^GSPC';


while ~strcmp(datestr(now,15), '09:30')
    pause(5)
    disp(['Waiting... ', datestr(now,15)]);
end


% url1 = 'http://finance.yahoo.com/d/quotes.csv?s=TSLA&f=b+b6+a+a5';
% url1 = 'http://finance.yahoo.com/d/quotes.csv?s=TSLA&f=i5+l+ll+k3';

url1 = 'http://finance.yahoo.com/d/quotes.csv?s=BAC&f=v+l+l1+k3+b+b6+a+a5';

% url2 = ['http://ichart.finance.yahoo.com/table.csv?',...
%     's=WU&a=01&b=19&c=2010&d=01&e=19&f=2010&g=d&ignore=.csv'];

% url3 = 'http://marketdata.websol.barchart.com/getHistory.csv?key=62d3930b91bd9eb96bc053a405fe3412&symbol=IBM&type=daily&startDate=20150409000000'

len = 10000;

volume  = zeros(1000,1);
timeCollected = zeros(1000,1);
time = [];
price = zeros(1000,1);
bid = zeros(len,1);
bidSize = zeros(len,1);
ask = zeros(len,1);
askSize = zeros(len,1);
tradeSize = zeros(len,1);

i = 2;
first = 1;
while(true)

f = urlwrite(url1, 'tempStockPrice.csv');
data = importdata(f);

if str2double(data.textdata(1)) ~= volume(i-1) 

disp([data.textdata'; data.data])

timeCollected(i) = now;
volume(i) = str2double(data.textdata(1));
time{i} = data.textdata(3);
price(i) = str2double(data.textdata(5));
tradeSize(i) = str2double(data.textdata(7));
bid(i) = str2double(data.textdata(9));
bidSize(i) = str2double(data.textdata(11));
ask(i) = str2double(data.textdata(13));
askSize(i) = data.data;

i = i + 1;

end 

disp('  ')

% disp([data.textdata(3), data.textdata(1)])
% 
% disp([data.data, data.textdata(5)]);

pause(1)


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