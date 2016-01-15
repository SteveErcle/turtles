% MetricsForSelection

clear; close all; clc;

[~,allStocks] = xlsread('listOfETFs')


storeCompared = [];

%
for i_as = [7,24,6,8,13,25,31,10,12]
    %     %1:length(allStocks)
    %
    %
    %     stock = allStocks(i_as)
    %
    %     c = yahoo;
    %     m = fetch(c,stock,now-90, now-7000, 'm');
    %     w = fetch(c,stock,now-90, now-7000, 'w');
    %     d = fetch(c,stock,now-90, now-7000, 'd');
    %     close(c)
    %
    %
    %     figure
    %     set(gcf, 'Position', [1441,1,1080,1824]);
    %
    %     for initSubPlots = 1:1
    %         sprintf('Init SubPlots')
    %         subplot(3,1,1)
    %         hi = m(:,3); lo = m(:,4); cl = m(:,5); op = m(:,2); da = m(:,1);
    %         highlow(hi, lo, hi, lo,'blue', da);
    %         hold on
    %         highlow(hi, lo, op, cl, 'blue', da);
    %         title(strcat(stock,' Monthly'))
    %
    %         subplot(3,1,2)
    %         hi = w(:,3); lo = w(:,4); cl = w(:,5); op = w(:,2); da = w(:,1);
    %         highlow(hi, lo, hi, lo,'blue', da);
    %         hold on
    %         title(strcat(stock,' Weekly'))
    %
    %         subplot(3,1,3)
    %         hi = d(:,3); lo = d(:,4); cl = d(:,5); op = d(:,2); da = d(:,1);
    %         highlow(hi, lo, hi, lo,'blue', da);
    %         hold on
    %         %         highlow(hi, lo, op, cl, 'blue', da);
    %         title(strcat(stock,' Daily'))
    %     end
    %
    %     hi = w(:,3); lo = w(:,4); cl = w(:,5); op = w(:,2); da = w(:,1);
    %
    %     for autoLevelFinder = 1:1
    %
    %         for i_RESISTANCE = 1:1
    %
    %             numBestLevs = [];
    %             for k = 2:length(w)-1
    %
    %                 levels = (hi(k)-hi)/hi(k);
    %                 daysOfLevelPrice = sortrows([da,abs(levels)], 2);
    %                 indxOfSelectedDays = [];
    %
    %
    %
    %                 for j = 2:length(daysOfLevelPrice)
    %                     indx = find(daysOfLevelPrice(j,1) == da);
    %
    %                     if indx ~= 1 & indx ~= length(w) & hi(k-1) <= hi(k) & hi(k+1) <= hi(k)
    %
    %                         if daysOfLevelPrice(j,2) <= 0.05 & hi(indx-1) <= hi(indx) & hi(indx+1) <= hi(indx)
    %                             indxOfSelectedDays = [indxOfSelectedDays; indx];
    %                         else
    %                             if indx ~= 1 & indx ~= length(w) & hi(k-1) <= hi(k) & hi(k+1) <= hi(k)
    %                                 indxOfSelectedDays = [indxOfSelectedDays; k];
    %                             end
    %                             break
    %                         end
    %                     else
    %                         break
    %                     end
    %
    %                 end
    %
    %                 numBestLevs = [numBestLevs; length(indxOfSelectedDays), k];
    %
    %             end
    %
    %             numBestLevs = sortrows(numBestLevs, -1);
    %
    %             foundResistanceLevels = [];
    %             for iplotter = 1:10
    %                 k = numBestLevs(iplotter,2);
    %
    %                 levels = (hi(k)-hi)/hi(k);
    %                 daysOfLevelPrice = sortrows([da,abs(levels)], 2);
    %                 indxOfSelectedDays = [];
    %
    %                 for j = 2:length(daysOfLevelPrice)
    %                     indx = find(daysOfLevelPrice(j,1) == da);
    %
    %                     if indx ~= 1 & indx ~= length(w) & hi(k-1) <= hi(k) & hi(k+1) <= hi(k)
    %
    %                         if daysOfLevelPrice(j,2) <= 0.05 & hi(indx-1) <= hi(indx) & hi(indx+1) <= hi(indx)
    %                             indxOfSelectedDays = [indxOfSelectedDays; indx];
    %                         else
    %                             if indx ~= 1 & indx ~= length(w) & hi(k-1) <= hi(k) & hi(k+1) <= hi(k)
    %                                 indxOfSelectedDays = [indxOfSelectedDays; k];
    %                             end
    %                             break
    %                         end
    %                     else
    %                         break
    %                     end
    %
    %                 end
    %
    %                 foundResistanceLevels = [foundResistanceLevels; max(hi(indxOfSelectedDays))];
    %
    %             end
    %
    %             foundResistanceLevels = sort(unique(foundResistanceLevels));
    %             for i = 1:length(foundResistanceLevels)-1
    %                 if foundResistanceLevels(i)/foundResistanceLevels(i+1) > 0.97
    %                     foundResistanceLevels(i+1) = 0;
    %                 end
    %             end
    %
    %             foundResistanceLevels([find(0 == foundResistanceLevels)]) = [];
    %
    %             subplot(3,1,2)
    %             for i_rl = 1:length(foundResistanceLevels)
    %                 plot(da, ones(length(da),1) * foundResistanceLevels(i_rl),'k')
    %             end
    %
    %         end
    %
    %         for i_SUPPORT = 1:1
    %
    %             numBestLevs = [];
    %             for k = 2:length(w)-1
    %
    %                 levels = (lo(k)-lo)/lo(k);
    %                 daysOfLevelPrice = sortrows([da,abs(levels)], 2);
    %                 indxOfSelectedDays = [];
    %
    %                 for j = 2:length(daysOfLevelPrice)
    %                     indx = find(daysOfLevelPrice(j,1) == da);
    %
    %                     if indx ~= 1 & indx ~= length(w) & lo(k-1) >= lo(k) & lo(k+1) >= lo(k)
    %
    %                         if daysOfLevelPrice(j,2) <= 0.05 & lo(indx-1) >= lo(indx) & lo(indx+1) >= lo(indx)
    %                             indxOfSelectedDays = [indxOfSelectedDays; indx];
    %                         else
    %                             if indx ~= 1 & indx ~= length(w) & lo(k-1) >= lo(k) & lo(k+1) >= lo(k)
    %                                 indxOfSelectedDays = [indxOfSelectedDays; k];
    %                             end
    %                             break
    %                         end
    %
    %                     else
    %                         break
    %                     end
    %
    %                 end
    %
    %                 numBestLevs = [numBestLevs; length(indxOfSelectedDays), k];
    %
    %             end
    %
    %             numBestLevs = sortrows(numBestLevs, -1);
    %
    %             foundSupportLevels = [];
    %             for iplotter = 1:10
    %                 k = numBestLevs(iplotter,2);
    %
    %                 levels = (lo(k)-lo)/lo(k);
    %                 daysOfLevelPrice = sortrows([da,abs(levels)], 2);
    %                 indxOfSelectedDays = [];
    %
    %                 for j = 2:length(daysOfLevelPrice)
    %                     indx = find(daysOfLevelPrice(j,1) == da);
    %
    %                     if indx ~= 1 & indx ~= length(w) & lo(k-1) >= lo(k) & lo(k+1) >= lo(k)
    %
    %                         if daysOfLevelPrice(j,2) <= 0.05 & lo(indx-1) >= lo(indx) & lo(indx+1) >= lo(indx)
    %                             indxOfSelectedDays = [indxOfSelectedDays; indx];
    %                         else
    %                             if indx ~= 1 & indx ~= length(w) & lo(k-1) >= lo(k) & lo(k+1) >= lo(k)
    %                                 indxOfSelectedDays = [indxOfSelectedDays; k];
    %                             end
    %                             break
    %                         end
    %
    %                     else
    %                         break
    %                     end
    %
    %                 end
    %
    %                 foundSupportLevels = [foundSupportLevels; min(lo(indxOfSelectedDays))];
    % %                 subplot(3,1,2)
    % %                 plot(da(indxOfSelectedDays), lo(indxOfSelectedDays), 'go');
    %
    %             end
    %
    %             foundSupportLevels = sort(unique(foundSupportLevels));
    %             for i = 1:length(foundSupportLevels)-1
    %                 if foundSupportLevels(i)/foundSupportLevels(i+1) > 0.97
    %                     foundSupportLevels(i+1) = 0;
    %                 end
    %             end
    %
    %             foundSupportLevels([find(0 == foundSupportLevels)]) = [];
    %
    %             subplot(3,1,2)
    %             for i_sl = 1:length(foundSupportLevels)
    %                 plot(da, ones(length(da),1) * foundSupportLevels(i_sl),'r')
    %             end
    %
    %
    %
    %         end
    %
    %         compareCurrentToRes = sort(abs((hi(1)-foundResistanceLevels)/hi(1)));
    %         compareCurrentToSup = sort(abs((lo(1)-foundSupportLevels)/lo(1)));
    %
    %     end
    %
    %     storeCompared = [storeCompared; i_as, compareCurrentToRes(1), compareCurrentToSup(1)];
    
