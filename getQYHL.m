function [quarterlyHL yearlyHL] = getQYHL(m)



yearlyHL = [];
quarterlyHL = [];


years = str2num(datestr(m(:,1), 10));
quarters = datestr(m(:,1), 27);

start = years(end);
final = years(1);

for i_year = start:final
    indx = find(years == i_year);
    yearlyHL = [yearlyHL; min(m(indx,1)), max(m(indx,3)), min(m(indx,4))];
end

for i_year = start:final
    for i_quarter = 1:4
        
        quarterToMatch = strcat('Q', num2str(i_quarter), '-', num2str(i_year));
        indx = strmatch(quarterToMatch, quarters, 'exact');
        quarterlyHL = [quarterlyHL; min(m(indx,1)), max(m(indx,3)), min(m(indx,4))];
    end
end

quarterlyHL = flipud(quarterlyHL);
yearlyHL = flipud(yearlyHL);

end