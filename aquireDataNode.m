
clear all; close all; clc;

tf = TurtleFun;
td = TurtleData;

stock = 'CLDX'
exchange = 'NYSE';

past = '1/1/15';
simulateFrom = '10/15/15';
simulateTo = '1/1/16';


[mPast, mCong, wPast, wCong, dCong] = td.getData(stock, past, simulateFrom, simulateTo);
            
figure()
[figHandle, pHandle] = tf.plotHiLo(mPast(2:end,:))
figure()
[figHandle2, pHandle] = tf.plotHiLo(wPast(2:end,:))



c = yahoo


p = 0;

for i = flipud(dCong(:,1))'
    
     
    if p(1) ~= 0 && isempty(find(mCong(:,1) == i))
        delete(p)
    end
    
    
    Indx = find(mCong(:,end) == i)
    
    datestr(i)
    
    t = mCong(Indx,:)
    [hi, lo, cl, op, da] = tf.returnOHLCDarray(t);
    
    
    mCheck = fetch(c,stock,i-50, i, 'm');
    mCheck(1,:)
    mCong(Indx,1:end-1)
    
    p(1) = plot([da,da], [lo,hi])
    p(2) = plot([da-5,da], [op,op])
    p(3) = plot([da,da+5], [cl,cl])
    
    hold on

pause
   
    
end


close(c)


