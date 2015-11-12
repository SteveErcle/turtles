
function fun = loopClosureSQtheta(theta, P, A, t, y, x)

model = 0;
for i = 1:length(theta)
    
    model = model + A(i)*cos(2*pi*1/P(i)*t + x(i));
    
end

model = x(end) + model;

fun = diff(y) - diff(model);