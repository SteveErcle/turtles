clc; clear all; close all;

ts = TurtleSim;
tf = TurtleFun;
delete(turtleSimGui)
handles = guihandles(turtleSimGui);
ts.setButtons(handles, 'none');

for i_setHandles = 1:1
    set(handles.simPres, 'Value', 100);
    set(handles.simPres, 'Max', 150, 'Min', 1);
    set(handles.simPres, 'SliderStep', [1/150, 10/150]);
    
    set(handles.aniLen, 'Value', 140);
    set(handles.aniLen, 'Max', 150, 'Min', 1);
    set(handles.aniLen, 'SliderStep', [1/150, 10/150]);
    
    set(handles.axisLen, 'Value', 100);
    set(handles.axisLen, 'Max', 500, 'Min', 1);
    set(handles.axisLen, 'SliderStep', [1/500, 10/500]);
    
    set(handles.aniSpeed, 'Value', 0.5);
    set(handles.aniSpeed, 'Max', 1, 'Min', 0.01);
    set(handles.aniSpeed, 'SliderStep', [1/100, 10/100]);
end

stock = 'CLDX'
exchange = 'NYSE'

c = yahoo;
m = fetch(c,stock,now-10, now-400, 'm');
w = fetch(c,stock,now-10, now-400, 'w');
d = fetch(c,stock,now-10, now-400, 'd');

hlcoMs = TurtleVal(m);
hlcoWs = TurtleVal(w);
hlcoDs = TurtleVal(d);

[hlcoD, hlcoW, hlcoM] = ts.resetAll(handles, hlcoDs, hlcoWs, hlcoMs);

simPres = get(handles.simPres, 'Max') - floor(get(handles.simPres, 'Value')) + 1;
aniSpeed = get(handles.aniSpeed, 'Value');
plot([hlcoDs.da(simPres), hlcoDs.da(simPres)],  [0, 1000], 'c')


figure
[fM,pM] = tf.plotHiLo(hlcoM);
plot([hlcoDs.da(simPres), hlcoDs.da(simPres)],  [0, 1000], 'c')
title(strcat(stock,' Monthly'))
datetick('x',12, 'keeplimits');

figure
[fW,pW] = tf.plotHiLo(hlcoW);
plot([hlcoDs.da(simPres), hlcoDs.da(simPres)],  [0, 1000], 'c')
title(strcat(stock,' Weekly'))
datetick('x',12, 'keeplimits');

figure
[fD,pD] = tf.plotHiLo(hlcoD);
plot([hlcoDs.da(simPres), hlcoDs.da(simPres)],  [0, 1000], 'c')
title(strcat(stock,' Daily'))
datetick('x',12, 'keeplimits');


startSimIndx = find(hlcoD.da(1) == hlcoDs.da)-1;
startSimDate = datestr(hlcoDs.da(startSimIndx))



while(true)
    
    if get(handles.runAnimation, 'Value')
        
        [hlcoD, hlcoW, hlcoM] = ts.resetAll(handles, hlcoDs, hlcoWs, hlcoMs);
        simPres = get(handles.simPres, 'Max') - floor(get(handles.simPres, 'Value')) + 1;
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
            
            
            aniSpeed = get(handles.aniSpeed, 'Value');
            set(handles.axisLen, 'Max', length(hlcoD.da) , 'Min', 1);
            axisLen = floor(get(handles.axisLen, 'Value'));
            
            axis([hlcoD.da(axisLen), hlcoD.da(1)+7,...
                min(hlcoD.lo(1:axisLen)), max(hlcoD.hi(1:axisLen))])
            
            if ~get(handles.runAnimation, 'Value')
                aniSpeed = 0;
            end
            
            pause(aniSpeed)
            
            
        end
        
    else
    
    
    
    set(handles.axisLen, 'Max', length(hlcoD.da) , 'Min', 1);
    axisLen = floor(get(handles.axisLen, 'Value'));
    
    axis([hlcoD.da(axisLen), hlcoD.da(1)+7,...
        min(hlcoD.lo(1:axisLen)), max(hlcoD.hi(1:axisLen))])
    
    if get(handles.setLevel, 'Value')
        plot( [hlcoDs.da(end), hlcoDs.da(1)], [1,1]*20, 'k')
        set(handles.setLevel, 'Value', 0);
    end
    
    end 
    
    pause(0.01)
    
end


sprintf('Done')


% axis
% stop animation
% start line
% levels
% market transactions
















