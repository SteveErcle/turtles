% forexPractice

clc; close all; clear all;

tc = TurtleCall;

forex = csvread('EURUSD0316.csv', 0,2);

size = {'daily', 'thirty'};

op = forex(:,1); hi = forex(:,2); lo = forex(:,3); cl = forex(:,4);


figure('Color',[0.1 0.1 0.1]);
set(gca, 'XColor', [0.8 0.8 0.8]); set(gca, 'YColor', [0.8 0.8 0.8]);
set (gcf, 'KeyPressFcn', @tc.callKey);

for j = 1:2
    
    if strcmp(size{j}, 'thirty')
        inv = 30;
    elseif strcmp(size{j}, 'daily')
        inv = 1440;
    end
    
    interval = size{j};
    
    opWrap.(interval) = [];
    clWrap.(interval) = [];
    hiWrap.(interval) = [];
    loWrap.(interval) = [];
    
    
    for i = 1:inv:length(cl)
        
        
        first = i;
        last = i+inv-1;
        
        try
            
            opWrap.(interval) = [opWrap.(interval); op(first)];
            clWrap.(interval) = [clWrap.(interval); cl(last)];
            hiWrap.(interval) = [clWrap.(interval); max(hi(first:last))];
            loWrap.(interval) = [loWrap.(interval); min(lo(first:last))];
            
        catch
            cap = min([length(opWrap.(interval)), length(clWrap.(interval)), length(hiWrap.(interval)), length(loWrap.(interval))]);
            opWrap.(interval) = opWrap.(interval)(1:cap);
            clWrap.(interval) = clWrap.(interval)(1:cap);
            hiWrap.(interval) = hiWrap.(interval)(1:cap);
            loWrap.(interval) = loWrap.(interval)(1:cap);
        end
  
    end
    
    subplot(2,1,j); set(gca, 'XColor', [0.8 0.8 0.8]); set(gca, 'YColor', [0.8 0.8 0.8]);
    cla; hold on; set(gca,'Color',[0 0 0]);
    candle(hiWrap.(interval), loWrap.(interval), clWrap.(interval), opWrap.(interval), 'cyan');
    xlimit.(interval) = xlim;s
    title({interval}, 'color', 'w');
    
end



levels = [];
alerts = [];


while (true)
    
    h = gcf;
    axesObjs = get(h, 'Children');
    axesObjs = findobj(axesObjs, 'type', 'axes');
    
    dataTips = findall(axesObjs, 'Type', 'hggroup', 'HandleVisibility', 'off');
    
    if length(dataTips) > 0
        
        cursor = datacursormode(gcf);
        dateOnPlot = cursor.CurrentDataCursor.getCursorInfo.Position(1);
        value = cursor.CurrentDataCursor.getCursorInfo.Position(2)
        
        if strcmp(tc.mode, 'l')
            levels = [levels; value];
            color = 'w';
        elseif strcmp(tc.mode, 'a')
            alerts = [alerts; value];
            color = 'b';
        end
        
        for j = 1:length(size)
            interval = size{j};
            subplot(2,1,j);
            plot([xlimit.(interval)(1), xlimit.(interval)(2)], [value, value], color)
        end
        delete(dataTips);
        
    end
    
    pause(0.1)
    
end


return















































% figure('Color',[0.1 0.1 0.1]);
% set (gcf, 'WindowButtonMotionFcn', @tc.callMouse);
% set (gca, 'ButtonDownFcn', @tc.callClick);
% set (gcf, 'KeyPressFcn', @tc.callKey);
% set(gca, 'XColor', [0.8 0.8 0.8]); set(gca, 'YColor', [0.8 0.8 0.8]);
%
% cla; hold on; set(gca,'Color',[0 0 0]);
% candle(hi, lo, cl, op, 'cyan');
%
% xlimit = xlim;
%
% pHandle = 0;
%
% return
% pause
%
% while(true)
%
%     if pHandle ~= 0
%         delete(pHandle)
%     end
%
%     if ~isempty(tc.P)
%         pHandle = plot([xlimit(1), xlimit(2)], [tc.P(1,2), tc.P(1,2)]);
%     end
%
%     pause(0.025)
%
% end