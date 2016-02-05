clc; clear all; close all;

ts = TurtleSim;
tf = TurtleFun;
delete(turtleSimGui)
handles = guihandles(turtleSimGui);
ts.resetButtons(handles);

stock = 'CLDX'
exchange = 'NYSE'

c = yahoo;
m = fetch(c,stock,now-50, now-100, 'm');
w = fetch(c,stock,now-50, now-100, 'w');
d = fetch(c,stock,now-50, now-100, 'd');

[hiM, loM, clM, opM, daM] = tf.returnOHLCDarray(m);
hlcoM = TurtleVal(hiM, loM, clM, opM, daM);

[hiW, loW, clW, opW, daW] = tf.returnOHLCDarray(w);
hlcoW = TurtleVal(hiW, loW, clW, opW, daW);

[hiD, loD, clD, opD, daD] = tf.returnOHLCDarray(d);
hlcoD = TurtleVal(hiD, loD, clD, opD, daD);



m = fetch(c,stock,now-10, now-100, 'm');
w = fetch(c,stock,now-10, now-100, 'w');
d = fetch(c,stock,now-10, now-100, 'd');

[hiMs, loMs, clMs, opMs, daMs] = tf.returnOHLCDarray(m);
hlcoMs = TurtleVal(hiMs, loMs, clMs, opMs, daMs);

[hiWs, loWs, clWs, opWs, daWs] = tf.returnOHLCDarray(w);
hlcoWs = TurtleVal(hiWs, loWs, clWs, opWs, daWs);

[hiDs, loDs, clDs, opDs, daDs] = tf.returnOHLCDarray(d);
hlcoDs = TurtleVal(hiDs, loDs, clDs, opDs, daDs);



startSimIndx = find(daD(1) == daDs)-1;
startSimDate = datestr(daDs(startSimIndx))



for i = 0:startSimIndx-1
    
    curIndx = startSimIndx-i;
    datestr(hlcoDs.da(curIndx))
    hlcoM = ts.updateMonth(curIndx, hlcoM, hlcoMs, hlcoDs)
    
end







for i = 0:startSimIndx-1
    daDs(startSimIndx-i)
    datestr(daDs(startSimIndx-i))
    if sum((daDs(startSimIndx-i) == daMs)) == 1
        1
        opM = [opDs(startSimIndx-i); opM]
        clM = [clDs(startSimIndx-i); clM]
        hiM = [hiDs(startSimIndx-i); hiM]
        loM = [loDs(startSimIndx-i); loM]
    else
        clM(1) = clDs(startSimIndx-i)
    end
    
    if hiDs(startSimIndx-i) > hiM(1)
        hiM(1) = hiDs(startSimIndx-i)
    end
    
    if loDs(startSimIndx-i) < loM(1)
        loM(1) = loDs(startSimIndx-i)
    end
    %     sum((daDs(startSimIndx-i) == daWs)) == 1
    
end

hlcoM.hi == hiM
hlcoM.lo == loM
hlcoM.cl == clM
hlcoM.op == opM


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
