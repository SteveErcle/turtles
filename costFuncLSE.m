function [J] = costFuncLSE(t,yStock,avg,num_dom_waves,A,P_nat,theta)

m = length(yStock);

phase = theta(1:num_dom_waves);

if length(theta) == num_dom_waves*2
    P_nat = theta((num_dom_waves+1:num_dom_waves*2));
end



h = avg;
for dom_i = 1:num_dom_waves
    h = h + 2*A(dom_i)*cos(2*pi*1/P_nat(dom_i)*t + phase(dom_i));
end


dh = diff(h');
dy = diff(yStock);

dh = (dh-mean(dh))/(max(dh)-min(dh))*6;
dy = (dy-mean(dy))/(max(dy)-min(dy))*6;


J = sum((dh-dy).^2)/(2*m);

end