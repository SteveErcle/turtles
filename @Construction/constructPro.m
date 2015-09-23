function [model, prediction, projection] = constructPro(obj)

%% Constructs a sinosoid

A = obj.A;
P = obj.P;
theta = obj.theta;
predLen = obj.predLen;
sigMod = obj.sigMod;

sigModLen = length(sigMod);

t = 1:sigModLen + predLen;

projection = mean(sigMod);
for k = 1:length(theta)
    projection = projection + A(k)*cos(2*pi*1/P(k)*t + theta(k));
end

model = projection(1:end-predLen);
prediction = projection(end-predLen:end);



end 



