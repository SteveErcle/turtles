
function [signal] = signalGenerator(stock, FAKER, REALER, PLOT)

% 
% FAKER = 0;
% REALER = 1;
% 
% 
% stock = 'MENT';

present  = 2100;
past = present+1-2000;

yMtxAll = csvread(strcat(stock,'.csv'),2,1);
yMtxAll = yMtxAll(past-2:present-2,:);

yc = yMtxAll(:,6);

A = [0.5, 1, 1.5, 2, 4, 7]/4;
% A = [1, 2, .1, 5, 4, 0.9]/3
% P = [24, 31, 52, 84, 122, 543]
P = [24, 31, 52, 84, 122, 543];  %.* (rand(6,1)).'
ph = [1.5, 2.4, 0.4, 1.2 , .9, 1.2];
x1 = 12;

t = 0 : 2000;

for i = 1:length(A)
    x1 = x1 + A(i)*cos(2*pi*1/P(i)*t + ph(i));
end


stepper = zeros(length(t),1);

sSizee = [1920, 1802, 1403, 1332, 1000,900, 740, 600, 450, 325, 230, 100];
sAmp =  [7, 10, 3, -15, -5, -2, 8 ,3, 0, 4, 9, 7]/4;

for i = 1:length(sSizee)
    stepper(end-(sSizee(i)-1):end) = sAmp(i)*ones(sSizee(i),1);
    
end

rander = zeros(length(t),1);

for i = 1:length(rander)
    
    if mod(i,4) == 0
        rander(i) = (-0.5+rand(1,1))*1.2;
    end
end


x1 = x1+stepper'+rander';


if FAKER == 1
    signal = x1;
end

if REALER == 1
    signal = yc';
end

if PLOT  == 1
    
    figure()
    plot(yc)
    hold on;
    plot(x1,'r')
    hold on
    plot(stepper,'g')
    
end



end