function [theta, dc_offset] = SQtideFinder(obj)

sigMod = obj.sigMod;
A = obj.A;
P = obj.P;

theta = zeros(1,length(P));

t = (0:length(sigMod)-1)';

fun = @(x)loopClosureTheta(theta, P, A, t, sigMod, x);

guess = [ zeros(1,length(theta)) , mean(sigMod)];

x0 = [guess];

lb = [];
ub = [];
options = optimset('Display', 'off');

[x, resnorm] = lsqnonlin(fun, x0, lb, ub, options);

theta = x(1:end-1);
dc_offset = x(end);

% plot(sigMod,'r')
% hold on;
% 
% eq = A(1)*cos(2*pi*1/P(1)*t + x(1)) + x(end);
% plot(eq+1)




