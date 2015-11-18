% eggLayer

clear all;
close all;
clc;


c = yahoo;
stock = 'COT';


yearlyHL = [];

figure()
% for j = 0:9

%     for i = 1:12

j = 3;
i = 12;
year1 = 2001;
year2 = 2002 + j;
dayMonth = '1/1/';
month = i;
dayMonth2 = strcat(num2str(month),'/28/');
d = fetch(c,stock,strcat(dayMonth, num2str(year1)), strcat(dayMonth2, num2str(year2)), 'w');
strcat(dayMonth, num2str(year1))
strcat(dayMonth2, num2str(year2))

for i = 10:200
    highlow(d(end-i:end,3), d(end-i:end,4), d(end-i:end,3), d(end-i:end,4),'blue',d(end-i:end,1));
   
    rsLines = input('2 column rs: ')
    hold on
    plot(d(end-i:end,1),ones(length(d(end-i:end,1)),1)*rsLines(1),'g');
    plot(d(end-i:end,1),ones(length(d(end-i:end,1)),1)*rsLines(2),'r');
    hold off
    pause
end



        nearResist = max(d(1:16,3));
        nearSupport = min(d(1:16,4));
%
%         midResist = max(d(16:32,3));
%         midSupport = min(d(16:32,4));
%
%         farResist = max(d(32:48,3));
%         farSupport = min(d(32:48,4));
%         hold on
        plot(d(1:16,1),nearResist,'g');
%         plot(d(1:16,1),nearSupport,'r');
%
%         plot(d(16:32,1),midResist,'g');
%         plot(d(16:32,1),midSupport,'r');
%
%         plot(d(32:48,1),farResist,'g');
%         plot(d(32:48,1),farSupport,'r');
%
%         hold off




%     end

% end



close(c);