clc; close all; clear all; 

simPres         = 1;
aniLen          = 1;
axisLen         = 100;
aniSpeed        = 0.1;

daysForCrossVal = 10;
daysIntoPast    = 400;

stock = 'AXL'
exchange = 'NYSE';
FETCH = 0;

past = '1/1/2006';
simulateFrom = '1/1/16';
simulateTo = now;

arduinoControl = 1;

%%

ts = TurtleSim;
tf = TurtleFun;
td = TurtleData;
delete(turtleSimGui)

c = yahoo;
averages = '^GSPC';
dAvg = fetch(c,averages,past, simulateTo, 'd');
close(c);

if FETCH == 1
    [mAll, mCong, wAll, wCong, dAll, dCong, iAll] = td.getData(stock, past, simulateFrom, simulateTo);
    td.saveData(stock, mAll, mCong, wAll, wCong, dAll, dCong, iAll);
else
    [mAll, mCong, wAll, wCong, dAll, dCong, iAll] = td.loadData(stock);
end

startDay = dCong(end,1);

simPres = td.getDateIndx(dAll(:,1), startDay)-20;
aniLen = 20;

handles = guihandles(turtleSimGui);
ts.handles = handles;

dPast = td.resetPast(dCong, dAll, startDay);
wPast = td.resetPast(wCong, wAll, startDay);
mPast = td.resetPast(mCong, mAll, startDay);

hlcoDs = TurtleVal(dCong);
hlcoDp = TurtleVal(dAll);

ts.dAll = dAll;
ts.iAll = iAll;
ts.dAvg = dAvg;
ts.dCong = dCong; ts.wCong = wCong; ts.mCong = mCong;
ts.initHandles(handles, simPres, aniLen, axisLen, aniSpeed, dAll);
ts.setButtons(handles, 'none');

if arduinoControl == 1
    try
        ts.a = arduino('/dev/tty.usbmodem1411','Uno');
    catch
        disp('No Arduino detected');
        disp('Switiching to GUI control');
        arduinoControl = 0;
        ts.a = [];
        
    end
else
    ts.a = [];
end

for init_Plots = 1:1
    
    figure
    
    [fD, pDp] = tf.resetPlot(1, dPast, startDay, [], []);
    title(strcat(stock,' Daily'));
    datetick('x',12, 'keeplimits');
    set(gcf, 'Position', [-1081,1238,1080,542]);
    
    
    %     1441 => Right Side
    
    figure
    [fW, pWp] = tf.resetPlot(2, wPast, startDay, [], []);
    title(strcat(stock,' Weekly'));
    datetick('x',12, 'keeplimits');
    set(gcf, 'Position', [-1081,583,1080,542]);
    
    figure
    [fM, pMp] = tf.resetPlot(3, mPast, startDay, [], []);
    title(strcat(stock,' Monthly'));
    datetick('x',12, 'keeplimits');
    set(gcf, 'Position', [-1081,10,1080,542]);
    
    axisParams = [1,1,1,1];
    pMarket = [0,0,0];
    ts.levels = [];
end

fInt = figure(4);
fAvg = figure(5);


