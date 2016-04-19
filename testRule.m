
clc; close all; clear all;

load('tslaOffline')

tf = TurtleFun;

range1 = 30:350;
range2 = 1:90;
range3 = 5:25;

delete(slider);
handles = guihandles(slider);


subplot(3,1,1)
% figure(1)
[hi, lo, cl, op, daD] = tf.returnOHLCDarray(dAll(range1,:));
highlow(hi, lo, op, cl, 'red', daD);
hold on;

subplot(3,1,2)
% figure(2)
disp('w')
[hi, lo, cl, op, daW] = tf.returnOHLCDarray(wAll(range2,:));
highlow(hi, lo, op, cl, 'red', daW);
hold on;

subplot(3,1,3)
% figure(3)
disp('m')
[hi, lo, cl, op, daM] = tf.returnOHLCDarray(mAll(range3,:));
highlow(hi, lo, op, cl, 'red', daM);
hold on;

window_size = 10;


dAllf = [daD, flipud(tsmovavg(flipud(dAll(range1,5)),'e',window_size,1))];
wAllf = [daW, flipud(tsmovavg(flipud(wAll(range2,5)),'e',window_size,1))];
mAllf = [daM, flipud(tsmovavg(flipud(mAll(range3,5)),'e',window_size,1))];

dervD = flipud(diff(flipud(dAllf(:,2))));
sdervD = flipud(diff(flipud(dervD)));
meanD = mean(dAllf(~isnan(dAllf(:,2)),2));

dervW = flipud(diff(flipud(wAllf(:,2))));
sdervW = flipud(diff(flipud(dervW)));
meanW = mean(wAllf(~isnan(wAllf(:,2)),2));

dervM = flipud(diff(flipud(mAllf(:,2))));
sdervM = flipud(diff(flipud(dervM)));
meanM = mean(mAllf(~isnan(mAllf(:,2)),2));

set(handles.axisView, 'Max', daM(1), 'Min', daM(end));
set(handles.axisView, 'SliderStep', [1/length(daD)*.5, 10/length(daD)*.5]);
set(handles.axisView, 'Value', daM(end));



subplot(3,1,1)
% figure(1)
plot(dAllf(:,1), dAllf(:,2), 'Marker' , '.');
plot(daD(1:end-1), dervD*5+meanD, 'k', 'Marker' , '.')
plot([daD(1,1), daD(end,1)], [meanD, meanD], 'k')

yOne = ylim;
% plot(daD(1:end-2), sdervD*5+meanD, 'm', 'Marker' , '.')

subplot(3,1,2)
% figure(2)
plot(wAllf(:,1), wAllf(:,2), 'Marker' , '.');
plot(daW(1:end-1), dervW*5+meanW, 'k', 'Marker' , '.')
plot([daW(1,1), daW(end,1)], [meanW, meanW], 'k')
% plot(daW(1:end-2), sdervW*5+meanW, 'm', 'Marker' , '.')

yTwo = ylim;

subplot(3,1,3)
% figure(3)
plot(mAllf(:,1), mAllf(:,2), 'Marker' , '.');
plot(daM(1:end-1), dervM*5+meanM, 'k', 'Marker' , '.')
plot([daM(1,1), daM(end,1)], [meanM, meanM], 'k')
% plot(daM(1:end-2), sdervM*5+meanM, 'm', 'Marker' , '.')

yThree = ylim;

p = 0;
while(true)
    
    timeSlide = get(handles.axisView, 'Value');
    
    %     set(0, 'CurrentFigure', 1)
    subplot(3,1,1)
    p(1) = plot([timeSlide, timeSlide], [yOne(1), yOne(2)]);
    
    %     set(0, 'CurrentFigure', 2)
    subplot(3,1,2)
    p(2) = plot([timeSlide, timeSlide], [yTwo(1), yTwo(2)]);
    
    %     set(0, 'CurrentFigure', 3)
    subplot(3,1,3)
    p(3) = plot([timeSlide, timeSlide], [yThree(1), yThree(2)]);
    
    
    
    pause(0.1)
    
    if p ~= 0
        delete(p)
    end
    
end








