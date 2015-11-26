
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
% h = handles.axesG
% h = plot(1:100,1:100)
% set(gca, 'XLim', [val-1000 val])
% set(gca, 'YLim', [min(sigFFT)*0.9, max(sigFFT)*1.1])
% 



filtL = 0.1;
filtNewL = 0.1;

filtH = 0.1;
filtNewH = 0.1

sFFT = SignalGenerator(stock, present+2, 2000);

[sigFFT, sigHL, sigH, sigL] = sFFT.getSignal('c', filtH, filtL);

c = yahoo;
stock = 'MENT';

w = fetch(c,stock,now, now-1000, 'w');
highlow(w(:,3), w(:,4),...
    w(:,3), w(:,4),'blue',w(:,1));
h = gca

startDate = w(end,1);
endDate = w(1,1);



for i = 1:1000
    
    

%     filtL=get(handles.slider4,'Value');
    val = get(handles.slider1,'Value');
%     set(h, 'XLim', [val-100 val])
%     set(h, 'YLim', [min(sigFFT)*0.9, max(sigFFT)*1.1])

set(h, 'XLim', [startDate+val-100, startDate+val]);
datetick('x',12, 'keeplimits');
    
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
