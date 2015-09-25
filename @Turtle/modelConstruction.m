function [model_predict] = modelConstruction(obj,theta)

%% Constructs a sinosoid
% Input the unfilted total signal (including part to predict against)
% example: input a signal of 210 days, constructs model for 200 days and
% prediction for 10 days


sigPred = obj.sigPred;

sigMod = obj.sigMod;

A = obj.A;
P = obj.P;
 


avg = mean(sigMod);



t = 1:length(sigPred);

model_predict = avg;
for k = 1:length(theta)
    model_predict = model_predict + A(k)*cos(2*pi*1/P(k)*t + theta(k));
end





end 



