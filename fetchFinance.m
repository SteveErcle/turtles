clear all;
close all;
clc;

c = yahoo;


d = fetch(c,'IBM','11/12/2015', '11/12/2010');


close(c)

% priceNorm = normalizer(d(:,7));
% volNorm = normalizer(d(:,6));

priceNormDiff = normalizer(diff(d(:,7)));
priceNorm = normalizer((d(:,7)));
volNorm = normalizer(d(:,6));

[priceFilt] = getFiltered(priceNormDiff, 0.02, 'low');
[volFilt] = getFiltered(volNorm, 0.02, 'low');


plot(priceFilt,'r');
hold on
plot(volFilt)
plot(1:length(volFilt),mean(volFilt),'k');
plot(priceNorm)