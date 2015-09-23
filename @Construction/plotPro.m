
function plotPro(obj, projection, sig)

%% Plots the model and the prediction against the stock;

predLen = obj.predLen;

t = 1:length(projection);

model = projection(1:end-predLen);
prediction = projection(end-predLen:end);

tsg = 1:length(sig);

figure()
plot(tsg, sig, 'r')
hold on;
plot(t(1:end-predLen), model, 'k')
hold on;
plot(t(end-predLen:end), prediction, 'b')


end 
