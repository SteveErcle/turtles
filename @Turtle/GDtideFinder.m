function [theta] = GDtideFinder(obj)

%% Finds the phases (thetas) 
% finds phases for the given filtered signal of model length
% amplitudes and periods
% example: input a signal of 200 days, finds phases for those 200 days

filt_signal_mod_against = obj.sigMod;
A = obj.A;
P = obj.P;

tideFiltered = filt_signal_mod_against;

theta = zeros(length(P),1);

t = 1:length(tideFiltered);

cfHdle  = @(theta)costFuncLSE(t,tideFiltered',mean(tideFiltered),length(A),A,P,theta);

options = optimset('GradObj', 'on', 'Display', 'off','MaxIter', 300);

[theta, cost] = fminunc(@(theta)(costFminNumGD(cfHdle,theta)), theta, options);


model_predict = mean(tideFiltered);
for k = 1:length(theta)
    model_predict = model_predict + A(k)*cos(2*pi*1/P(k)*t + theta(k));
end


end 
