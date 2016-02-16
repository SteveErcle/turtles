clc; clear all; close all;

simPres         = 10;
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

ts.initHandles(handles, simPres, aniLen, axisLen, aniSpeed)
ts.setButtons(handles, 'none');

[mPast, mCong, wPast, wCong, dPast, dCong] = td.getData(stock, past, simulateFrom, simulateTo)
hlcoDs = TurtleVal(dCong);
hlcoDp = TurtleVal(dPast);

for init_Plots = 1:1
    figure
    [fM,pM] = tf.plotHiLoMultiple(mPast(2:end,:));
    tf.plotStartDay(simPres, hlcoDp);
    title(strcat(stock,' Monthly'))
    datetick('x',12, 'keeplimits');
    
    figure
    [fW,pW] = tf.plotHiLoMultiple(wPast(2:end,:));
    tf.plotStartDay(simPres, hlcoDp);
    title(strcat(stock,' Weekly'))
    datetick('x',12, 'keeplimits');
    
    figure
    [fD,pD] = tf.plotHiLoMultiple(dPast(2:end,:));
    tf.plotStartDay(simPres, hlcoDp);
    title(strcat(stock,' Daily'))
    datetick('x',12, 'keeplimits');
    
    axisParams = [1,1,1,1];
    pMarket = [0,0,0];
end


while(true)
    
    if get(handles.runAnimation, 'Value')
        
        [simPres] = ts.getSimulationPresent(handles)
        
        simDates = flipud(hlcoDs.da(simPres-aniLen:simPres))';
        
        
        for i_date = simDates
            
            i_date
            
            dateIndx = td.getDateIndx(wCong, i_date);
            isNewDay = ts.isNewTimePeriod(dateIndx, dCong);
            isNewWeek = ts.isNewTimePeriod(dateIndx, wCong);
            isNewMonth = ts.isNewTimePeriod(dateIndx, mCong);
            
            
            
            pause(aniSpeed)
            
           
            %             [pDo, axisLen, axisParams] = ts.animateOpen(aniSpeed, get(handles.D, 'Value'), isNewDay, hlcoD, fD,...
            %                 handles, axisLen, axisParams, hlcoD);
            %             [pWo, axisLen, axisParams] = ts.animateOpen(aniSpeed, get(handles.W, 'Value'), isNewWeek, hlcoW, fW,...
            %                 handles, axisLen, axisParams, hlcoD);
            %             [pMo, axisLen, axisParams] = ts.animateOpen(aniSpeed, get(handles.M, 'Value'), isNewMonth, hlcoM, fM,...
            %                 handles, axisLen, axisParams, hlcoD);
            %
            %             [pMarket] = ts.playTurtles(handles, pMarket, curIndx, simPres, hlcoDs);
            %
            %             [pD] = ts.animateClose(aniSpeed, get(handles.D, 'Value'), isNewDay, hlcoD, fD, pD, pDo,...
            %                 handles, axisLen, axisParams, hlcoD);
            %             [pW] = ts.animateClose(aniSpeed, get(handles.W, 'Value'), isNewWeek, hlcoW, fW, pW, pWo,...
            %                 handles, axisLen, axisParams, hlcoD);
            %             [pM] = ts.animateClose(aniSpeed, get(handles.M, 'Value'), isNewMonth, hlcoM, fM, pM, pMo,...
            %                 handles, axisLen, axisParams, hlcoD);
            %
            %             [pMarket] = ts.playTurtles(handles, pMarket, curIndx, simPres, hlcoDs);
            %
            %             if ~ts.isUpdateCorrect(hlcoMs, hlcoM) || ~ts.isUpdateCorrect(hlcoWs, hlcoW) ||...
            %                     ~ts.isUpdateCorrect(hlcoDs, hlcoD)
            %                 return
            %             end
            %
            [aniSpeed, aniLen] = ts.setAnimation(handles, 0, simPres)
            %
        end
        
    else
        
%         [axisLen, axisParams] = ts.setAxis(handles, axisLen, axisParams, hlcoD);
        
        %         if get(handles.setLevel, 'Value')
        %             plot( [hlcoDs.da(end), hlcoDs.da(1)], [1,1]*20, 'k')
        %             set(handles.setLevel, 'Value', 0);
        %         end
        
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















