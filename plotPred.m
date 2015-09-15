
function plotPred(sigPred, modLen, model_predict)

%% Plots the model and the prediction against the stock;

t = 1:length(model_predict);

plot(t, sigPred, 'r')
hold on;
plot(t(1:modLen),model_predict(1:modLen), 'k')
hold on;
plot(t(modLen:end),model_predict(modLen:end), 'b')


end 
