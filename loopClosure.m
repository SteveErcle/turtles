function fun = loopClosure(theta, t, y, x)

model = 0;
for i = 1:3:length(theta)*3
    
   model = model + x(i)*cos(2*pi*1/x(i+1)*t + x(i+2));
   
end

model = x(length(theta)*3 + 1) + model;

model = model';

% fun = diff(y) - diff(model);
fun = (y) - (model);
        

