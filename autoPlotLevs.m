% autoPlotLevs

function [] = autoPlotLevs(quarterlyHL, yearlyHL, da)

% for j = 2:3
%     for i = 2:7
%         if j == 2
%             color = 'g';
%         else
%             color = 'r';
%         end
%         plot(da , ones(1,length(da))*quarterlyHL(i,j), color)
%     end
% end

for j = 2:3
    for i = 2:10
        if j == 2
            color = 'b';
        else
            color = 'k';
        end
        plot(da , ones(1,length(da))*yearlyHL(i,j), color)
    end
end

end