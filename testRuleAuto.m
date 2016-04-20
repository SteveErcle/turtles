% testRuleAuto

clc; close all; clear all;

% load('tslaOffline')

tf = TurtleFun;
td = TurtleData;
ta = TurtleAnalyzer;

stock = 'BAC';

past = datenum('3/1/13');
pres = datenum('1/1/14');

c = yahoo;
dSP = fetch(c,'^GSPC',past, now, 'd');
wSP = fetch(c,'^GSPC',past, now, 'w');
mSP = fetch(c,'^GSPC',past, now, 'm');
close(c)

delete(slider);
handles = guihandles(slider);

FETCH = 1;

if FETCH == 1
    [mAll, mCong, wAll, wCong, dAll, dCong, iAll] = td.getData(stock, past, pres, now);
    td.saveData(stock, mAll, mCong, wAll, wCong, dAll, dCong, iAll);
else
    [mAll, mCong, wAll, wCong, dAll, dCong, iAll] = td.loadData(stock);
end


dPast = td.resetPast(dCong, dAll, pres);
wPast = td.resetPast(wCong, wAll, pres);
mPast = td.resetPast(mCong, mAll, pres);


dCheck = 0;
enterLong  = [0,0];
exitLong = [0,0];
enterShort = [0,0];
exitShort = [0,0];
enteredL = 0;
enteredS = 0;
priceEntered = [];

% while(true)



