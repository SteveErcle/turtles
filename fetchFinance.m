clear all;
close all;
clc;

c = yahoo;


d = fetch(c,'IBM','11/12/2015', '11/12/2010');


close(c)

priceNorm = normalizer(d(:,7));
volNorm = normalizer(d(:,6));

plot(priceNorm,'r');
hold on
plot(volNorm)
plot(1:length(volNorm),mean(volNorm),'k');