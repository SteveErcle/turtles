close all
clear
clc


P = [100, 50]
theta = [1.2 4.3]

t = 0:99;
y = cos(2*pi*1/P(1)*t + theta(1)) + cos(2*pi*1/P(2)*t + theta(2));



fun = @(x)((y - ...
    (cos(2*pi*1/x(1)*t + x(3)) + cos(2*pi*1/x(2)*t + x(4)))).^2)


resMajor = [];

for i = 1:15
    
guess = rand(2,1)*100

x0 = [guess(1), guess(2),0,0];

% x0 = [70, 20, 0, 0];

[x, resnorm] = lsqnonlin(fun, x0);

resMajor = [resMajor; resnorm , x]

end 

resMajor = sortrows(resMajor,1);
x = resMajor(1,2:end)

z = cos(2*pi*1/x(1)*t + x(3)) + cos(2*pi*1/x(2)*t + x(4));

plot(z)
hold on
plot(y, 'r')


surf = [1,1,1;2,2,2;3,3,3];
bias = [1;2;3]
surf*bias

bsxfun(@times,surf,bias)







