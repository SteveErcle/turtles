function showFluctLevs(highest, lowest, tLevs)

hold on;

fluctLevs = 0;

for i = 1:9
    fluctLevs(i) = (highest-lowest)*((i-1)/8)+lowest;
end
fluctLevs(end+1) = (highest-lowest)*(1.5)+lowest;
fluctLevs(end+1) = (highest-lowest)*(2)+lowest;
fluctLevs(end+1) = (highest-lowest)*(2.5)+lowest;
fluctLevs(end+1) = (highest-lowest)*(1/3)+lowest;
fluctLevs(end+1) = (highest-lowest)*(2/3)+lowest;
for i = 1:length(fluctLevs)
     if i <= length(fluctLevs) - 2
        plot(tLevs , ones(1,length(tLevs))*fluctLevs(i), 'k')
    else
        plot(tLevs , ones(1,length(tLevs))*fluctLevs(i), 'c')
    end

end

end 

