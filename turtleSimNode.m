clc; clear all; close all;

simPres         = 50;
aniLen          = 1;
axisLen         = 100;
aniSpeed        = 0.1;

daysForCrossVal = 10;
daysIntoPast    = 400;

stock = 'CLDX'
exchange = 'NYSE';

%%

ts = TurtleSim;
tf = TurtleFun;
delete(turtleSimGui)
handles = guihandles(turtleSimGui);

ts.initHandles(handles, simPres, aniLen, axisLen, aniSpeed)
ts.setButtons(handles, 'none');

[hlcoDs, hlcoWs, hlcoMs] = ts.initData(stock, daysForCrossVal, daysIntoPast);
[hlcoD, hlcoW, hlcoM] = ts.resetAll(handles, hlcoDs, hlcoWs, hlcoMs);

for init_Plots = 1:1
    figure
    [fM,pM] = tf.plotHiLo(hlcoM);
    tf.plotStartDay(simPres, hlcoDs);
    title(strcat(stock,' Monthly'))
    datetick('x',12, 'keeplimits');
    
    figure
    [fW,pW] = tf.plotHiLo(hlcoW);
    tf.plotStartDay(simPres, hlcoDs);
    title(strcat(stock,' Weekly'))
    datetick('x',12, 'keeplimits');
    
    figure
    [fD,pD] = tf.plotHiLo(hlcoD);
    tf.plotStartDay(simPres, hlcoDs);
    title(strcat(stock,' Daily'))
    datetick('x',12, 'keeplimits');
    
    axisParams = [1,1,1,1];
end

startSimIndx = find(hlcoD.da(1) == hlcoDs.da)-1;

while(true)
    
    if get(handles.runAnimation, 'Value')
        
        [hlcoD, hlcoW, hlcoM] = ts.resetAll(handles, hlcoDs, hlcoWs, hlcoMs);
        [simPres] = ts.getSimulationPresent(handles);
        
        startSimIndx = find(hlcoD.da(1) == hlcoDs.da)-1;
        
        for curIndx = startSimIndx:-1:simPres
            
            datestr(hlcoDs.da(curIndx))
            
            hlcoD = ts.updateDay(curIndx, hlcoDs, hlcoD);
            hlcoW = ts.update(hlcoW, hlcoWs, hlcoD);
            hlcoM = ts.update(hlcoM, hlcoMs, hlcoD);
            
            isNewDay = ts.isNewTimePeriod(hlcoDs, hlcoD);
            [pDo, axisLen, axisParams] = ts.animateOpen(aniSpeed, get(handles.D, 'Value'), isNewDay, hlcoD, fD,...
                handles, axisLen, axisParams, hlcoD);
            [pD] = ts.animateClose(aniSpeed, get(handles.D, 'Value'), isNewDay, hlcoD, fD, pD, pDo,...
                handles, axisLen, axisParams, hlcoD);

            isNewWeek = ts.isNewTimePeriod(hlcoWs, hlcoD);
            [pWo] = ts.animateOpen(aniSpeed, get(handles.W, 'Value'), isNewWeek, hlcoW, fW,...
                handles, axisLen, axisParams, hlcoD);
            [pW] = ts.animateClose(aniSpeed, get(handles.W, 'Value'), isNewWeek, hlcoW, fW, pW, pWo,...
                handles, axisLen, axisParams, hlcoD);
            
            isNewMonth = ts.isNewTimePeriod(hlcoMs, hlcoD);
            [pMo] = ts.animateOpen(aniSpeed, get(handles.M, 'Value'), isNewMonth, hlcoM, fM,...
                handles, axisLen, axisParams, hlcoD);
            [pM] = ts.animateClose(aniSpeed, get(handles.M, 'Value'), isNewMonth, hlcoM, fM, pM, pMo,...
                handles, axisLen, axisParams, hlcoD);
            
            if ~ts.isUpdateCorrect(hlcoMs, hlcoM) || ~ts.isUpdateCorrect(hlcoWs, hlcoW) ||...
                    ~ts.isUpdateCorrect(hlcoDs, hlcoD)
                return
            end
                        
            [axisLen, axisParams] = ts.setAxis(handles, axisLen, axisParams, hlcoD);
            
            [aniSpeed] = ts.setAnimation(handles, curIndx, simPres)
            
%             ts.playTurtles(handles, curIndx, simPres, hlcoDs)

        end
        
    else
              
        [axisLen, axisParams] = ts.setAxis(handles, axisLen, axisParams, hlcoD);
   
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
% Update gui text
% View the future blank space















