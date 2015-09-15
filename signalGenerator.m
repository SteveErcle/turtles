
function [signal] = signalGenerator(stock, RANSTEP, FAKER, REALER, PLOT, A, P, ph)

yc = getStock(stock, 2100, 2000, 'ac');

x1 = 12;

t = 1 : 2000;

for i = 1:length(A)
    x1 = x1 + A(i)*cos(2*pi*1/P(i)*t + ph(i));
end


stepper = zeros(length(t),1);

sSizee = [1975, 1930, 1857, 1332, 1000,900, 740, 600, 450, 180, 140, 50];
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

if RANSTEP == 1
    x1 = x1+stepper'+rander';
end

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