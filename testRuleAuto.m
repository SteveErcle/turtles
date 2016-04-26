% testRuleAuto

clc; close all; clear all;

% load('tslaOffline')

tf = TurtleFun;
td = TurtleData;
ta = TurtleAnalyzer;

stock = 'PEP';

past = datenum('1/1/11');
pres = datenum('3/2/13');
simTo = '5/3/13';

c = yahoo;
dSP = fetch(c,'^GSPC',past, now, 'd');
wSP = fetch(c,'^GSPC',past, now, 'w');
mSP = fetch(c,'^GSPC',past, now, 'm');
close(c)


 [hiD, loD, clD, opD, daD] = tf.returnOHLCDarray(dSP(1:20,:));
 subplot(2,1,1)
 highlow(hiD, loD, opD, clD, 'red', daD);
 subplot(2,1,2)
 candle(hiD, loD, clD, opD, 'blue', daD);
    

return

%  [hiD, loD, clD, opD, daD] = tf.returnOHLCDarray(dSP(1:100,:));
%    
% highlow(hiD, loD, opD, clD, 'red', daD);

%This is the important date section

A = [1 3 4 6 3 7 8 2 4] 
B = [1 2 3 4 7 8 9 10 11]

plot(B,A, 'ro')
tick_index = 1:2:length(A); % checks length of the dates with 10 steps in between.
% tick_label = datestr(daD(tick_index), 6); % this is translated to a datestring.
% %Now we tell the x axis to use the parameters set before.
set(gca,'XTick',tick_index); 
% set(gca,'XTickLabel',tick_label);
return
    

delete(slider);
handles = guihandles(slider);

FETCH = 1;

if FETCH == 1
    [mAll, mCong, wAll, wCong, dAll, dCong, iAll] = td.getData(stock, past, pres, simTo);
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
priceEnteredL = [];
priceEnteredS = [];


% len = 20;
% datesToExamine = {};
% for i = len+1:size(dAll,1)
%
%     perRet = (dAll(i-len,5) - dAll(i,5)) / dAll(i,5);
%
%     if perRet > 0.10 & dAll(i-len,1) > pres+10
%         datesToExamine = [datesToExamine; {datestr(dAll(i,1),12)}];
%     end
% end
%
% datesToExamine = unique(datesToExamine);
% datesToExamine = datenum(datesToExamine,'mmmyy');
%
%
% dateToExamine = datenum('04/1/16');

