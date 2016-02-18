clc; clear all; close all;

simPres         = 20;
aniLen          = 1;
axisLen         = 100;
aniSpeed        = 0.1;

daysForCrossVal = 10;
daysIntoPast    = 400;

stock = 'CLDX'
exchange = 'NYSE';


past = '1/1/15';
simulateFrom = '11/15/15';
simulateTo = '1/1/16';

%%

ts = TurtleSim;
tf = TurtleFun;
td = TurtleData;
delete(turtleSimGui)
handles = guihandles(turtleSimGui);

% [mPast, mCong, wPast, wCong, dPast, dCong] = td.getData(stock, past, simulateFrom, simulateTo)
[mAll, mCong, wAll, wCong, dAll, dCong] = td.loadData(stock);

startDay = dCong(end,1);

dPast = td.resetPast(dCong, dAll, startDay);
wPast = td.resetPast(wCong, wAll, startDay);
mPast = td.resetPast(mCong, mAll, startDay);

hlcoDs = TurtleVal(dCong);
hlcoDp = TurtleVal(dAll);


ts.initHandles(handles, simPres, aniLen, axisLen, aniSpeed, dAll);
ts.setButtons(handles, 'none');




for init_Plots = 1:1
    
    figure
    
    [fD, pDp] = tf.resetPlot(1, dPast, startDay);
    title(strcat(stock,' Daily'));
    datetick('x',12, 'keeplimits');
    
    figure
    [fW, pWp] = tf.resetPlot(2, wPast, startDay);
    title(strcat(stock,' Weekly'));
    datetick('x',12, 'keeplimits');
    
    figure
    [fM, pMp] = tf.resetPlot(3, mPast, startDay);
    title(strcat(stock,' Monthly'));
    datetick('x',12, 'keeplimits');
    
    axisParams = [1,1,1,1];
    pMarket = [0,0,0];
    
   
    
end


while(true)
    
    if get(handles.runAnimation, 'Value')
        
        [simPres] = ts.getSimulationPresent(handles)
        
        simDates = flipud(hlcoDs.da(simPres:simPres + aniLen))';
        
        dPast = td.resetPast(dCong, dAll, simDates(1));
        wPast = td.resetPast(wCong, wAll, simDates(1));
        mPast = td.resetPast(mCong, mAll, simDates(1));
        
        [~, pDp, pD] = tf.resetPlot(fD, dPast, startDay);
        [~, pWp, pW] = tf.resetPlot(fW, wPast, startDay);
        [~, pMp, pM] = tf.resetPlot(fM, mPast, startDay);
        
        
        axis([simDates(1)-50, simDates(end)+10, 0, 20])
        
        
        disp('simPres:    aniLen:   ')
        disp([simPres, aniLen])
        
        
        for i_date = simDates
            
            datestr(i_date)

            isNewDay = ts.isNewTimePeriod(dCong, i_date)
            isNewWeek = ts.isNewTimePeriod(wCong, i_date)
            isNewMonth = ts.isNewTimePeriod(mCong, i_date)
            
            [pDo, axisLen, axisParams] = ts.animateOpen(aniSpeed, get(handles.D, 'Value'), isNewDay, dCong, i_date,...
                fD, 0.5, handles, axisLen, axisParams);
            [pWo, axisLen, axisParams] = ts.animateOpen(aniSpeed, get(handles.W, 'Value'), isNewWeek, wCong, i_date,...
                fW, 3, handles, axisLen, axisParams);
            [pMo, axisLen, axisParams] = ts.animateOpen(aniSpeed, get(handles.M, 'Value'), isNewMonth, mCong, i_date,...
                fM, 5, handles, axisLen, axisParams);

            [pD, axisLen, axisParams] = ts.animateClose(aniSpeed, get(handles.D, 'Value'), isNewDay, dCong, i_date,...
                fD, pD, pDo, 0.5, handles, axisLen, axisParams);
            [pW, axisLen, axisParams] = ts.animateClose(aniSpeed, get(handles.W, 'Value'), isNewWeek, wCong, i_date,...
                fW, pW, pWo, 3, handles, axisLen, axisParams);
            [pM, axisLen, axisParams] = ts.animateClose(aniSpeed, get(handles.M, 'Value'), isNewMonth, mCong, i_date,...
                fM, pM, pMo, 5, handles, axisLen, axisParams);
            
            [aniSpeed, aniLen] = ts.setAnimation(handles, 0, simPres);
            
        end
        
    else
        
        %         [axisLen, axisParams] = ts.setAxis(handles, axisLen, axisParams, hlcoD);
        
        
        
    end
    
    pause(0.01)
    
end


sprintf('Done')


% axis
% stop animation
% start line
% levels
% market transactions



% Trivial Fixes
% --------------
% M --> W should turn off M
% Fix axis Len slider smaller should be further















