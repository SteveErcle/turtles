function lineHandle = lineSetter(gcf, numOfLines)

h = gcf;
axesObjs = get(h, 'Children');
axesObjs = findobj(axesObjs, 'type', 'axes');
dataObjs = get(axesObjs(1), 'Children');
objTypes = get(dataObjs(1:numOfLines), 'Type');
lineHandle = findobj(dataObjs(1:numOfLines), 'type', 'line');

end






% dataObjs = get(axesObjs(1), 'Children');
% objTypes = get(dataObjs(1:numOfLines), 'Type');
% lineHandle = findobj(dataObjs(1:numOfLines), 'type', 'line');
% 
% 
% 
% dataObjs = findobj(axesObjs, 'type', 'axes');
% choosenDataObj = dataObjs(1);
% get(axesObjs, 'Type');
