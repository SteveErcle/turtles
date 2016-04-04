% turtleTideNode
clc; close all; clear all;

tf = TurtleFun;


%%
load('tslaOffline');

simFrom = 300;
simTo = 400; 
dAll = dAll(simFrom:simTo,:);
dAvg = dAvg(simFrom:simTo,:);
[hi, lo, cl, op, da] = tf.returnOHLCDarray(dAll);
starter = da(1);
wSize = 20;
signal = flipud(tsmovavg(flipud(cl),'e',wSize,1));
signal(end-(wSize-2):end) = [];
t = 0:length(signal)-1;


%%
fun = @(x)(fliplr(signal') - (x(1)*cos(2*pi*(1/x(2)) * t + x(3))));

x0 = [16, 67, 0];
lb = [5, 10, -pi];
ub = [20, 150, pi];
options = optimset('Display', 'off');

[x, resnorm] = lsqnonlin(fun, x0, lb, ub, options);

%%

sigAvg = mean(signal);

model = fliplr((x(1)*cos(2*pi*(1/x(2)) * t + x(3))) + sigAvg);

% subplot(2,1,1)
hold on
plot(da(1:end-(wSize-1)),signal,'k.');
plot(da(1:end-(wSize-1)),model,'b');


%%
load('tslaOffline');

simFrom = 275;
simTo = 400; 
dAll = dAll(simFrom:simTo,:);
dAvg = dAvg(simFrom:simTo,:);
[hi, lo, cl, op, da] = tf.returnOHLCDarray(dAll);

wSize = 20;
signal = flipud(tsmovavg(flipud(cl),'e',wSize,1));
signal(end-(wSize-2):end) = [];
t = 0:length(signal)-1;


%%

model = fliplr((x(1)*cos(2*pi*(1/x(2)) * t + x(3))) + sigAvg);

% subplot(2,1,2)
hold on
plot([starter,starter], [min(signal), max(signal)]);
plot(da(1:end-(wSize-1)),signal,'k.');
plot(da(1:end-(wSize-1)),model,'b');






% x1ph = signal';
% fs = 1;
% surfer = [];
% 
% LowX1 = 50;
% HighX1 = 4000;



% x1 = x1ph
% ss = length(x1);
% x1 = x1.*hanning(length(x1))';
% x1 = [x1 zeros(1, 20000)];
% X1 = abs(fft(x1));
% X1 = X1(1:ceil(length(X1)/2));
% X1 = X1/(ss/4);
% Xt = 0:length(X1)-1;
% P = fs./ (Xt*(fs/length(x1)));
% [pkt It] = findpeaks(X1);
% 
% surfer = [surfer; X1(LowX1:HighX1)];

% ax4 = figure()%subplot(3,1,1);
% plot( P(LowX1:HighX1) , surfer )
