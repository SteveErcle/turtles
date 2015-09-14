function [theta] = GDtideFinder(signal, modLen, PLOT, A, P)


% signal = Filterer(signal);
% 
% theta = zeros(length(P),1);
% 
% tideSig = signal(1:modLen+1);
% 
% t = 0:modLen;
% 
% 
% cfHdle  = @(theta)costFuncLSE(t,tideSig',mean(tideSig),length(A),A,P,theta);
% 
% options = optimset('GradObj', 'on', 'Display', 'off','MaxIter', 300);
% 
% [theta, cost] = fminunc(@(theta)(costFminNumGD(cfHdle,theta)), theta, options);
% 
% 
% model = mean(tideSig);
% for k = 1:length(theta)
%     model = model + A(k)*cos(2*pi*1/P(k)*t + theta(k));
% end
% 
% if PLOT == 1
% 
% figure()
% plot(signal,'r')
% 
% figure()
% plot(model,'b');
% hold on;
% plot(tideSig,'r');
% title('Grad Descent')
% 
% 
% end 





% stock = 'ABT';
% 
% present  = 2200;
% past = present+1-2000;
% 
% yMtxAll = csvread(strcat(stock,'.csv'),2,1);
% yMtxAll = yMtxAll(past-2:present-2,:);
% 
% yc = yMtxAll(:,6);
% 
% signalPres = yc;
% 
% 


signal = Filterer(signal);

predLen = 50;

theta = zeros(length(P),1);

day = 1300;

tideSig = signal(day:day+(modLen-1));%signal(end-(modLen-1):end);

size(tideSig)

t = 1:modLen;

size(t)

cfHdle  = @(theta)costFuncLSE(t,tideSig',mean(tideSig),length(A),A,P,theta);

options = optimset('GradObj', 'on', 'Display', 'off','MaxIter', 300);

[theta, cost] = fminunc(@(theta)(costFminNumGD(cfHdle,theta)), theta, options);


t = 1:modLen+predLen;

model = mean(tideSig);
for k = 1:length(theta)
    model = model + A(k)*cos(2*pi*1/P(k)*t + theta(k));
end


if PLOT == 1

% figure()
% plot(signal,'r')

figure()
plot( t(1:modLen), model(1:modLen),'k');
hold on;
plot( t(modLen : modLen + predLen), model(modLen : modLen + predLen), 'b');
hold on;
% plot(tideSig,'r');

plot(signal(day:day+modLen+predLen),'r');

title('Grad Descent')


end 
