function [theta] = GDtideFinder(signal, PLOT, A, P)

signal = Filterer(signal);

theta = zeros(length(P),1);

modLen = 100;
tideSig = signal(1:modLen+1);

t = 0:modLen;


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
plot(model,'b');
hold on;
plot(tideSig,'r');
title('Grad Descent')


end 
