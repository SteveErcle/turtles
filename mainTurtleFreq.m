clear all; close all; clc;


stock = 'ABT';




RANSTEP = 0;
FAKER = 0;
REALER = 1;
PLOT = 1;


% A = [0.5, 1, 1.5, 2, 4, 7]/4;
% P = [24, 31, 52, 84, 122, 543];
ph = [1.5, 2.4, 0.4, 1.2 , .9, 1.2];

A = [0.09 0.2 0.15 0.20 0.35 0.67]
P = [25 34 43 62 99 178]

signal = signalGenerator(stock, RANSTEP, FAKER, REALER, 0, A, P, ph);

modLen = 200;

% verify bin is working

% LowX1 = 1;
% HighX1 = 500;
% sampleSize = 500;
% shiftSize = 1;
% x1ph = signal;
% 
% surfer = [];
% 
% icl = 1;
% 
% hsvNum = round(1000/shiftSize)
% col = hsv(hsvNum);
% 
% leftOver = 2000-sampleSize;
% 
% for k = 1:shiftSize:leftOver
%     
%     k;
%     
%     x1 = x1ph(k:sampleSize+k);
%     ss = length(x1);
% %     x1 = x1.*hanning(length(x1))';
% %     x1 = [x1 zeros(1, 2000)];
%     X1cpx = fft(x1);
%     X1 = abs(X1cpx);
%     X1phase = angle(X1cpx);
%     X1phase = X1phase(1:ceil(length(X1)/2));
%     X1 = X1(1:ceil(length(X1)/2));
%     
%     X1 = X1/(ss);
%     
%     %     plot(X1)
%     
%     k;
%     sampleSize+k;
%     
%     fs = 1;
%     Xt = 0:length(X1)-1;
%     P = fs./ (Xt*(fs/length(x1)));
%     
%     surfer = [surfer; X1phase];
%     
%     %     surfer = [surfer; X1(LowX1:HighX1)];
%     
% %     plot(P, X1phase, 'color',col(icl,:))
% %     hold on;
%     
%     icl = icl + 1;
%     
%     
% end
% 
% 
% 
% 
% 
% figure()
% [m,n] = size(surfer)
% x = 1:n;
% y = 1:m;
% 
% 
% surf( P , y , surfer)
% axis tight
% shading interp;
% colorbar;
% set(gca,'xlim',[20 100])
% shading interp;
% colorbar;
% 
% az = 0;
% el = 90;
% view(az, el);

figure()
plot(signal)








% [totalX] = twoDMapOfTurtles(signal);

% HeatMapofTurtles(signal);

% [theta] = BFtideFinder(signal, modLen, PLOT,  A, P);


% Fix Height Problem
[theta] = GDtideFinder(signal, modLen, PLOT,  A, P);


% ph
% theta


% phase tracking

