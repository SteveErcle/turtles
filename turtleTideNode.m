% turtleTideNode
clc; close all; clear all;

tf = TurtleFun;

load('tslaOffline');

simFrom = 300;
simTo = 400; %length(dAll);

dAll = dAll(simFrom:simTo,:);
dAvg = dAvg(simFrom:simTo,:);
[hi, lo, cl, op, da] = tf.returnOHLCDarray(dAll);

wSize = 10;
signal = flipud(tsmovavg(flipud(cl),'e',wSize,1));
signal(end-(wSize-2):end) = [];

t = 0:length(signal)-1;


% A = 1;
% P = 100;
% theta = 0;
% y = A(1)*cos(2*pi*(1/P(1)) * t + theta(1));

fun = @(x)(signal' - (x(1)*cos(2*pi*(1/x(2)) * t + x(3))));

x0 = [16, 100, 0];
lb = [5, 30, -pi];
ub = [20, 200, pi];
options = optimset('Display', 'off');

[x, resnorm] = lsqnonlin(fun, x0, lb, ub, options);

model = (x(1)*cos(2*pi*(1/x(2)) * t + x(3)))+mean(signal)

subplot(2,1,1)
hold on
plot(da(1:end-9),signal,'k.');
plot(da(1:end-9),model,'b');


load('tslaOffline');

simFrom = 275;
simTo = 400; %length(dAll);


dAll = dAll(simFrom:simTo,:);
[hi, lo, cl, op, da] = tf.returnOHLCDarray(dAll);

wSize = 10;
signal = flipud(tsmovavg(flipud(cl),'e',wSize,1));
signal(end-(wSize-2):end) = [];

t = 0:length(signal)-1;


model = (x(1)*cos(2*pi*(1/x(2)) * t + x(3)))+mean(signal)

subplot(2,1,2)
hold on
plot(da(1:end-9),signal,'k.');
plot(da(1:end-9),model,'b');






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
