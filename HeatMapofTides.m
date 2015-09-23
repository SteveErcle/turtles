% HeatMapofTides

% LowX1 = 1;
% HighX1 = 500;
% sampleSize = 1000;
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
% set(gca,'xlim',[20 400])
% shading interp;
% colorbar;
% 
% az = 0;
% el = 90;
% view(az, el);
% 