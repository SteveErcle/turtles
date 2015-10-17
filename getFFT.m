function [X1 Pds angles pkt It] = getFFT(sample)

fs = 1;
x1 = sample;
ss = length(x1);
x1 = x1.*hanning(length(x1))';
x1 = [x1 zeros(1, 20000)];
angles = angle(fft(x1));
X1 = abs(fft(x1));
X1 = X1(1:ceil(length(X1)/2));
X1 = X1/(ss/4);
Xt = 0:length(X1)-1;
Pds = fs./ (Xt*(fs/length(x1)));
[pkt It] = findpeaks(X1);

end 