% MetricsForSelection

clear; close all; clc;

stock = 'TSLA';
c = yahoo;
m = fetch(c,stock,now, now-7000, 'm');
w = fetch(c,stock,now, now-7000, 'w');
d = fetch(c,stock,now, now-7000, 'd');
close(c)

for initSubPlots = 1:1
    
    subplot(3,1,1)
    hi = m(:,3); lo = m(:,4); cl = m(:,5); op = m(:,2); da = m(:,1);
    highlow(hi, lo, hi, lo,'blue', da);
    hold on
    highlow(hi, lo, op, cl, 'blue', da);
    title('Monthly')
    
    subplot(3,1,2)
    hi = w(:,3); lo = w(:,4); cl = w(:,5); op = w(:,2); da = w(:,1);
    highlow(hi, lo, hi, lo,'blue', da);
    hold on
    title('Weekly')
    
    subplot(3,1,3)
    hi = w(:,3); lo = w(:,4); cl = w(:,5); op = w(:,2); da = w(:,1);
    highlow(hi, lo, hi, lo,'blue', da);
    hold on
    title('Daily')
end


hi = w(:,3); lo = w(:,4); cl = w(:,5); op = w(:,2); da = w(:,1);




set(gcf, 'Position', [1441,1,1080,1824]);

BestLevs = [];
for k = 1:length(w)-1
    
    levelsFound = [];
    datesFound = [];
    
    levelsFound = sortrows([da,abs(hi(k)-hi)], 2);
    for j = 2:length(levelsFound)
        if levelsFound(j,2) <= 1 & hi(find(levelsFound(j,1) == da)-1) < hi(find(levelsFound(j,1) == da))
            datesFound = [datesFound; find(levelsFound(j,1) == da)];
        else
            break
        end
    end
    
    BestLevs = [BestLevs; da(k), length(datesFound)];
    
end

BestLevs = sortrows(BestLevs, -2)

levelsFound = [];
datesFound = [];

k = find(BestLevs(1,1) == da)


levelsFound = sortrows([da,abs(hi(k)-hi)], 2);
for j = 1:length(levelsFound)
    if levelsFound(j,2) <= 1
        datesFound = [datesFound; find(levelsFound(j,1) == da)];
    else
        break
    end
end

subplot(3,1,2)
plot(da(datesFound),hi(datesFound),'go')









%
for filterFinder = 1:1
    
    % handles = guihandles(sliderGuiDelete);
    % set(handles.slider1, 'Value', 0.001);
    % set(handles.slider1, 'Max', 0.999, 'Min', 0.001);
    % set(gcf, 'Position', [1441,1,1080,1824]);
    %
    % while(true)
    %
    %     val = get(handles.slider1,'Value');
    %
    %     hiFilt = getFiltered(hi, val, 'low')
    %
    %     plot(da, hiFilt)
    %
    %     pause(0.025)
    % end
    
end
%

%
for percentOnClose = 1:1
    % closePercents = [];
    % for i = 1:length(d)-1
    %     closePercents = [closePercents; da(i), (cl(i)-cl(i+1))/cl(i+1)];
    % end
    %
    % closePercents = sortrows(closePercents, -2)
    %
    % for i = 1:10
    %     indxOfLargestPercent = find(closePercents(i,1) == da)
    %
    %
    %     subplot(3,1,3)
    %     plot(closePercents(i,1), cl(indxOfLargestPercent), 'go');
    % end
end
%