while(true)
    
    
    if ~isempty(get(handles.simPresEditBox,'String'))
        simPres = td.getDateIndx(dAll(:,1), get(handles.simPresEditBox,'String'));
    end
    
    if ~isempty(get(handles.aniLenEditBox,'String'))
        aniLen = td.getDateIndx(dAll(:,1), get(handles.aniLenEditBox,'String')) - simPres;
    end
    
    simDatesIndxs = simPres:simPres + aniLen;
    
    if simDatesIndxs(end) > length(hlcoDs.da)
        simDatesIndxs = simPres:length(hlcoDs.da);
    end
    
    if simPres > length(hlcoDs.da)
        simDatesIndxs = length(hlcoDs.da):length(hlcoDs.da);
    end
    
    simDates = flipud(hlcoDs.da(simDatesIndxs))';
    
    if get(handles.runAnimation, 'Value')
        
        dPast = td.resetPast(dCong, dAll, simDates(1));
        wPast = td.resetPast(wCong, wAll, simDates(1));
        mPast = td.resetPast(mCong, mAll, simDates(1));
        
        [~, pDp, pD] = tf.resetPlot(fD, dPast, startDay, ts.levels, dAll);
        [~, pWp, pW] = tf.resetPlot(fW, wPast, startDay, ts.levels, dAll);
        [~, pMp, pM] = tf.resetPlot(fM, mPast, startDay, ts.levels, dAll);
        pMarket     = [0,0,0];
        runnerUp    = [1,1,1];
        runnerDown  = [1,1,1];
        ts.runnerUpArr = [];
        ts.runnerDownArr = [];
        ts.volumeArr = [];
        ts.maxStop = 10;
        
        for i_date = simDates
            
            if get(handles.runAnimation, 'Value')
                
                datestr(i_date)
                ts.i_dateH = i_date;
                set(handles.showDate,'String', datestr(i_date));
                
                isNewDay = ts.isNewTimePeriod(dCong, i_date);
                isNewWeek = ts.isNewTimePeriod(wCong, i_date);
                isNewMonth = ts.isNewTimePeriod(mCong, i_date);
                
                OpCl = 1;
                ts.OpCl = 1;
                [pDo, axisLen, axisParams] = ts.animateOpen(aniSpeed, get(handles.D, 'Value'), isNewDay, dCong, i_date,...
                    fD, 0.5, handles, axisLen, axisParams, OpCl);
                [pWo, axisLen, axisParams] = ts.animateOpen(aniSpeed, get(handles.W, 'Value'), isNewWeek, wCong, i_date,...
                    fW, 3, handles, axisLen, axisParams, OpCl);
                [pMo, axisLen, axisParams] = ts.animateOpen(aniSpeed, get(handles.M, 'Value'), isNewMonth, mCong, i_date,...
                    fM, 5, handles, axisLen, axisParams, OpCl);
                ts.plotAnnotation(OpCl);
                
                [axisLen, axisParams] = ts.playTurtles(handles, axisLen, axisParams, simDates, i_date, dAll, OpCl);
                
                ts.intraDayViewer(fInt);
                
                OpCl = 2;
                ts.OpCl = 2;
                [pD, axisLen, axisParams] = ts.animateClose(aniSpeed, get(handles.D, 'Value'), isNewDay, dCong, i_date,...
                    fD, pD, pDo, 0.5, handles, axisLen, axisParams, OpCl);
                [pW, axisLen, axisParams] = ts.animateClose(aniSpeed, get(handles.W, 'Value'), isNewWeek, wCong, i_date,...
                    fW, pW, pWo, 3, handles, axisLen, axisParams, OpCl);
                [pM, axisLen, axisParams] = ts.animateClose(aniSpeed, get(handles.M, 'Value'), isNewMonth, mCong, i_date,...
                    fM, pM, pMo, 5, handles, axisLen, axisParams, OpCl);
                ts.plotAnnotation(OpCl);
                
                
%                 avgIndx = td.getDateIndx(dAvg(:,1), i_date)
%                 dateIndx = td.getDateIndx(dAll(:,1), i_date)
%                 
%                 [hiA, loA, clA, opA, daA] = tf.returnOHLCDarray(dAvg);
%                 daA(avgIndx,1)
%                
%                 [hi, lo, cl, op, da] = tf.returnOHLCDarray(dAll);
%                 da(dateIndx,1)
%                
%                 
%                 disp('Average');
%                 disp([opA(avgIndx), clA(avgIndx)]);
%                 disp('Stock');
%                 disp([op(avgIndx), cl(avgIndx)]);
%                 
%                 pointA = clA(avgIndx) - opA(avgIndx);
%                 pointS = cl(dateIndx) - op(dateIndx);
%                 
%                 set(0,'CurrentFigure',fD)
%                 if pointS > 0
%                     plot(da(dateIndx), hi(dateIndx), 'go')
%                 else
%                     plot(da(dateIndx), hi(dateIndx), 'ro')
%                 end
%                 
%                 if pointA > 0
%                     plot(da(dateIndx), lo(dateIndx), 'go')
%                 else
%                     plot(da(dateIndx), lo(dateIndx), 'ro')
%                 end
%                 
%                 
%                 set(0,'CurrentFigure',fAvg)
%                 cla(fAvg)
%                 ax = gca
%                 tf.plotHiLoMultiple(dAvg(avgIndx:end,:));
%                 axis(gca, [da(avgIndx+150), da(avgIndx)+35,...
%                     min(loA(avgIndx:avgIndx+150)),...
%                     max(hiA(avgIndx:avgIndx+150))])
                
                ts.plotMovingAvg();
                ts.trackVolume(handles, OpCl);
                [runnerUp, runnerDown] = ts.trackTime(handles, dAll, runnerUp, runnerDown, OpCl, fD);
                [runnerUp, runnerDown] = ts.trackTime(handles, wAll, runnerUp, runnerDown, OpCl, fW);
                [runnerUp, runnerDown] = ts.trackTime(handles, mAll, runnerUp, runnerDown, OpCl, fM);

                
                [axisLen, axisParams] = ts.playTurtles(handles, axisLen, axisParams, simDates, i_date, dAll, OpCl);
                
                [aniSpeed, aniLen] = ts.setAnimation(handles, i_date, simDates);
                
                
            end
        end
    else
        
        [axisLen, axisParams] = ts.setAxis(handles, axisLen, axisParams, simDates(end), 0);
        
        ts.plotLevel();
        
        pause(0.01)
        
    end
    
end



% Build checker