% for k = 1:length(datesToExamine)
%
%     dateIndxStart = td.getDateIndx(dCong(:,1), datesToExamine(k));
%
for dateIndx = size(wCong,1) : -1: 1
    %     for dateIndx = dateIndxStart :-1 : 1
    %     dateIndx = dateIndxStart;
    
    %     while(true)
    
    
    window_size = 10;
    
    dNow = [dCong(dateIndx:end,1:7); dPast];
    dNow = dNow(1:200,:);
    wNow = [td.getTimeDomain(dateIndx, wCong); wPast];
    mNow = [td.getTimeDomain(dateIndx, mCong); mPast];
    
    pres = dNow(1,1);
    
    datestr(pres,2)
    
    dSPnow = dSP(td.getDateIndx(dSP(:,1), pres):end,:);
    dSPnow = dSPnow(1:200,:);
    wSPnow = wSP(td.getDateIndx(wSP(:,1), pres):end,:); if (size(wSPnow,1) > size(wNow)), wSPnow(1,:) = []; end
    mSPnow = mSP(td.getDateIndx(mSP(:,1), pres):end,:); if (size(mSPnow,1) > size(mNow)), mSPnow(1,:) = []; end
    
    stockBeta = ta.calcBeta(dNow, dSPnow);
    
    
    dNow = dNow(1:window_size*10+1,:);
    wNow = wNow(1:window_size*4+1,:);
    mNow = mNow(1:window_size*2+1,:);
    
    dSPnow = dSPnow(1:window_size*10+1,:);
    wSPnow = wSPnow(1:window_size*4+1,:);
    mSPnow = mSPnow(1:window_size*2+1,:);
    
    %     stockBeta = ta.calcBeta(dNow, dSPnow);
    
    
    
    
    [hiD, loD, clD, opD, daD] = tf.returnOHLCDarray(dNow);
    [hiW, loW, clW, opW, daW] = tf.returnOHLCDarray(wNow);
    [hiM, loM, clM, opM, daM] = tf.returnOHLCDarray(mNow);
    
    
    
    %         [clSmaD, clAmaD, clRmaD] = ta.getMovingAvgs(dNow, dSPnow, window_size, stockBeta);
    %         [clSmaW, clAmaW, clRmaW] = ta.getMovingAvgs(wNow, wSPnow, window_size, stockBeta);
    %         [clSmaM, clAmaM, clRmaM] = ta.getMovingAvgs(mNow, mSPnow, window_size, stockBeta);
    
    [clSmaD, clAmaD, clRmaD] = ta.getMovingStandard(dNow, dSPnow, window_size);
    [clSmaW, clAmaW, clRmaW] = ta.getMovingStandard(wNow, wSPnow, window_size);
    [clSmaM, clAmaM, clRmaM] = ta.getMovingStandard(mNow, mSPnow, window_size);
    
    
    
    
    dtodayf = [daD, flipud(tsmovavg(flipud(dNow(:,5)),'e',window_size*2,1))];
    wtodayf = [daW, flipud(tsmovavg(flipud(wNow(:,5)),'e',window_size*2,1))];
    mtodayf = [daM, flipud(tsmovavg(flipud(mNow(:,5)),'e',window_size,1))];
    
    dervD = flipud(diff(flipud(dtodayf(:,2))));
    sdervD = flipud(diff(flipud(dervD)));
    dervRawD = flipud(diff(flipud(clRmaD)));
    meanD = mean(dtodayf(~isnan(dtodayf(:,2)),2));
    
    dervW = flipud(diff(flipud(wtodayf(:,2))));
    sdervW = flipud(diff(flipud(dervW)));
    dervRawW = flipud(diff(flipud(clRmaW)));
    dervIdxW = flipud(diff(flipud(clAmaW)));
    meanW = mean(wtodayf(~isnan(wtodayf(:,2)),2));
    
    dervM = flipud(diff(flipud(mtodayf(:,2))));
    sdervM = flipud(diff(flipud(dervM)));
    meanM = mean(mtodayf(~isnan(mtodayf(:,2)),2));
    
    if enteredL == 0
        if dervM(1) > dervM(2)
            if dervW(1) > dervW(2)
                if dervD(1) > dervD(2)
                    if dervRawW(1) >= 0 & dervIdxW(1) >= 0 & clSmaD(1) > dtodayf(1,2) & clSmaD(2) <= dtodayf(2,2)
                        %                         if dervRawD(1) >= 0 & dervRawD(2) < 0
                        enterLong = [enterLong; [dtodayf(1,1), dtodayf(1,2)]];
                        enteredL = 1;
                        set(handles.corr, 'Value', 1);
                        priceEnteredL = [priceEnteredL; [clD(1), 0, 0]];
                        %                         end
                    end
                end
            end
        end
    else
        if dervD(1) < dervD(2)
            exitLong = [exitLong; [dtodayf(1,1), dtodayf(1,2)]];
            enteredL = 0;
            priceEnteredL(end,2) = clD(1);
            priceEnteredL(end,3) = (priceEnteredL(end,2) - priceEnteredL(end,1)) / priceEnteredL(end,1) * 100
            disp(sum(priceEnteredL(:,3)));
        end
    end
    
    
    if enteredS == 0
        if dervM(1) < dervM(2)
            if dervW(1) < dervW(2)
                if dervD(1) < dervD(2)
                    if dervRawW(1) <= 0 & dervIdxW(1) <= 0 & clSmaD(1) < dtodayf(1,2) & clSmaD(2) >= dtodayf(2,2)
                        %                         if dervRawD(1) >= 0 & dervRawD(2) < 0
                        enterShort = [enterShort; [dtodayf(1,1), dtodayf(1,2)]];
                        enteredS = 1;
                        set(handles.corr, 'Value', 1);
                        priceEnteredS = [priceEnteredS; [clD(1), 0, 0]];
                        %                         end
                    end
                end
            end
        end
    else
        if dervD(1) > dervD(2)
            exitShort = [exitShort; [dtodayf(1,1), dtodayf(1,2)]];
            enteredS = 0;
            priceEnteredS(end,2) = clD(1);
            priceEnteredS(end,3) = (priceEnteredS(end,1) - priceEnteredS(end,2)) / priceEnteredS(end,1) * 100
            disp(sum(priceEnteredS(:,3)));
        end
    end
    
    
    
    %     if get(handles.corr, 'Value');
    subplot(3,1,1)
    cla
    hold on;
    
    highlow(hiD, loD, opD, clD, 'red', daD);
    plot(dtodayf(:,1), dtodayf(:,2), 'm', 'Marker' , '.');
    plot(daD, clD, 'r.');
    plot(daD(1:end-1), dervD*5+meanD, 'k', 'Marker' , '.')
    plot([daD(1,1), daD(end,1)], [meanD, meanD], 'k')
    plot(enterLong(:,1), enterLong(:,2),'go');
    plot(exitLong(:,1), exitLong(:,2),'ko');
    plot(enterShort(:,1), enterShort(:,2),'ro');
    plot(exitShort(:,1), exitShort(:,2),'ko');
    
    plot(daD, clSmaD, 'r', 'Marker', '.'); plot(daD, clAmaD, 'b.'); plot(daD, clRmaD, 'color', [0.70,0.70,0.70], 'Marker', '.');
    
    yOne = ylim;
    xlim([pres-75, pres+10]);
    
    subplot(3,1,2)
    cla
    hold on;
    highlow(hiW, loW, opW, clW, 'red', daW);
    plot(wtodayf(:,1), wtodayf(:,2), 'm', 'Marker' , '.');
    plot(daW(1:end-1), dervW*5+meanW, 'k', 'Marker' , '.')
    plot([daW(1,1), daW(end,1)], [meanW, meanW], 'k')
    plot(daW, clSmaW, 'r', 'Marker', '.'); plot(daW, clAmaW, 'b.'); plot(daW, clRmaW, 'color', [0.70,0.70,0.70], 'Marker', '.');
    
    yTwo = ylim;
    xlim([pres-200, pres+10]);
    
    subplot(3,1,3)
    cla
    hold on;
    highlow(hiM, loM, opM, clM, 'red', daM);
    plot(mtodayf(:,1), mtodayf(:,2), 'm', 'Marker' , '.');
    plot(daM(1:end-1), dervM*5+meanM, 'k', 'Marker' , '.')
    plot([daM(1,1), daM(end,1)], [meanM, meanM], 'k');
    plot(daM, clSmaM, 'r', 'Marker', '.'); plot(daM, clAmaM, 'b.'); plot(daM, clRmaM, 'color', [0.70,0.70,0.70], 'Marker', '.');
    
    yThree = ylim;
    xlim([pres-250, pres+10]);
    
    
    dateWatcher = dateIndx;
    while dateWatcher == dateIndx
        if get(handles.movingAverage, 'Value')
            dateIndx = dateIndx - 1
        end
        
        if get(handles.accessSecondary, 'Value')
            dateIndx = dateIndx + 1
        end
        
        pause(0.1);
    end
    
    set(handles.movingAverage, 'Value', 0 );
    set(handles.accessSecondary, 'Value', 0);
    
    
    if get(handles.corrCong, 'Value')
        set(handles.corrCong, 'Value', 0);
        break;
    end
    
    %     end
    
    %     end
    
end



%% FIND LONG TERM ANSWERS FIRST. MAKE SOLVER KNOWING LONG TERM TREND.

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