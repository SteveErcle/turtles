close all
clear
clc

t = 0:99;
P = [100, 50, 25, 12]
theta = [1.2 4.3, 3.4, 4.6]
A = [4 3 2 1]
% A = 1;
% P = 100;
% theta = 1.2;


dc_offset = 15;

y = dc_offset;
for i = 1:length(A)
    y = y + A(i)*cos(2*pi*1/P(i)*t + theta(i));
end

plot(y)

rander = zeros(1, length(t));

for i = 1:length(rander)
    
    if mod(i,4) == 0
        rander(i) = (-0.5+rand(1,1))*1.2;
    end
end

% y = y + rander;


fun = @(x)loopClosure(theta, t, y, x);


resMajor = [];

parfor i = 1:50
    
guess = zeros(length(theta),3);
guess(:,1) = rand(length(theta),1)*5;
guess(:,2) = rand(length(theta),1)*150 %[150, 75, 50, 25]+rand(1,length(theta))*10;
guess(:,3) = rand(length(theta),1)*2*pi;
guess = guess';
guess = guess(:);
guess(end+1) = mean(y);

x0 = [guess'];

[x, resnorm] = lsqnonlin(fun, x0);

resMinor = [resnorm , x];
resMajor = [resMajor; resMinor];

end 

resMajor = sortrows(resMajor,1);
x = resMajor(1,2:end)

model = 0;
for i = 1:3:length(theta)*3
    
   model = model + x(i)*cos(2*pi*1/x(i+1)*t + x(i+2));
   
end
model = x(length(theta)*3 + 1) + model;

plot(y,'r')
hold on
plot(model)




% 
% x0 = [guess(1), guess(2),0,0];
% 
% % x0 = [70, 20, 0, 0];
% 
% [x, resnorm] = lsqnonlin(fun, x0);
% 
% resMajor = [resMajor; resnorm , x]
% 
% end 
% 

% 
% z = cos(2*pi*1/x(1)*t + x(3)) + cos(2*pi*1/x(2)*t + x(4));
% 
% plot(z)
% hold on
% plot(y, 'r')