end
%

% nearRes = sortrows(storeCompared,2)
% nearSup = sortrows(storeCompared,3)

stock = allStocks(1)

c = yahoo;
m = fetch(c,stock,now-90, now-7000, 'm');
w = fetch(c,stock,now-90, now-7000, 'w');
d = fetch(c,stock,now-90, now-7000, 'd');
close(c)

for initSubPlots = 1:1
    %         sprintf('Init SubPlots')
    %         subplot(3,1,1)
    %         hi = m(:,3); lo = m(:,4); cl = m(:,5); op = m(:,2); da = m(:,1);
    %         highlow(hi, lo, hi, lo,'blue', da);
    %         hold on
    %         highlow(hi, lo, op, cl, 'blue', da);
    %         title(strcat(stock,' Monthly'))
    %
    %         subplot(3,1,2)
    %         hi = w(:,3); lo = w(:,4); cl = w(:,5); op = w(:,2); da = w(:,1);
    %         highlow(hi, lo, hi, lo,'blue', da);
    %         hold on
    %         title(strcat(stock,' Weekly'))
    %
    %         subplot(3,1,3)
    %         hi = d(:,3); lo = d(:,4); cl = d(:,5); op = d(:,2); da = d(:,1);
    %         highlow(hi, lo, hi, lo,'blue', da);
    %         hold on
    %         %         highlow(hi, lo, op, cl, 'blue', da);
    %         title(strcat(stock,' Daily'))
