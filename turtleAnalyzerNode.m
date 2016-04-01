% testGet data

clear all; clc; close all;


beta = 1.29;

past = '1/1/16';
simulateTo = now;

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

Idx = dAvg(:,5:5);
Scb = dAll(:,5:5);

per = [];


for i = 1 : size(Idx,1) - 1
    per = [per; beta* ((Idx(i,:) - Idx(i+1,:)) ./ Idx(i+1,:))];
end 

Sio = Scb(1,:);

for i = 1 : size(Idx,1) - 1
  Sio(i+1,:) = Sio(i,:) ./ (1+per(i,:));
end 


Sro = Scb(1) + (Scb - Sio);

ScbF = diff(getFiltered(Scb,0.1,'low'));
SioF = diff(getFiltered(Sio,0.1,'low'));
SroF = diff(getFiltered(Sro,0.1,'low'));


wSize = 10;
ScbS = (tsmovavg(flipud(Scb),'s',wSize,1));
SioS = (tsmovavg(flipud(Sio),'s',wSize,1));
SroS = (tsmovavg(flipud(Sro),'s',wSize,1));


ScbS(end:end-wSize) = ScbS(end-wSize);

% subplot(2,1,1)
hold on
% [hi, lo, cl, op, da] = tf.returnOHLCDarray(dAll);
% highlow(hi, lo, op, cl, 'red', da);
plot(da,Sio)
plot(da,Scb,'r')
plot(da,Sro, 'g')


% subplot(2,1,2)
hold on
plot(da(1:end),SioS)
plot(da(1:end),ScbS,'r')
plot(da(1:end),SroS, 'g')


return 

p = 0;
while(true)
    
pause(0.2)
    h = gcf;
    axesObjs = get(h, 'Children');
    axesObjs = findobj(axesObjs, 'type', 'axes');
    dataTips = findall(axesObjs, 'Type', 'hggroup', 'HandleVisibility', 'off');
    
    if length(dataTips) > 0
        
        cursor = datacursormode(gcf);
        values = cursor.getCursorInfo;
        
        tData = values.Position;
        if ishandle(p) & p(1) ~= 0
            delete(p)
        end 
        subplot(2,1,1)
        p(1) = plot(tData(1), tData(2), 'bo');
        subplot(2,1,2)
        p(2) = plot(tData(1), tData(2), 'bo');
    end
    delete(dataTips);
    
end



% subplot(2,1,1)
% [hi, lo, cl, op, da] = tf.returnOHLCDarray([da,Idx]);
% highlow(hi, lo, op, cl, 'blue', da);
% 
% subplot(2,1,2)
% hold on
% [hi, lo, cl, op, da] = tf.returnOHLCDarray([da,Sio]);
% highlow(hi, lo, op, cl, 'blue', da);
% [hi, lo, cl, op, da] = tf.returnOHLCDarray([da,Scb]);
% highlow(hi, lo, op, cl, 'red', da);
% [hi, lo, cl, op, da] = tf.returnOHLCDarray([da,Sro]);
% highlow(hi, lo, op, cl, 'green', da);


