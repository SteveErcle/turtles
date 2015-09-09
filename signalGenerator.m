
clear all; close all; clc;


% c1 = 0;
% c2 = 0;
% k1 = 1;
% k2 = 0;
% M1 = 1;
% M2 = 0;

c = 10;

p1 = 125;
p2 = 75;
p3 = 50;
p4 = 25;

k1 = .5;
k2 = 1;
k3 = 0.05
k4 = 0.001;

m0 = 1;
m1 = k1/((2*pi*(1/p1))^2);
m2 = k2/((2*pi*(1/p2))^2);
m3 = k3/((2*pi*(1/p3))^2);
m4 = k4/((2*pi*(1/p4))^2);


w = sqrt(k1/m1);

sim('cartSim3');


stock = 'MENT'

present = 1100;
past  = 100;

yMtxAll = csvread(strcat(stock,'.csv'),2,1);
yMtxAll = yMtxAll(past-2:present-2,1:end-1);

figure()
plot(yMtxAll(:,4),'r');



rander = zeros(length(simout1.data),1);



for i = 1:length(rander)
    
    if mod(i,4) == 0
        rander(i) = (-0.5+rand(1,1))*1.2;
    end
end

rander = zeros(length(simout1.data),1);

adder = 12 + rander;

signal = simout1.data + adder;

hold on;
plot(simout1.time, signal)






yc = signal;
deg_filt = 5;
norm_freqz = 0.3;
[b a] = butter(deg_filt,norm_freqz, 'low');

ycFilt = filtfilt(b,a,yc);



hold on;
plot(simout1.time,ycFilt,'g')

figure()
plot(simout1.time,ycFilt)


fs = 1;




figure()

prds = [];

changer = 200;

% for i = 1:50:250
%
%     yc = signal(i:i+300)



yc  = signal;

figure() 
plot(yc)

deg_filt = 5;
norm_freqz = 0.3;
[b a] = butter(deg_filt,norm_freqz, 'low');

ycFilt = filtfilt(b,a,yc);

x1 = ycFilt';

ss = length(x1);



    x1 = x1.*hanning(length(x1))';
    x1 = [x1 zeros(1, 20000)];

X1 = abs(fft(x1));
X1 = X1(1:length(X1)/2);

F_mag = X1;

figure()
plot((0:length(X1)-1),X1)

[pks, I]= findpeaks(F_mag');
I = I-1;

peakrs = sortrows([pks, I,],-1);

A_nat = peakrs(:,1)/(ss/4);

B_nat = peakrs(:,2);

F_nat = peakrs(:,2)*(fs/length(x1));

P_nat = fs./F_nat;

natterMxt = [A_nat ,B_nat ,P_nat]

scatter(P_nat,A_nat);

peakrs(1:10,2)
F_nat(1:10)
P_nat(1:10,1)

thisPrds = [B_nat(1:10), A_nat(1:10), P_nat(1:10)]

prds = [prds; thisPrds];

y = ones(10,1)*i;


figure()
scatter(thisPrds(:,3),y)
hold on;

% end

% w = sqrt(k1/M1)

% sim('simuTest');
%
%
%
% min(simout.signal2.data)
%
% plot(simout.signal2.data)



% t = 1:100;
%
% A = [1, 2, 3, 2]
% P = [20, 30, 80, 12]
% ph = [0.5, 3.4, 1.2 , .9]
% y = 50;
%
%
%
% for i = 1:length(A)
%     y = y + A(i)*cos(2*pi*1/P(i)*t + ph(i))
% end
%
%
% stepper = zeros(length(t),1);
% ssize = 10;
%
%
%
% stepper(end-(ssize-1):end) = -12*ones(ssize,1);
%
% stepper = 0;
% ys = y + stepper';
%
%
%
% w = 50;
%
% ph = ph*rand(1);
%
% for i = 1:length(A)
%     w = w + A(i)*cos(2*pi*1/P(i)*t + ph(i));
% end
%
% tw = 100:199;
%
% w(1) = ys(end);
%
%
% plot(t,ys)
% hold on;
% plot(tw,w,'r')

