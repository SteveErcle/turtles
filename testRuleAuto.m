% testRuleAuto

clc; close all; clear all;

% load('tslaOffline')

tf = TurtleFun;
td = TurtleData;

stock = 'BAC';

past = datenum('3/1/14');
pres = datenum('5/1/15');
startDay = pres;

delete(slider);
handles = guihandles(slider);

% FETCH = 0;
%
% if FETCH == 1
%     [mAll, mCong, wAll, wCong, dAll, dCong, iAll] = td.getData(stock, past, pres, now);
%     td.saveData(stock, mAll, mCong, wAll, wCong, dAll, dCong, iAll);
% else
%     [mAll, mCong, wAll, wCong, dAll, dCong, iAll] = td.loadData(stock);
% end


% dPast = td.resetPast(dCong, dAll, startDay);
% wPast = td.resetPast(wCong, wAll, startDay);
% mPast = td.resetPast(mCong, mAll, startDay);


c = yahoo;

dCheck = 0;
enterLong  = [0,0];
exitLong = [0,0];
enterShort = [0,0];
exitShort = [0,0];
enteredL = 0;
enteredS = 0;
priceEntered = [];

while(true)
    
    %     [dateIndx] = td.getDateIndx(dCong(:,1), pres);
    %
    %     dtoday = dCong(dateIndx:end, :);
    %     wtoday = wCong(dateIndx:end, :);
    %     mtoday = mCong(dateIndx:end, :);
    
    dAll = (fetch(c, stock, past, pres, 'd'));
    
    while dAll(1,1) == dCheck
        pres = pres+1;
        dAll = (fetch(c, stock, past, pres, 'd'));
    end
    
    dCheck = dAll(1,1);
    
    wAll = (fetch(c, stock, past, pres, 'w'));
    mAll = (fetch(c, stock, past, pres, 'm'));
    
    
    
    subplot(3,1,1)
    cla
    [hi, lo, clD, op, daD] = tf.returnOHLCDarray(dAll);
    highlow(hi, lo, op, clD, 'red', daD);
    xlim([pres-100, pres+10])
    
    hold on;
    
    subplot(3,1,2)
    cla
    [hi, lo, cl, op, daW] = tf.returnOHLCDarray(wAll);
    highlow(hi, lo, op, cl, 'red', daW);
    xlim([pres-100, pres+10])
    hold on;
    
    subplot(3,1,3)
    cla
    [hi, lo, cl, op, daM] = tf.returnOHLCDarray(mAll);
    highlow(hi, lo, op, cl, 'red', daM);
    xlim([pres-100, pres+10])
    hold on;
    
    window_size = 10;
    
    dtodayf = [daD, flipud(tsmovavg(flipud(dAll(:,5)),'e',window_size*2,1))];
    wtodayf = [daW, flipud(tsmovavg(flipud(wAll(:,5)),'e',window_size,1))];
    mtodayf = [daM, flipud(tsmovavg(flipud(mAll(:,5)),'e',window_size,1))];
    
    dervD = flipud(diff(flipud(dtodayf(:,2))));
    sdervD = flipud(diff(flipud(dervD)));
    meanD = mean(dtodayf(~isnan(dtodayf(:,2)),2));
    
    dervW = flipud(diff(flipud(wtodayf(:,2))));
    sdervW = flipud(diff(flipud(dervW)));
    meanW = mean(wtodayf(~isnan(wtodayf(:,2)),2));
    
    dervM = flipud(diff(flipud(mtodayf(:,2))));
    sdervM = flipud(diff(flipud(dervM)));
    meanM = mean(mtodayf(~isnan(mtodayf(:,2)),2));
    
    if enteredL == 0
        if dervM(1) > dervM(2)
            if dervW(1) > dervW(2)
                if dervD(1) < dervD(2)
                    enterLong = [enterLong; [dtodayf(1,1), dtodayf(1,2)]];
                    enteredL = 1;
                    priceEntered = [priceEntered; [clD(1), 0, 0]];
                end
            end
        end
    else
        if dervD(1) < dervD(2)
            exitLong = [exitLong; [dtodayf(1,1), dtodayf(1,2)]];
            enteredL = 0;
            priceEntered(end,2) = clD(1);
            priceEntered(end,3) = (priceEntered(end,2) - priceEntered(end,1)) / priceEntered(end,1) * 100
            disp(sum(priceEntered(:,3)));
        end
    end
    
    
    if enteredS == 0
        if dervM(1) < dervM(2)
            if dervW(1) < dervW(2)
                if dervD(1) > dervD(2)
                    enterShort = [enterShort; [dtodayf(1,1), dtodayf(1,2)]];
                    enteredS = 1;
                end
            end
        end
    else
        if dervD(1) > dervD(2)
            exitShort = [exitShort; [dtodayf(1,1), dtodayf(1,2)]];
            enteredS = 0;
        end
    end
    
    
    
    subplot(3,1,1)
    plot(dtodayf(:,1), dtodayf(:,2), 'Marker' , '.');
    plot(daD(1:end-1), dervD*5+meanD, 'k', 'Marker' , '.')
    plot([daD(1,1), daD(end,1)], [meanD, meanD], 'k')
    plot(enterLong(:,1), enterLong(:,2),'go');
    plot(exitLong(:,1), exitLong(:,2),'ko');
    plot(enterShort(:,1), enterShort(:,2),'ro');
    plot(exitShort(:,1), exitShort(:,2),'ko');
    yOne = ylim;
    
    subplot(3,1,2)
    plot(wtodayf(:,1), wtodayf(:,2), 'Marker' , '.');
    plot(daW(1:end-1), dervW*5+meanW, 'k', 'Marker' , '.')
    plot([daW(1,1), daW(end,1)], [meanW, meanW], 'k')
    yTwo = ylim;
    
    subplot(3,1,3)
    plot(mtodayf(:,1), mtodayf(:,2), 'Marker' , '.');
    plot(daM(1:end-1), dervM*5+meanM, 'k', 'Marker' , '.')
    plot([daM(1,1), daM(end,1)], [meanM, meanM], 'k');
    yThree = ylim;
    
    
    pause;
    
    pres = pres + 1;
    
end