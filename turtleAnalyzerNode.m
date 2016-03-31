% testGet data

clear all; clc; close all;




past = 734318;
simulateTo = now;

stock = 'TSLA';

c = yahoo;

dAll = (fetch(c,stock,past, simulateTo, 'd'));
wAll = fetch(c,stock,past, simulateTo, 'w');
mAll = fetch(c,stock,past, simulateTo, 'm');

averages = '^GSPC';
dAvg = fetch(c,averages,past, simulateTo, 'd');

close(c);






tf = TurtleFun;
% [hi, lo, cl, op, da] = tf.returnOHLCDarray(wAll);
% vo = dAll(:,6);

subplot(3,1,1)
[hi, lo, cl, op, da] = tf.returnOHLCDarray(dAll);
highlow(hi, lo, op, cl, 'blue', da);
hold on;
% subplot(3,1,2)
% [hi, lo, cl, op, da] = tf.returnOHLCDarray(wAll);
% highlow(hi, lo, op, cl, 'blue', da);
% subplot(3,1,3)
% [hi, lo, cl, op, da] = tf.returnOHLCDarray(mAll);
% highlow(hi, lo, op, cl, 'blue', da);

set(gcf, 'Position', [-1079,5,1077,1820]);


[hiD, loD, clD, opD, daD] = tf.returnOHLCDarray(dAvg);
subplot(3,1,2)
highlow(hiD, loD, opD, clD, 'blue', daD);


perCl = [];
perClD = [];

for i = 1:size(da)-1
    perCl = [perCl; (cl(i) - cl(i+1)) / cl(i+1)*100];
    perClD = [perClD; (clD(i) - clD(i+1)) / clD(i+1)*100];
end

beta = cov(perCl, perClD) / var(perClD)
beta = beta(1,2)

return;


ad = [0];
adD = [0];
figure(1)
hold on;

for i = size(dAvg,1)-1:-1:1
    adD = [adD; (clD(i) - clD(i+1)) / clD(i+1)*100];
    
    disp([clD(i), clD(i+1)])
  
    subplot(3,1,3)
    plot(adD, 'bo')
    
    subplot(3,1,1)
    plot(da(i), hi(i) , 'ro')
    
end


return


tStore = [];

while(true)
    
    pause
    
    h = gcf;
    axesObjs = get(h, 'Children');
    axesObjs = findobj(axesObjs, 'type', 'axes');
    dataTips = findall(axesObjs, 'Type', 'hggroup', 'HandleVisibility', 'off');
    
    if length(dataTips) > 0
        
        cursor = datacursormode(gcf);
        values = cursor.getCursorInfo;
        
        tDate = values.Position;
        tStore = [tStore; tDate(1)];
        datestr(tStore,12)
        delete(dataTips);
        
    end
    
end




return










tRunnerDown = 0;
tRunnerUp = 0;
tStore = [];

range = 2:10

for dateIndx = range
    
    if lo(dateIndx) < lo(dateIndx-1)
        runlo = 1;
    elseif lo(dateIndx) >= lo(dateIndx-1) & hi(dateIndx) < hi(dateIndx-1)
        runlo = 1;
    else
        runlo = 0;
    end
    
    if hi(dateIndx) > hi(dateIndx-1)
        runhi = 1;
    elseif hi(dateIndx) <= hi(dateIndx-1) & lo(dateIndx) > lo(dateIndx-1)
        runhi = 1;
    else
        runhi = 0;
    end
    
    
    if runlo == 1
        tRunnerDown = tRunnerDown + 1;
    else
        tRunnerDown = 1;
    end
    
    if runhi == 1
        tRunnerUp = tRunnerUp + 1;
    else
        tRunnerUp = 1;
    end
    
    disp([tRunnerUp, tRunnerDown])
    
    tStore = [tStore; tRunnerUp, tRunnerDown];
    
end

subplot(3,1,1)
pHandle = highlow(hi, lo, op, cl, 'blue', da);
hold on

text(da(range), hi(range)*1.01, strcat(num2str(tStore(:,1))));
text(da(range), lo(range)*0.99, strcat(num2str(tStore(:,2))));



[hiA, loA, clA, opA, daA] = tf.returnOHLCDarray(dAvg);
daA(avgIndx,1)

[hi, lo, cl, op, da] = tf.returnOHLCDarray(dAll);
da(dateIndx,1)


disp('Average');
disp([opA(avgIndx), clA(avgIndx)]);
disp('Stock');
disp([op(avgIndx), cl(avgIndx)]);

pointA = clA(avgIndx) - opA(avgIndx);
pointS = cl(dateIndx) - op(dateIndx);

set(0,'CurrentFigure',fD)
if pointS > 0
    plot(da(dateIndx), hi(dateIndx), 'go')
else
    plot(da(dateIndx), hi(dateIndx), 'ro')
end

if pointA > 0
    plot(da(dateIndx), lo(dateIndx), 'go')
else
    plot(da(dateIndx), lo(dateIndx), 'ro')
end











% text(da(dateIndx), hi(dateIndx)*1.01, strcat(num2str(tRunnerUp)));
% text(da(dateIndx), lo(dateIndx)*0.99, strcat(num2str(tRunnerDown)));

% ax1 = gca;
% hold on
%
% ax2 = axes('Position',get(ax1,'Position'),...
%     'XAxisLocation','top',...
%     'YAxisLocation','right',...
%     'Color','none',...
%     'XColor','k','YColor','k');
% set(ax2, 'YLim', [0 180000000])
% linkaxes([ax1 ax2],'x');
% hold on
% bar(dAll(:,1),dAll(:,6),'Parent',ax2);
% hold off