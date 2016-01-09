% MetricsForSelection

clear; close all; clc;

stock = 'ZIV';
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
    hi = d(:,3); lo = d(:,4); cl = d(:,5); op = d(:,2); da = d(:,1);
    highlow(hi, lo, hi, lo,'blue', da);
    hold on
    title('Daily')
end


hi = w(:,3); lo = w(:,4); cl = w(:,5); op = w(:,2); da = w(:,1);




set(gcf, 'Position', [1441,1,1080,1824]);


% autoTrendFinder


for autoLevelFinder = 1:1
    
    numBestLevs = [];
    for k = 2:length(w)
        
        levels = (hi(k)-hi)/hi(k);
        daysOfLevelPrice = sortrows([da,abs(levels)], 2);
        indxOfSelectedDays = [];
        
        for j = 2:length(daysOfLevelPrice)
            indx = find(daysOfLevelPrice(j,1) == da);
            
            if indx ~= 1 & hi(k-1) < hi(k)
                if daysOfLevelPrice(j,2) <= 1 & hi(indx-1) < hi(indx)
                    indxOfSelectedDays = [indxOfSelectedDays; indx];
                else
                    indxOfSelectedDays = [indxOfSelectedDays; k];
                    break
                end
            end
            
        end
        
        numBestLevs = [numBestLevs; length(indxOfSelectedDays), k];
        
    end
    
    numBestLevs = sortrows(numBestLevs, -1);
    
    foundResistanceLevels = [];
    for iplotter = 1:10
        k = numBestLevs(iplotter,2);
        
        levels = (hi(k)-hi)/hi(k);
        daysOfLevelPrice = sortrows([da,abs(levels)], 2);
        indxOfSelectedDays = [];
        
        for j = 2:length(daysOfLevelPrice)
            indx = find(daysOfLevelPrice(j,1) == da);
            
            if indx ~= 1 & hi(k-1) < hi(k)
                if daysOfLevelPrice(j,2) <= 1 & hi(indx-1) < hi(indx)
                    indxOfSelectedDays = [indxOfSelectedDays; indx];
                else
                    indxOfSelectedDays = [indxOfSelectedDays; k];
                    break
                end
            end
            
        end
        
        foundResistanceLevels = [foundResistanceLevels; max(hi(indxOfSelectedDays))];
        
        
    end
    
    foundResistanceLevels = sort(unique(foundResistanceLevels));
    for i = 1:length(foundResistanceLevels)-1
        if foundResistanceLevels(i)/foundResistanceLevels(i+1) > 0.97
            foundResistanceLevels(i+1) = 0;
        end
    end
    
    foundResistanceLevels([find(0 == foundResistanceLevels)]) = [];
    
    subplot(3,1,2)
    for i_rl = 1:length(foundResistanceLevels)
        plot(da, ones(length(da),1) * foundResistanceLevels(i_rl),'k')
    end
    
    numBestLevs = [];
    for k = 2:length(w)
        
        levels = (lo(k)-lo)/lo(k);
        daysOfLevelPrice = sortrows([da,abs(levels)], 2);
        indxOfSelectedDays = [];
        
        for j = 2:length(daysOfLevelPrice)
            indx = find(daysOfLevelPrice(j,1) == da);
            
            if indx ~= 1 & lo(k-1) > lo(k)
                if daysOfLevelPrice(j,2) <= 1 & lo(indx-1) > lo(indx)
                    indxOfSelectedDays = [indxOfSelectedDays; indx];
                else
                    indxOfSelectedDays = [indxOfSelectedDays; k];
                    break
                end
            end
            
        end
        
        numBestLevs = [numBestLevs; length(indxOfSelectedDays), k];
        
    end
    
    numBestLevs = sortrows(numBestLevs, -1);
    
    foundSupportLevels = [];
    for iplotter = 1:10
        k = numBestLevs(iplotter,2);
        
        levels = (lo(k)-lo)/lo(k);
        daysOfLevelPrice = sortrows([da,abs(levels)], 2);
        indxOfSelectedDays = [];
        
        for j = 2:length(daysOfLevelPrice)
            indx = find(daysOfLevelPrice(j,1) == da);
            
            if indx ~= 1 & lo(k-1) > lo(k)
                if daysOfLevelPrice(j,2) <= 1 & lo(indx-1) > lo(indx)
                    indxOfSelectedDays = [indxOfSelectedDays; indx];
                else
                    indxOfSelectedDays = [indxOfSelectedDays; k];
                    break
                end
            end
            
        end
        
        foundSupportLevels = [foundSupportLevels; min(lo(indxOfSelectedDays))];
        %     subplot(3,1,2)
        %     plot(da(indxOfSelectedDays), lo(indxOfSelectedDays), 'go');
        
    end
    
    foundSupportLevels = sort(unique(foundSupportLevels));
    for i = 1:length(foundSupportLevels)-1
        if foundSupportLevels(i)/foundSupportLevels(i+1) > 0.97
            foundSupportLevels(i+1) = 0;
        end
    end
    
    foundSupportLevels([find(0 == foundSupportLevels)]) = [];
    
    subplot(3,1,2)
    for i_sl = 1:length(foundSupportLevels)
        plot(da, ones(length(da),1) * foundSupportLevels(i_sl),'r')
    end
    
end

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

