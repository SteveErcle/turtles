function fun = loopClosure(A, t, y, x)

model = 0;
for i = 1:2:length(A)*2
    
   model = model + A((i+1)/2)*cos(2*pi*1/x(i)*t + x(i+1));
   
end

model = x(length(A)*2 + 1) + model;

fun = y-model;
         
