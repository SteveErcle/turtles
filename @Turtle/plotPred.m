
function plotPred(obj, model_predict)

%% Plots the model and the prediction against the stock;


sigPred = obj.sigPred;
modLen  = obj.modLen;

t = 1:length(model_predict);

figure()
plot(t, sigPred, 'r')
hold on;
plot(t(1:modLen+1),model_predict(1:modLen+1), 'k')
hold on;
plot(t(modLen+1:end),model_predict(modLen+1:end), 'b')


end 
