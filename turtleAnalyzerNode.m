% testGet data

clear all; clc; close all;


beta = 1.0;

past = '1/1/15';
simulateTo = now-100;

stock = 'TSLA';

c = yahoo;

dAll = (fetch(c,stock,past, simulateTo, 'd'));
wAll = fetch(c,stock,past, simulateTo, 'w');
mAll = fetch(c,stock,past, simulateTo, 'm');

averages = '^GSPC';
dAvg = fetch(c,averages,past, simulateTo, 'd');

close(c);

tf = TurtleFun;

[hi, lo, cl, op, da] = tf.returnOHLCDarray(dAll);

% Idx = cos(2*pi*1/33*(1:100))' + 10;
% Scb = cos(2*pi*1/17*(1:100) + pi/2)' + 10;

Idx = dAvg(:,2:5);
Scb = dAll(:,2:5);

per = [];

for i = 1 : size(Idx,1) - 1
    per = [per; beta * ((Idx(i,:) - Idx(i+1,:)) ./ Idx(i+1,:))];
end

Sio = Scb(1,:);

for i = 1 : size(Idx,1) - 1
  Sio(i+1,:) = Sio(i,:) ./ (1+per(i,:));
end

Sro = Scb(1) + (Scb - Sio);


wSize = 20;
ScbS = flipud(tsmovavg(flipud(Scb),'s',wSize,1));
SioS = flipud(tsmovavg(flipud(Sio),'s',wSize,1));
SroS = flipud(tsmovavg(flipud(Sro),'s',wSize,1));


% ScbS(end:end-wSize) = ScbS(end-wSize);

subplot(2,1,1)
hold on
[hi, lo, cl, op, da] = tf.returnOHLCDarray(dAvg);
highlow(hi, lo, op, cl, 'black', da);
% plot(da,Sio)

% plot(da,Sro, 'g')


% subplot(2,1,2)
% hold on
% plot(da(1:end),SioS)
% plot(da,ScbS,'r')
% plot(da(1:end),SroS, 'g')
% 
% 
% p = 0;
% while(true)
%     
% pause(0.2)
%     h = gcf;
%     axesObjs = get(h, 'Children');
%     axesObjs = findobj(axesObjs, 'type', 'axes');
%     dataTips = findall(axesObjs, 'Type', 'hggroup', 'HandleVisibility', 'off');
%     
%     if length(dataTips) > 0
%         
%         cursor = datacursormode(gcf);
%         values = cursor.getCursorInfo;
%         
%         tData = values.Position;
%         if ishandle(p) & p(1) ~= 0
%             delete(p)
%         end 
%         subplot(2,1,1)
%         p(1) = plot(tData(1), tData(2), 'bo');
%         subplot(2,1,2)
%         p(2) = plot(tData(1), tData(2), 'bo');
%     end
%     delete(dataTips);
%     
% end



% subplot(2,1,1)
% [hi, lo, cl, op, da] = tf.returnOHLCDarray([da,Idx]);
% highlow(hi, lo, op, cl, 'blue', da);
% 
subplot(2,1,2)
hold on
[hi, lo, cl, op, da] = tf.returnOHLCDarray([da,Sio]);
highlow(hi, lo, op, cl, 'blue', da);
[hi, lo, cl, op, da] = tf.returnOHLCDarray([da,Scb]);
highlow(hi, lo, op, cl, 'red', da);
% [hi, lo, cl, op, da] = tf.returnOHLCDarray([da,Sro]);
% highlow(hi, lo, op, cl, 'black', da);