end

hi = w(:,3); lo = w(:,4); cl = w(:,5); op = w(:,2); da = w(:,1);

for autoTrendFinder = 1:1
    
    %         xVals = [0,0,0,0];
    %         storez = [];
    %         for j = 1:200
    %             snum = j;
    %             enum = snum+9;
    %
    %             if j == 200
    %                 storez = sortrows(storez,7);
    %                 snum = storez(10,5);
    %                 enum = storez(10,6);
    %             end
    %
    %
    %             for i = 1:2
    %                 if i == 1
    %                     y = (hi(snum:enum)');
    %                 else
    %                     y = (lo(snum:enum)');
    %                 end
    %
    %                 fun = @(x)(y - (x(1)*(snum:enum)+x(2)));
    %
    %                 x0 = [2,3];
    %                 lb = []; ub = []; options = optimset('Display', 'off');
    %                 [x] = lsqnonlin(fun, x0, lb, ub, options);
    %
    %                 xVals((i*2)-1:(i*2)) = x;
    %
    %                 if j == 200
    %                     subplot(3,1,2)
    %                     plot(da(snum:enum)',y,'ko')
    %                     hold on
    %                     plot(da(snum:enum)', x(1)*(snum:enum)'+x(2))
    %                 end
    %
    %             end
    %
    %             storez = [storez; xVals, snum, enum, mean([xVals(1),xVals(3)])];
    %
    %         end
    
end
%

%
for filterFinder = 1:1
    
    handles = guihandles(sliderGuiDelete);
    set(handles.slider1, 'Value', 0.001);
    set(handles.slider1, 'Max', 0.999, 'Min', 0.001);
    set(gcf, 'Position', [1441,1,1080,1824]);
    
    while(true)
        
        val = get(handles.slider1,'Value');
        
        hiFilt = getFiltered(hi, val, 'low');
        
        plot(da, hiFilt)
        
        pause(0.025)
    end
    
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

