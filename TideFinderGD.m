function [theta,cost] = TideFinderGD(signal, PLOT, A, P)

theta = zeros(length(P),1);

modLen = 200;
tideSig = signal(1:201);

res = .01;
t = 0:modLen;

sqre = [];
sqreTot = [];


cfHdle  = @(theta)costFuncLSE(t,tideSig',mean(tideSig),length(A),A,P,theta);

options = optimset('GradObj', 'on', 'Display', 'off','MaxIter', 300);

[theta, cost] = fminunc(@(theta)(costFminNumGD(cfHdle,theta)), theta, options);


model = mean(tideSig);
for k = 1:length(theta)
    model = model + A(k)*cos(2*pi*1/P(k)*t + theta(k));
end

if PLOT == 1

figure()
plot(signal,'r')

figure()
plot(cost);

figure()
plot(model,'b');
hold on;
plot(tideSig,'r');

end 
