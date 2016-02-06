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

[hiM, loM, clM, opM, daM] = tf.returnOHLCDarray(m);
hlcoM = TurtleVal(hiM, loM, clM, opM, daM);

[hiW, loW, clW, opW, daW] = tf.returnOHLCDarray(w);
hlcoW = TurtleVal(hiW, loW, clW, opW, daW);

[hiD, loD, clD, opD, daD] = tf.returnOHLCDarray(d);
hlcoD = TurtleVal(hiD, loD, clD, opD, daD);


m = fetch(c,stock,now-10, now-400, 'm');
w = fetch(c,stock,now-10, now-400, 'w');
d = fetch(c,stock,now-10, now-400, 'd');

[hiMs, loMs, clMs, opMs, daMs] = tf.returnOHLCDarray(m);
hlcoMs = TurtleVal(hiMs, loMs, clMs, opMs, daMs);

[hiWs, loWs, clWs, opWs, daWs] = tf.returnOHLCDarray(w);
hlcoWs = TurtleVal(hiWs, loWs, clWs, opWs, daWs);

[hiDs, loDs, clDs, opDs, daDs] = tf.returnOHLCDarray(d);
hlcoDs = TurtleVal(hiDs, loDs, clDs, opDs, daDs);


startSimIndx = find(daD(1) == daDs)-1;
startSimDate = datestr(daDs(startSimIndx))

figure
[fM,pM] = tf.plotHiLo(hlcoM)
figure
[fW,pW] = tf.plotHiLo(hlcoW)
% figure
% tf.plotHiLo(hlcoD)


for i = 0:startSimIndx-1
    
    curIndx = startSimIndx-i;
    datestr(hlcoDs.da(curIndx))
    
    hlcoD.op = [hlcoDs.op(curIndx); hlcoD.op];
    hlcoD.cl = [hlcoDs.cl(curIndx); hlcoD.cl];
    hlcoD.hi = [hlcoDs.hi(curIndx); hlcoD.hi];
    hlcoD.lo = [hlcoDs.lo(curIndx); hlcoD.lo];
    hlcoD.da = [hlcoDs.da(curIndx); hlcoD.da];
    
    hlcoM = ts.updateMonth(hlcoM, hlcoMs, hlcoD);
    hlcoW = ts.updateWeek(hlcoW, hlcoWs, hlcoD);
    
    
    
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

m = fetch(c,stock, now-10, now-400, 'm');
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
