
function plotPred(obj, model_predict)

%% Plots the model and the prediction against the stock;


sigPred = obj.sigPred;
modLen  = obj.modLen;

t = 1:length(model_predict);

figure()
plot(t, sigPred, 'r')
hold on;
plot(t(1:modLen),model_predict(1:modLen), 'k')
hold on;
plot(t(modLen:end),model_predict(modLen:end), 'b')


end 
