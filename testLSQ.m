clc; 
clear all; 
close all;

td = TurtleData;
tf = TurtleFun;

stock = 'CLDX'
[mAll, mCong, wAll, wCong, dAll, dCong] = td.loadData(stock);

dAll = flipud(dAll(280:440,:));

[hi, lo, cl, op, da] = tf.returnOHLCDarray(dAll);

avg = mean([hi,lo],2);

highlow(hi, lo, op, cl, 'blue', da);
hold on;
% plot(da, avg);
% datetick('x',12, 'keeplimits');

predict = 1:100;


theta = [0,0,0]
fun = @(x)loopClosure(theta, predict, avg(predict), x);

resMajor = [];

parfor i = 1:500
    
    guess      = zeros(length(theta),3);
    guess(:,1) = rand(length(theta),1)*5;
    guess(:,2) = rand(1,length(theta))*50 + 25;
    guess(:,3) = rand(length(theta),1)*2*pi;
    guess = guess';
    guess = guess(:);
    guess(end+1) = mean(avg);
    
    
    x0 = [guess'];
    
    lb = [];
    ub = [];
    options = optimset('Display', 'off');
    
    [x, resnorm] = lsqnonlin(fun, x0, lb, ub, options);
    
    
    
    resMinor = [resnorm , x];
    resMajor = [resMajor; resMinor];
    
end


found = sortrows(resMajor, 1)


x = found(1,2:end)

t = 1:length(dAll);
model = 0;
for i = 1:3:length(theta)*3
    
   model = model + x(i)*cos(2*pi*1/x(i+1)*t + x(i+2));
   
end

model = x(length(theta)*3 + 1) + model;
model = model';


plot(da, model,'b')

t = predict;
model = 0;
for i = 1:3:length(theta)*3
    
   model = model + x(i)*cos(2*pi*1/x(i+1)*t + x(i+2));
   
end

model = x(length(theta)*3 + 1) + model;

model = model';


plot(da(predict), model,'k')
