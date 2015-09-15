function [model_predict] = modelConstruction(filt_signal_mod_and_pred_against, modLen, theta, A, P)

%% Constructs a sinosoid
% Input the unfilted total signal (including part to predict against)
% example: input a signal of 210 days, constructs model for 200 days and
% prediction for 10 days


tideFiltered = filt_signal_mod_and_pred_against;

avg = mean(tideFiltered(1:modLen));

t = 1:length(tideFiltered);

model_predict = avg;
for k = 1:length(theta)
    model_predict = model_predict + A(k)*cos(2*pi*1/P(k)*t + theta(k));
end





end 



