function lineHandle = lineSetter(gcf, numOfLines)

h = gcf;
axesObjs = get(h, 'Children');
axesObjs = findobj(axesObjs, 'type', 'axes');
monthlyObjs = get(axesObjs(3), 'Children');
weeklyObjs = get(axesObjs(2), 'Children');
dailyObjs = get(axesObjs(1), 'Children');

lineHandle = [findobj(monthlyObjs(1:numOfLines), 'type', 'line');...
    findobj(weeklyObjs(1:numOfLines), 'type', 'line');...
    findobj(dailyObjs(1:numOfLines), 'type', 'line')];

set(lineHandle,'Visible','off')

end

