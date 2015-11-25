
clc
clear all
close all

addpath('/Users/Roccotepper/Documents/turtles/TurtleData')
addpath('/Users/Roccotepper/Documents/turtles/sinide')


filtL = 0.4;
filtH = 0.0005;
stock = 'JPM'

sampLen = 418;
predLen = 10;
interval = 10;

day = 2205;
futer = 100;
present = day;


handles = guihandles(giua)
filtL = 0.1;
filtNewL = 0.1;

filtH = 0.1;
filtNewH = 0.1

sFFT = SignalGenerator(stock, present+2, 2000);

[sigFFT, sigHL, sigH, sigL] = sFFT.getSignal('c', filtH, filtL);


 figure()
 for i =1:1000
     
%      figure(1)

plot(sigFFT)
val = get(handles.slider1,'Value');
axis([val-1000, val, 10, 80])

pause(0.025)


 end 


% figure()
% for i =1:1000
%     [sigFFT, sigHL, sigH, sigL] = sFFT.getSignal('c', filtH, filtL);
%     
%     figure(1)
%     plot(sigHL)
%     
%     while(filtL == filtNewL && filtH == filtNewH)
%         filtL=get(handles.slider1,'Value');
%         filtH=get(handles.slider2,'Value');
%         pause(0.025)
%     end
%     
%     filtNewL = filtL;
%     filtNewH = filtH;  
% end
