% intraDayViewer


clear; close all; clc



stock = 'ATAI';
c = yahoo;
m = fetch(c,stock,now, now-7000, 'm');
w = fetch(c,stock,now, now-7000, 'w');
d = fetch(c,stock,now, now-7000, 'd');

close(c)


hi = m(:,3); lo = m(:,4); cl = m(:,5); op = m(:,2); da = m(:,1);

highlow(hi, lo, hi, lo,'blue', da);
hold on


summer = [];
for j = 1:length(hi)
    A = [abs(hi(j)-hi), da];
    A = sortrows(A,1);
    summer = [summer; sum(A(2:10,1)), da(j)];
end

summer = sortrows(summer,1)

for i = 1:5
    i_found = find(summer(i,2) == da)
    hi(i_found)
    plot(da(i_found), hi(i_found), 'go');
end

% summer = 0;
% for i_date = 2:11
% i_found = find(A(i_date,2) == da)
% hi(i_found)
% summer = summer + hi(i_found);
% plot(da(i_found), hi(i_found), 'go');
% end
% summer



% stock = 'ATAI'
% exchange = 'NASDAQ';
%
% subplot(2,1,1)
% data = IntraDayStockData(stock,exchange,'900','1d');
% plot(data.date,data.high, 'r')
% hi = data.high; lo = data.low; da = data.date;
% highlow(hi, lo, hi, lo,'blue', da);
% datetick('x',15, 'keeplimits');
%
% subplot(2,1,2)
% plot(data.date,data.high, 'r')
% data = IntraDayStockData(stock,exchange,'60','1d');
% hi = data.high; lo = data.low; da = data.date;
% highlow(hi, lo, hi, lo,'blue', da);
% datetick('x',15, 'keeplimits');