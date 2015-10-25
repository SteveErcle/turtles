function [thetaShift] = shiftTheta(P, sampLens, theta);

% close all
% clear all
% clc
% 
% P = [ 77 50 125 ];
% sampLen = [ 140 100 250  ];
% theta = [1 2 3];
% thetaShift = theta;

xpelliarmus = [];

for i = 1:3

past = 0;
present = sampLens(i)-1;

dayFuture = sampLens(i) - min(sampLens);
thetaShift(i) = theta(i) + 2*pi*(dayFuture)/P(i);


t = past:present;
y = cos(2*pi*1/P(i)*t + theta(i));

tn = 0:(min(sampLens)-1);
x = cos(2*pi*1/P(i)*tn + thetaShift(i));

% figure()
% plot(t,y)
% hold on
% 
% tnn = present - (min(sampLens)-1) : present;
% plot(tnn, x,'k')

xpelliarmus = [xpelliarmus; x];

end 

