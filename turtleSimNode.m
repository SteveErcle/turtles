clc; clear all; close all;

ts = TurtleSim;
tf = TurtleFun;
delete(turtleSimGui)
handles = guihandles(turtleSimGui);
ts.setButtons(handles, 'none');

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
title(strcat(stock,' Monthly'))

figure
[fW,pW] = tf.plotHiLo(hlcoW)
title(strcat(stock,' Weekly'))

figure
[fD,pD] = tf.plotHiLo(hlcoD)
title(strcat(stock,' Daily'))


aniSpeed = 0.5

for i = 0:startSimIndx-1
    
    curIndx = startSimIndx-i;
    datestr(hlcoDs.da(curIndx))
    
    hlcoD = ts.updateDay(curIndx, hlcoDs, hlcoD);
    hlcoW = ts.updateWeek(hlcoW, hlcoWs, hlcoD);
    hlcoM = ts.updateMonth(hlcoM, hlcoMs, hlcoD);
    
    %     if get(handles.D, 'Value')
    %         figure(fD)
    %         [~,pDo] = tf.plotOpen(hlcoD);
    %         pause(aniSpeed)
    %         delete(pDo);
    %         delete(pD);
    %         figure(fD)
    %         [~,pD] = tf.plotHiLo(hlcoD);
    %     end
    
    pD = ts.animateDay(aniSpeed, get(handles.D, 'Value') , hlcoD, fD, pD)
    
    isNewWeek = ts.isNewTimePeriod(hlcoWs, hlcoD)
    pW = ts.animate(aniSpeed, get(handles.W, 'Value'), isNewWeek, hlcoW, fW, pW)
    
    isNewMonth = ts.isNewTimePeriod(hlcoMs, hlcoD)
    pM = ts.animate(aniSpeed, get(handles.M, 'Value'), isNewMonth, hlcoM, fM, pM)
    
    %     if get(handles.W, 'Value')
    %
    %         if ts.isNewTimePeriod(hlcoWs, hlcoD)
    %             figure(fW)
    %             [~,pWo] = tf.plotOpen(hlcoW);
    %         end
    %
    %         pause(aniSpeed)
    %
    %         if ts.isNewTimePeriod(hlcoWs, hlcoD)
    %             delete(pWo);
    %         end
    %         delete(pW);
    %         figure(fW)
    %         [~,pW] = tf.plotHiLo(hlcoW);
    %
    %     end
    
    if get(handles.M, 'Value')
        
        if ts.isNewTimePeriod(hlcoMs, hlcoD)
            figure(fM)
            [~,pMo] = tf.plotOpen(hlcoM);
        end
        
        if ts.isNewTimePeriod(hlcoMs, hlcoD)
            delete(pMo);
        end
        delete(pM)
        figure(fM)
        [~,pM] = tf.plotHiLo(hlcoM)
    end
    
    pause(aniSpeed)
    
    
end



% m = fetch(c,stock, now-50 , now-400, 'm');
[hiMt, loMt, clMt, opMt, daMt] = tf.returnOHLCDarray(m);

hlcoM.hi == hiMt
hlcoM.lo == loMt
hlcoM.cl == clMt
hlcoM.op == opMt
hlcoM.da == daMt



sprintf('Done')


