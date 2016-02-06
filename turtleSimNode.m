clc; clear all; close all;

ts = TurtleSim;
tf = TurtleFun;
delete(turtleSimGui)
handles = guihandles(turtleSimGui);
ts.resetButtons(handles);

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

startSimIndx = find(hlcoD.da(1) == hlcoDs.da)-1;
startSimDate = datestr(hlcoDs.da(startSimIndx))

figure
[fM,pM] = tf.plotHiLo(hlcoM)

figure
[fW,pW] = tf.plotHiLo(hlcoW)

figure
[fD,pD] = tf.plotHiLo(hlcoD)

pause

for i = 0:startSimIndx-1
    
    curIndx = startSimIndx-i;
    datestr(hlcoDs.da(curIndx))
    
    hlcoD = ts.updateDay(curIndx, hlcoDs, hlcoD);
    hlcoW = ts.updateWeek(hlcoW, hlcoWs, hlcoD);
    hlcoM = ts.updateMonth(hlcoM, hlcoMs, hlcoD);
    
    figure(fD)
    [~,pDo] = tf.plotOpen(hlcoD);
    
    if ts.isNewTimePeriod(hlcoWs, hlcoD)
        figure(fW)
        [~,pWo] = tf.plotOpen(hlcoW);
    end
    
    if ts.isNewTimePeriod(hlcoMs, hlcoD)
        figure(fM)
        [~,pMo] = tf.plotOpen(hlcoM);
    end
    
    pause(0.1)
    
    
    figure(fD)
    delete(pDo);
    delete(pD);
    [~,pD] = tf.plotHiLo(hlcoD);
    
    figure(fW)
    if ts.isNewTimePeriod(hlcoWs, hlcoD)
        delete(pWo);
    end
    delete(pW);
    [~,pW] = tf.plotHiLo(hlcoW);
    
    figure(fM)
    if ts.isNewTimePeriod(hlcoMs, hlcoD)
        delete(pMo);
    end
    
    delete(pM)
    [~,pM] = tf.plotHiLo(hlcoM)
    
    pause(0.1)
    
    
    %     figure(fM)
    %     delete(pM)
    %     [~,pM] = tf.plotHiLo(hlcoM)
    %     pause
    
    %     figure(fW)
    %     delete(pW)
    %     [~,pW] = tf.plotHiLo(hlcoW)
    %     pause
    
    %     m = fetch(c,stock,now-50, hlcoDs.da(curIndx), 'm');
    %     w = fetch(c,stock,now-50, hlcoDs.da(curIndx) , 'w');
    %
    %     figure(3)
    %     tf.plotHiLo(m)
    %     figure(4)
    %     tf.plotHiLo(w)
    
    %     pause(0.1)
    
    
    
end

% m = fetch(c,stock, now-50 , now-400, 'm');
[hiMt, loMt, clMt, opMt, daMt] = tf.returnOHLCDarray(m);

hlcoM.hi == hiMt
hlcoM.lo == loMt
hlcoM.cl == clMt
hlcoM.op == opMt
hlcoM.da == daMt







sprintf('Done')

return
figure()
figM = tf.plotHiLo(m);
title(strcat(stock,' Monthly'))

figure()
figW = tf.plotHiLo(w);
title(strcat(stock,' Weekly'))

figure()
figD = tf.plotHiLo(d);
title(strcat(stock,' Daily'))

% m = fetch(c,stock,now-49, now-49, 'm');
% w = fetch(c,stock,now-50, now-100, 'w');

pause
for i = 1:10
    d = fetch(c,stock,now-(50-i-5), now-(50-i), 'd');
    tf.plotHiLo(d);
    
    pause
end



while(true)
    
    
    if get(handles.M, 'Value') == 1
        figure(figM)
    end
    
    if get(handles.W, 'Value') == 1
        figure(figW)
    end
    
    if get(handles.D, 'Value') == 1
        figure(figD)
    end
    
    ts.resetButtons(handles);
    
    pause(0.025)
    
end
