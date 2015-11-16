
function fun = loopClosureTurtleSim(x)


A = 0;
B = 0;

capital = 0;
price = 1;
allPrice = [];

supply = 0;
demand = 0;
% y = 5*cos(2*pi/25*(0:49)+1.5)+5;

for i = 1:50
    s = x(i);
    if x(i) < 0
        s = 0;
    end 
    b = 10;
    
    supply = supply + s;
    demand = demand + b;
    
    equl = (demand-supply)/(10000);
    
    rateOfChange = equl;
    price = price*(1+rateOfChange);
    
        allPrice = [allPrice; price];
        plot(allPrice);
    
    if supply >= demand
        A = A + demand;
        capital = capital + demand*price;
        sprintf('Capital: %0.2f',capital);
        supply = supply - demand;
        demand = demand - demand;
    else
        A = A + supply;
        capital = capital + supply*price;
        sprintf('Capital: %0.2f',capital);
        demand = demand - supply;
        supply = supply - supply;
    end
    
end

fun = 1/capital;


end
