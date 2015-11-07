function [xNorm] = normalizer(x)

x = x - mean(x);
x = x/std(x);

xNorm = x;

end