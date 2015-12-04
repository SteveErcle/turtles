clear all
close all
clc


stock = 'XLE';
c = yahoo;
m = fetch(c,stock,now-3000, now-7000, 'm');
w = fetch(c,stock,now, now-7000, 'w');
close(c)

x = m(:,1);

y2 = 1:size(m,1);




h1 = highlow(m(:,3), m(:,4),...
    m(:,3), m(:,4),'blue',m(:,1));

ax1 = gca;
hold on

ax2 = axes('Position',get(ax1,'Position'),...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none',...
    'XColor','k','YColor','k');
set(ax2, 'YLim', [0 50000000])
linkaxes([ax1 ax2],'x');
hold on
bar(m(:,1),m(:,6),'Parent',ax2);

startIndx = 10;
endIndx = 10+80;

 axis(ax1, [w(end - startIndx,1)+1, w(end - endIndx,1)+1,...
        min(w(end-endIndx:end-startIndx,4))*0.95, max(w(end-endIndx:end-startIndx,3))*1.05]);
datetick('x',12, 'keeplimits');




%
% h = plot(1:10)
% % axis([0 50 0 10])
%
% hold on
% box off
% % Create second Y axes on the right.
%
%
% a2 = axes
% plot(a2, 3:54)
% a2 = axes('YAxisLocation', 'Right')
%
% % Hide second plot.
% set(a2, 'color', 'none')
% set(a2, 'XTick', [])
% % Set scala for second Y.
% set(a2, 'YLim', [20 70])




% axisH = gca
% addTopXAxis(axisH, 'expression', '-argu') % change the label of the ticks by their opposite
%

%
% Fs = 1000;
% t =0:(1/Fs):0.1; %seconds
% t1 = t.*1000; % msec
% y = cos(2*pi*100*t);
% hLine1 = line(t,y,'color','k');
% Ax1 = gca;
% Ax2 = axes('Position',get(Ax1,'Position'),...
%            'XAxisLocation','top');
% % hLine2 = line(t1,y,'color','k','parent',Ax2);
%

% set(gcl, 'parent', Ax2)

%        hLine2 = line(t1,y,'color','k','parent',Ax2);


%
%
%
% toter = [];
% PR = [];
% angaliousSuperiomus = [];
%
% stock = 'JPM';
% P = [41.0447761194030;99.5475113122172;62.3229461756374;52.1327014218009;81.4814814814815;209.523809523810;122.222222222222;318.840579710145];
% A = [0.339497673909774;0.434571526579002;0.800542331823607;0.461698880254668;1.08169199144594;1.42692813386403;1.53695933574092;1.11859378182605];
% B = [537; 222; 354; 424; 272; 106; 181; 69];
%
% % A = [0.45]
% % P = [52]
% % B = [423]
%
%
% day = 400;
% futer = 2400-day;
% interval = 1;
%
% predLen = 100;
% dc_offset = 15;
%
%
% angaliousMajor = [];
% modeliousMajor = [];
%
%
% parfor i = 0:futer/interval
%     present = day + i*interval
%
%
%     present;
%     sampLen = 300;
%
%     filtL = 0.0550;
%     filtH = 0.0065;
%     sMod = SignalGenerator(stock, present+2, present);
%     [sig, sigHL, sigH, sigL] = sMod.getSignal('ac', filtH, filtL);
%
%
%     signalMod = sig(present-sampLen:present);
%     sigMod = sigHL(present-sampLen:present)';
%
%     sample = sigMod;
%     [X1 Pds angles] = getFFT(sample);
%     theta = [angles(B)];
%
%     sigMod = sigMod + dc_offset;
%
%     c = Construction(A, P, theta, predLen, sigMod);
%     [model, prediction, projection] = c.constructPro();
%
%     angaliousMajor = [angaliousMajor; theta];
%     modeliousMajor = [modeliousMajor; model(1)];
%
%
% end
%
% filtL = 0.0550;
% filtH = 0.0065;
%
% present = 1000;
% sMod = SignalGenerator(stock, day+futer+2, futer);
% [sigMod, sigHL, sigH, sigL] = sMod.getSignal('ac', filtH, filtL);
%
%
% modeliousMajor = getFiltered(modeliousMajor, filtH, 'high');
% modeliousMajor = getFiltered(modeliousMajor, filtL, 'low');
%
% bandEval = Evaluator(sigMod', modeliousMajor(1:end-1), 1);
% [modDVE modList] = bandEval.DVE();
%
%
% figure()
% plot(sigHL-mean(sigHL),'r')
% hold on;
% plot((modeliousMajor-mean(modeliousMajor)),'k')
%
%
% figure()
% for i = 1:size(angaliousMajor,2)
%     plot(angaliousMajor(:,i)+i*10)
%     hold on
% end
%
% plot(modList,'k')
%
%
%
%
