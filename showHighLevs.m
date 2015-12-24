function showHighLevs(highest, tLevs)

hold on;

highLevs = 0;

for i = 1:9
    highLevs(i) = highest*((i-1)/8);
end
highLevs(end+1) = highest*1.5;
highLevs(end+1) = highest*2;
highLevs(end+1) = highest*2.5;
highLevs(end+1) = highest*1/3;
highLevs(end+1) = highest*2/3;
for i = 1:length(highLevs)
    if i <= length(highLevs) - 2
        plot(tLevs , ones(1,length(tLevs))*highLevs(i), 'r')
    else
        plot(tLevs , ones(1,length(tLevs))*highLevs(i), 'm')
    end
end

end