for dateIndx = size(wCong,1) : -1: 1
    
    window_size = 10;
    
    dNow = [dCong(dateIndx:end,1:7); dPast];
    wNow = [td.getTimeDomain(dateIndx, wCong); wPast];
    mNow = [td.getTimeDomain(dateIndx, mCong); mPast];
    
    pres = dNow(1,1);
    
    dSPnow = dSP(td.getDateIndx(dSP(:,1), pres):end,:);
    wSPnow = wSP(td.getDateIndx(wSP(:,1), pres):end,:); if (size(wSPnow,1) > size(wNow)), wSPnow(1,:) = []; end
    mSPnow = mSP(td.getDateIndx(mSP(:,1), pres):end,:); if (size(mSPnow,1) > size(mNow)), mSPnow(1,:) = []; end
    
    [hiD, loD, clD, opD, daD] = tf.returnOHLCDarray(dNow);
    [hiW, loW, clW, opW, daW] = tf.returnOHLCDarray(wNow);
    [hiM, loM, clM, opM, daM] = tf.returnOHLCDarray(mNow);
    
    stockBeta = ta.calcBeta(dNow, dSPnow);
    
    [ScbSD, SioSD, SroSD] = ta.getMovingAvgs(dNow, dSPnow, window_size, stockBeta);
    [ScbSW, SioSW, SroSW] = ta.getMovingAvgs(wNow, wSPnow, window_size, stockBeta);
    [ScbSM, SioSM, SroSM] = ta.getMovingAvgs(mNow, mSPnow, window_size, stockBeta);
    
    
    dtodayf = [daD, flipud(tsmovavg(flipud(dNow(:,5)),'e',window_size*2,1))];
    wtodayf = [daW, flipud(tsmovavg(flipud(wNow(:,5)),'e',window_size*2,1))];
    mtodayf = [daM, flipud(tsmovavg(flipud(mNow(:,5)),'e',window_size,1))];
    
    dervD = flipud(diff(flipud(dtodayf(:,2))));
    sdervD = flipud(diff(flipud(dervD)));
    dervRawD = flipud(diff(flipud(SroSD)));
    meanD = mean(dtodayf(~isnan(dtodayf(:,2)),2));
    
    dervW = flipud(diff(flipud(wtodayf(:,2))));
    sdervW = flipud(diff(flipud(dervW)));
    dervRawW = flipud(diff(flipud(SroSW)));
    dervIdxW = flipud(diff(flipud(SioSW)));
    meanW = mean(wtodayf(~isnan(wtodayf(:,2)),2));
    
    dervM = flipud(diff(flipud(mtodayf(:,2))));
    sdervM = flipud(diff(flipud(dervM)));
    meanM = mean(mtodayf(~isnan(mtodayf(:,2)),2));
    
    if enteredL == 0
        if dervM(1) > dervM(2)
            if dervW(1) > dervW(2)
                if dervD(1) > dervD(2)
                    if dervRawW(1) >= 0 & dervIdxW(1) >= 0 & ScbSD(1) > dtodayf(1,2) & ScbSD(2) <= dtodayf(2,2) 
                        enterLong = [enterLong; [dtodayf(1,1), dtodayf(1,2)]];
                        enteredL = 1;
                        priceEntered = [priceEntered; [clD(1), 0, 0]];
                    end
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
    cla
    hold on;
    highlow(hiD, loD, opD, clD, 'red', daD);
    plot(dtodayf(:,1), dtodayf(:,2), 'm', 'Marker' , '.');
    plot(daD(1:end-1), dervD*5+meanD, 'k', 'Marker' , '.')
    plot([daD(1,1), daD(end,1)], [meanD, meanD], 'k')
    plot(enterLong(:,1), enterLong(:,2),'go');
    plot(exitLong(:,1), exitLong(:,2),'ko');
    plot(enterShort(:,1), enterShort(:,2),'ro');
    plot(exitShort(:,1), exitShort(:,2),'ko');
    plot(daD, ScbSD, 'r', 'Marker', '.'); plot(daD, SioSD-1, 'b.'); plot(daD, SroSD+1, 'color', [0.70,0.70,0.70], 'Marker', '.');
    
    yOne = ylim;
    xlim([pres-75, pres+10]);
    
    subplot(3,1,2)
    cla
    hold on;
    highlow(hiW, loW, opW, clW, 'red', daW);
    plot(wtodayf(:,1), wtodayf(:,2), 'm', 'Marker' , '.');
    plot(daW(1:end-1), dervW*5+meanW, 'k', 'Marker' , '.')
    plot([daW(1,1), daW(end,1)], [meanW, meanW], 'k')
    plot(daW, ScbSW, 'r', 'Marker', '.'); plot(daW, SioSW, 'b.'); plot(daW, SroSW, 'color', [0.70,0.70,0.70], 'Marker', '.');
    
    yTwo = ylim;
    xlim([pres-200, pres+10]);
    
    subplot(3,1,3)
    cla
    hold on;
    highlow(hiM, loM, opM, clM, 'red', daM);
    plot(mtodayf(:,1), mtodayf(:,2), 'm', 'Marker' , '.');
    plot(daM(1:end-1), dervM*5+meanM, 'k', 'Marker' , '.')
    plot([daM(1,1), daM(end,1)], [meanM, meanM], 'k');
    plot(daM, ScbSM, 'r', 'Marker', '.'); plot(daM, SioSM, 'b.'); plot(daM, SroSM, 'color', [0.70,0.70,0.70], 'Marker', '.');
    
    yThree = ylim;
    xlim([pres-250, pres+10]);
    
    if enteredL == 1        
        pause;
    end
    
end





subplot(3,1,1)
cla
[hi, lo, clD, op, daD] = tf.returnOHLCDarray(dNow);
highlow(hi, lo, op, clD, 'red', daD);
xlim([pres-100, pres+10])

hold on;

subplot(3,1,2)
cla
[hi, lo, cl, op, daW] = tf.returnOHLCDarray(wNow);
highlow(hi, lo, op, cl, 'red', daW);
xlim([pres-100, pres+10])
hold on;

subplot(3,1,3)
cla
[hi, lo, cl, op, daM] = tf.returnOHLCDarray(mNow);
highlow(hi, lo, op, cl, 'red', daM);
xlim([pres-100, pres+10])
hold on;



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