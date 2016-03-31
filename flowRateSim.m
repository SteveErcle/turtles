% flowRateSim

clc; close all; clear all;

try
    a = arduino('/dev/tty.usbmodem1411','Uno');
catch
    disp('No Arduino detected');
    return;
    
end



waterData = [];
waterHistorical = [];
wAll = [];
vAll = [];

f = figure;
tf = TurtleFun;

counter = 1;

waterLevel = 10;

amtOfWater = 10
period = 5;

timeInterval = 5*5.9265e-06*2; %0.5 seconds
timeStart = now;
while(true)
    
    flowIn  = readVoltage(a,0)/5*100;
    flowOut = readVoltage(a,1)/5*100;
    disp([flowIn, flowOut]);
    
    flowNet = flowIn - flowOut;
    
    waterLevel = waterLevel + (flowNet/amtOfWater) * (1/period);
    
    waterData = [waterData; waterLevel, min(flowIn, flowOut)];
    waterHistorical = [waterHistorical; waterLevel, min(flowIn, flowOut),...
        flowIn, flowOut];
    
    subplot(4,1,3)
    plot(waterHistorical(:,1));
    subplot(4,1,4)
    
    rate = diff(waterHistorical(:,3) - waterHistorical(:,4));
    plot(rate)
    pause(1/period)
    counter = counter + 1;
    
    if now - timeStart > timeInterval
        timeStart = now;
        
        waterOHLC = [now, waterData(1,1), max(waterData(:,1)),...
            min(waterData(:,1)), waterData(end,1), sum(waterData(:,2))];
        
    
        wAll = [wAll; waterOHLC];
        
        cla(f)
        subplot(4,1,1)
        tf.plotHiLoMultiple(wAll)
        subplot(4,1,2)
        bar(wAll(:,1), wAll(:,6))
       
        waterData = [];
    end
    
    
end



[hi, lo, cl, op, da] = tf.returnOHLCDarray(wAll)
vo = wAll(:,6)

OpCl = vo./abs(op-cl)
HiLo = vo./abs(hi-lo)
