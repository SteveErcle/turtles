close all
clear
clc

t = 1:500;
P = [120, 83, 63, 32]
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

rander = zeros(1, length(t));

for i = 1:length(rander)
    
    if mod(i,4) == 0
        rander(i) = (-0.5+rand(1,1))*3.2;
    end
end

sSizee = [78 180, 140, 50];
sAmp =  [-2, 4, 9, 7];
stepper = zeros(length(t),1);

for i = 1:length(sSizee)
    stepper(end-(sSizee(i)-1):end) = sAmp(i)*ones(sSizee(i),1);
end
z = y+rander;
y = y + rander + stepper';

filtH = 0.0100;
[y] = getFiltered(y, filtH, 'high');




g      = zeros(length(theta),3);
g(:,1) = rand(length(theta),1)*5;
g(:,2) = rand(length(theta),1)*150 ;
g(:,3) = rand(length(theta),1)*2*pi;
g = g';
g = g(:);
g(end+1) = mean(y);


outterFun = @(guess)innerFun(guess,theta,t,y)

g0 = g;

[g, resnorm] = lsqnonlin(outterFun, g0);

foundg1 = g;

innerFun(g,theta,t,y)

resMajor = [];
for i = 1:100;
    g      = zeros(length(theta),3);
    g(:,1) = rand(length(theta),1)*5;
    g(:,2) = rand(length(theta),1)*150 ;
    g(:,3) = rand(length(theta),1)*2*pi;
    g = g';
    g = g(:);
    g(end+1) = mean(y);
    
    resnorm = innerFun(g,theta,t,y);
    resMajor = [resMajor;resnorm];
end












resMajor = sortrows(resMajor,1);
x = resMajor(1,2:end);
xReshaped = reshape(x(1:end-1),3,4)
A = xReshaped(1,:)
P = xReshaped(2,:)
theta = xReshaped(3,:)

model = 0;
for i = 1:3:length(theta)*3
    
    model = model + x(i)*cos(2*pi*1/x(i+1)*t + x(i+2));
    
end
model = x(length(theta)*3 + 1) + model;

plot(y,'r')
hold on
plot(model, 'b')
plot(model(1:300), 'k')











