function [J1, descParam] = costFminNumGD(cfHdle,theta)


d = zeros(size(theta));
perturb = zeros(size(theta));
e = 1e-4;

for p = 1:numel(theta)
    perturb(p) = e;
    J1 = cfHdle(theta-perturb);
    J2 = cfHdle(theta+perturb);
    d(p) = (J2 - J1) / (2*e);
    perturb(p) = 0;
end

% descParam = theta - (alpha)*d;

descParam = d;



end
