

% arduino testing
clear all; close all; clc;  

a = arduino('/dev/tty.usbmodem1411','Uno')

volt = [];

while (true)
    
%     voltage = readVoltage(a,'A0')
%     volt = [volt;voltage];
%     
%     plot(volt)

if readDigitalPin(a,7) == 1
    readDigitalPin(a,7)
    configureDigitalPin(a,7, 'unset');
    writeDigitalPin(a,7,0);
    configureDigitalPin(a,7,'unset')
    readDigitalPin(a,7)
    disp('')
end 
    
    pause(0.5)
    
end 
    
    


% pause

% writeDigitalPin(a, 7, 1);
% pause
% writeDigitalPin(a, 7, 0);
% pause
% 
% 
% pause 