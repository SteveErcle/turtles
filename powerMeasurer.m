clc;
clear all;
close all;


handles = guihandles(turtleSimGui);
figure
plot(1:100)
hold on;
pause
numColor = get(handles.Colors, 'Value');

switch numColor
    case 1
        color = 'k';
    case 2
        color = 'c';
    case 3
        color = 'b';
    case 4
        color = 'm';
    case 5
        color = 'r';
end

h = gcf;
axesObjs = get(h, 'Children');
axesObjs = findobj(axesObjs, 'type', 'axes');

dataTips = findall(axesObjs, 'Type', 'hggroup', 'HandleVisibility', 'off');

trends = [];

if length(dataTips) > 0
    
    if get(handles.setTrend, 'Value')
        cursor = datacursormode(gcf);
        values = cursor.getCursorInfo;
        [t1, t2] = values.Position;
        trends = [trends; t1(1), t2(1), t1(2), t2(2)];
        
        plot([t1(1),t2(1)] , [t1(2), t2(2)], color);
        
        
    end
    
end