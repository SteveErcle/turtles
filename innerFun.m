function resnorm = innerFun(guess,theta,t,y)


fun = @(x)loopClosure(theta, t, y, x);

x0 = [guess];

lb = [];
ub = [];
options = optimset('Display', 'off');

[x, resnorm] = lsqnonlin(fun, x0, lb, ub, options);

end 