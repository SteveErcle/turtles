clc; clear all; close all;

ts = TurtleSim;
tf = TurtleFun;
delete(turtleSimGui)
handles = guihandles(turtleSimGui);
ts.setButtons(handles, 'none');

set(handles.simPres, 'Value', 100);
set(handles.simPres, 'Max', 150, 'Min', 1);
set(handles.simPres, 'SliderStep', [1/150, 10/150]);


set(handles.aniLen, 'Value', 140);
set(handles.aniLen, 'Max', 150, 'Min', 1);
set(handles.aniLen, 'SliderStep', [1/150, 10/150]);

set(handles.aniSpeed, 'Value', 0.5);
set(handles.aniSpeed, 'Max', 1, 'Min', 0.01);
set(handles.aniSpeed, 'SliderStep', [1/100, 10/100]);

stock = 'CLDX'
exchange = 'NYSE'

%
c = yahoo;
% m = fetch(c,stock,now-50, now-400, 'm');
% w = fetch(c,stock,now-50, now-400, 'w');
% d = fetch(c,stock,now-50, now-400, 'd');
%
% hlcoM = TurtleVal(m);
% hlcoW = TurtleVal(w);
% hlcoD = TurtleVal(d);

m = fetch(c,stock,now-10, now-400, 'm');
w = fetch(c,stock,now-10, now-400, 'w');
d = fetch(c,stock,now-10, now-400, 'd');

hlcoMs = TurtleVal(m);
hlcoWs = TurtleVal(w);
hlcoDs = TurtleVal(d);


daysFromCurrent = get(handles.aniLen, 'Max') - floor(get(handles.aniLen, 'Value')) +1
simPres = get(handles.simPres, 'Max') - floor(get(handles.simPres, 'Value')) + 1
daysFromPresent = daysFromCurrent + simPres

[hlcoD] = ts.resetAnimation(daysFromPresent, hlcoDs, hlcoDs);
[hlcoW] = ts.resetAnimation(daysFromPresent, hlcoWs, hlcoDs);
[hlcoM] = ts.resetAnimation(daysFromPresent, hlcoMs, hlcoDs);


figure
[fM,pM] = tf.plotHiLo(hlcoM);
title(strcat(stock,' Monthly'))
datetick('x',12, 'keeplimits');

figure
[fW,pW] = tf.plotHiLo(hlcoW);
title(strcat(stock,' Weekly'))
datetick('x',12, 'keeplimits');

figure
[fD,pD] = tf.plotHiLo(hlcoD);
title(strcat(stock,' Daily'))
datetick('x',12, 'keeplimits');


aniSpeed = 0.025

startSimIndx = find(hlcoD.da(1) == hlcoDs.da)-1;
startSimDate = datestr(hlcoDs.da(startSimIndx))

simPres = 1;

while(true)
    
    
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
        
        aniSpeed = get(handles.aniSpeed, 'Value');
        pause(aniSpeed)
        
        
        
    end
    
    daysFromCurrent = get(handles.aniLen, 'Max') - floor(get(handles.aniLen, 'Value')) +1
    simPres = get(handles.simPres, 'Max') - floor(get(handles.simPres, 'Value')) + 1
    daysFromPresent = daysFromCurrent + simPres
    
    [hlcoD] = ts.resetAnimation(daysFromPresent, hlcoDs, hlcoDs);
    [hlcoW] = ts.resetAnimation(daysFromPresent, hlcoWs, hlcoDs);
    [hlcoM] = ts.resetAnimation(daysFromPresent, hlcoMs, hlcoDs);
    
    
    startSimIndx = find(hlcoD.da(1) == hlcoDs.da)-1;
    
    
end


sprintf('Done')



















