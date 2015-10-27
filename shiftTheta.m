function [thetaShift] = shiftTheta(P, sampLens, theta);


xpelliarmus = [];

for i = 1:length(sampLens)

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

% figure()
% tnn = present - (min(sampLens)-1) : present;
% plot(tnn, x,'k')

xpelliarmus = [xpelliarmus; x];

end 

