clc; clear all; close all;

ts = TurtleSim;
tf = TurtleFun;
delete(turtleSimGui)
handles = guihandles(turtleSimGui);
ts.setButtons(handles, 'none');

set(handles.simPres, 'Value', 1);
set(handles.simPres, 'Max', 150, 'Min', 1);
set(handles.simPres, 'SliderStep', [1/150, 10/150]);


set(handles.aniLen, 'Value', 10);
set(handles.aniLen, 'Max', 150, 'Min', 1);
set(handles.aniLen, 'SliderStep', [1/150, 10/150]);

stock = 'CLDX'
exchange = 'NYSE'


c = yahoo;
m = fetch(c,stock,now-50, now-400, 'm');
w = fetch(c,stock,now-50, now-400, 'w');
d = fetch(c,stock,now-50, now-400, 'd');

hlcoM = TurtleVal(m);
hlcoW = TurtleVal(w);
hlcoD = TurtleVal(d);

m = fetch(c,stock,now-10, now-400, 'm');
w = fetch(c,stock,now-10, now-400, 'w');
d = fetch(c,stock,now-10, now-400, 'd');

hlcoMs = TurtleVal(m);
hlcoWs = TurtleVal(w);
hlcoDs = TurtleVal(d);


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

hlcoMstore = hlcoM;
hlcoWstore = hlcoW;
hlcoDstore = hlcoD;


aniSpeed = 0.025

startSimIndx = find(hlcoD.da(1) == hlcoDs.da)-1;
startSimDate = datestr(hlcoDs.da(startSimIndx))



while(true)
    
    simPres = get(handles.simPres, 'Value');
    
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
        
        %         if ~ts.isUpdateCorrect(hlcoMs, hlcoM) || ~ts.isUpdateCorrect(hlcoWs, hlcoW) ||...
        %                 ~ts.isUpdateCorrect(hlcoDs, hlcoD)
        %             return
        %         end
        
        if ~ts.isUpdateCorrect(hlcoMs, hlcoM)
            sprintf('Error M')
            return
        end
        
        if ~ts.isUpdateCorrect(hlcoWs, hlcoW)
            sprintf('Error W')
            return
        end
        
        if ~ts.isUpdateCorrect(hlcoDs, hlcoD)
            sprintf('Error D')
            return
        end
        
        if get(handles.V, 'Value')
            break
        end
        
        pause(aniSpeed)
        
    end
    
    pause
    
    daysFromCurrent = get(handles.aniLen, 'Value');
    daysFromPresent = daysFromCurrent + simPres;
    
    [hlcoM, hlcoW, hlcoD] = ts.resetAnimation(daysFromPresent, hlcoM, hlcoW, hlcoD,...
        hlcoMs, hlcoWs, hlcoDs);
    
    startSimIndx = find(hlcoD.da(1) == hlcoDs.da)-1;
    
    
end


% m = fetch(c,stock, now-50 , now-400, 'm');
[hiMt, loMt, clMt, opMt, daMt] = tf.returnOHLCDarray(m);

hlcoM.hi == hiMt
hlcoM.lo == loMt
hlcoM.cl == clMt
hlcoM.op == opMt
hlcoM.da == daMt


for i  = 1:100
    i
    if i == 10
        break
    end
end


sprintf('Done')



















