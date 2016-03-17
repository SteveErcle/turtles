clc; 
clear all; 
close all;

simPres         = 1;
aniLen          = 1;
axisLen         = 100;
aniSpeed        = 0.1;

daysForCrossVal = 10;
daysIntoPast    = 400;

stock = 'MENT'
exchange = 'NYSE';


past = '1/1/06';
simulateFrom = '1/1/12';
simulateTo = '3/1/16';

arduinoControl = 1;

%%

ts = TurtleSim;
tf = TurtleFun;
td = TurtleData;
delete(turtleSimGui)


% [mAll, mCong, wAll, wCong, dAll, dCong] = td.getData(stock, past, simulateFrom, simulateTo);
% td.saveData(stock, mAll, mCong, wAll, wCong, dAll,dCong);
[mAll, mCong, wAll, wCong, dAll, dCong] = td.loadData(stock);

startDay = dCong(end,1);

simPres = td.getDateIndx(dAll(:,1), startDay)-20;
aniLen = 20;

handles = guihandles(turtleSimGui);

dPast = td.resetPast(dCong, dAll, startDay);
wPast = td.resetPast(wCong, wAll, startDay);
mPast = td.resetPast(mCong, mAll, startDay);

hlcoDs = TurtleVal(dCong);
hlcoDp = TurtleVal(dAll);

ts.dAll = dAll;
ts.dCong = dCong; ts.wCong = wCong; ts.mCong = mCong;
ts.initHandles(handles, simPres, aniLen, axisLen, aniSpeed, dAll);
ts.setButtons(handles, 'none');

if arduinoControl == 1
    try
    a = arduino('/dev/tty.usbmodem1411','Uno')
    catch
        disp('No Arduino detected');
        disp('Switiching to GUI control');
        arduinoControl = 0;
        a = [];
        
    end
else
    a = [];
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
    levels = [];
end


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
        
        [~, pDp, pD] = tf.resetPlot(fD, dPast, startDay, levels, dAll);
        [~, pWp, pW] = tf.resetPlot(fW, wPast, startDay, levels, dAll);
        [~, pMp, pM] = tf.resetPlot(fM, mPast, startDay, levels, dAll);
        pMarket     = [0,0,0];
        runnerUp    = [1,1,1];
        runnerDown  = [1,1,1];
        ts.runnerUpArr = [];
        ts.runnerDownArr = [];
        ts.volumeArr = []; 
        ts.maxStop = 10;
        
         for i_date = simDates
            
            datestr(i_date)
            ts.i_dateH = i_date;
            set(handles.showDate,'String', datestr(i_date));
            
            isNewDay = ts.isNewTimePeriod(dCong, i_date);
            isNewWeek = ts.isNewTimePeriod(wCong, i_date);
            isNewMonth = ts.isNewTimePeriod(mCong, i_date);
       
            OpCl = 1;
            [pDo, axisLen, axisParams] = ts.animateOpen(aniSpeed, get(handles.D, 'Value'), isNewDay, dCong, i_date,...
                fD, 0.5, handles, axisLen, axisParams, OpCl);
            [pWo, axisLen, axisParams] = ts.animateOpen(aniSpeed, get(handles.W, 'Value'), isNewWeek, wCong, i_date,...
                fW, 3, handles, axisLen, axisParams, OpCl);
            [pMo, axisLen, axisParams] = ts.animateOpen(aniSpeed, get(handles.M, 'Value'), isNewMonth, mCong, i_date,...
                fM, 5, handles, axisLen, axisParams, OpCl);
            ts.plotAnnotation(OpCl);
            
            [pMarket, levels, axisLen, axisParams] = ts.playTurtles(handles, pMarket, levels, axisLen, axisParams, simDates, i_date, dAll, OpCl, a);
            
            OpCl = 2;
            [pD, axisLen, axisParams] = ts.animateClose(aniSpeed, get(handles.D, 'Value'), isNewDay, dCong, i_date,...
                fD, pD, pDo, 0.5, handles, axisLen, axisParams, OpCl);
            [pW, axisLen, axisParams] = ts.animateClose(aniSpeed, get(handles.W, 'Value'), isNewWeek, wCong, i_date,...
                fW, pW, pWo, 3, handles, axisLen, axisParams, OpCl);
            [pM, axisLen, axisParams] = ts.animateClose(aniSpeed, get(handles.M, 'Value'), isNewMonth, mCong, i_date,...
                fM, pM, pMo, 5, handles, axisLen, axisParams, OpCl);
            ts.plotAnnotation(OpCl);
            
            ts.trackVolume(handles, OpCl);
            [runnerUp, runnerDown] = ts.trackTime(handles, dAll, runnerUp, runnerDown, OpCl, fD);
            [runnerUp, runnerDown] = ts.trackTime(handles, wAll, runnerUp, runnerDown, OpCl, fW);
            [runnerUp, runnerDown] = ts.trackTime(handles, mAll, runnerUp, runnerDown, OpCl, fM);
                                                  
            
            
            [pMarket, levels, axisLen, axisParams] = ts.playTurtles(handles, pMarket, levels, axisLen, axisParams, simDates, i_date, dAll, OpCl, a);
            
            [aniSpeed, aniLen] = ts.setAnimation(handles, i_date, simDates);
              
        end
        
    else
        
        [axisLen, axisParams] = ts.setAxis(handles, axisLen, axisParams, simDates(end), 0);
        
        [levels] = ts.plotLevel(handles, levels, dAll);
        
        pause(0.01)
        
    end
    
end



% Build checker












