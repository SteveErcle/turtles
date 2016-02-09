clc; clear all; close all;

simPres         = 50;
aniLen          = 10;
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
            pD = ts.animate(aniSpeed, get(handles.D, 'Value'), isNewDay, hlcoD, fD, pD);
            
            isNewWeek = ts.isNewTimePeriod(hlcoWs, hlcoD);
            pW = ts.animate(aniSpeed, get(handles.W, 'Value'), isNewWeek, hlcoW, fW, pW);
            
            isNewMonth = ts.isNewTimePeriod(hlcoMs, hlcoD);
            pM = ts.animate(aniSpeed, get(handles.M, 'Value'), isNewMonth, hlcoM, fM, pM);
            
            if ~ts.isUpdateCorrect(hlcoMs, hlcoM) || ~ts.isUpdateCorrect(hlcoWs, hlcoW) ||...
                    ~ts.isUpdateCorrect(hlcoDs, hlcoD)
                return
            end
            
            if get(handles.V, 'Value');
                set(handles.V, 'Value', 0);
                pause
            end
            
            if get(handles.I, 'Value');
                set(handles.I, 'Value', 0);
                break
            end
            
            
            [axisLen] = ts.setAutoAxis(handles, axisLen, hlcoD);
            
            [aniSpeed] = ts.getAnimationSpeed(handles)
            
            
            if get(handles.play, 'Value')
                
                if curIndx ~= simPres
                    
                    maxMinusMin = get(handles.aniSpeed,'Max') - get(handles.aniSpeed,'Min');
                    set(handles.aniSpeed,'Value', maxMinusMin);
                    aniSpeed = 0;
                else 
                    set(handles.aniSpeed,'Value', 0.25);
                end 
                set(handles.aniLen, 'Value', get(handles.aniLen, 'Max'));
                
            end 
            
            pause(aniSpeed)

                
            
            
        end
        
    else
        
        
        [axisLen] = ts.setAutoAxis(handles, axisLen, hlcoD);
        
        
        
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















