classdef TurtleData
    
    properties
        
    end
    
    methods
        
        function [mPast, mCong, wPast, wCong, dPast, dCong] = getData(obj, stock, past, simulateFrom, simulateTo)
            
            c = yahoo;
            
            dPast = fetch(c,stock,past, simulateFrom, 'd');
            dCong = fetch(c,stock,simulateFrom, simulateTo, 'd');
            dCong(:,end) = dCong(:,1);
       
            hlcoDs = TurtleVal(dCong);
            
            mPast = fetch(c,stock,past, simulateFrom, 'm');
            mCong = [];
            for i=1:length(hlcoDs.da)
                disp(datestr(hlcoDs.da(i)))
                m = fetch(c,stock,hlcoDs.da(i)-50, hlcoDs.da(i),'m');
                m(1,end+1) = hlcoDs.da(i);
                mCong = [mCong; m(1,:)];
            end
            
            wPast = fetch(c,stock,past, simulateFrom, 'w');
            wCong = [];
            for i=1:length(hlcoDs.da)
                disp(datestr(hlcoDs.da(i)))
                w = fetch(c,stock,hlcoDs.da(i)-20, hlcoDs.da(i),'w');
                w(1,end+1) = hlcoDs.da(i);
                wCong = [wCong; w(1,:)];
            end
            
            close(c)
            
        end
        
        function [ok] = checkData(obj, stock, tCong, hlcoDs, checkDateFrom, checkDateTo, isPlot, figHandle)
            
            
            if isPlot
                tf = TurtleFun;
            end
            
            
            for i = 1:size(tCong,1)
                if abs(tCong(1,1) - tCong(i,1)) ~= 0 & abs(tCong(1,1) - tCong(i,1)) < 20
                    timePeriod  = 'w';
                    tickSize = 3;
                    break
                elseif abs(tCong(1,1) - tCong(i,1)) ~= 0 & abs(tCong(1,1) - tCong(i,1)) > 20
                    timePeriod = 'm';
                    tickSize = 5;
                    break
                end
            end
            
            indxFrom = find(hlcoDs.da == checkDateFrom);
            indxTo = find(hlcoDs.da == checkDateTo);
            
            tCheck = [];
            
            c = yahoo;
            
            for i = indxFrom :-1: indxTo
                
                checkDate = hlcoDs.da(i);
                
                tCheck = fetch(c,stock,checkDate-50, checkDate, timePeriod);
                
                tCheck = tCheck(1,:);
                
                if isPlot
                    figure(figHandle)
                    [hi, lo, cl, op, da] = tf.returnOHLCDarray(tCheck);
                    plot([da,da], [lo,hi],'r');
                    plot([da-tickSize,da], [op,op],'r');
                    plot([da,da+tickSize], [cl,cl],'r');
                    hold on
                end
                
                Indx = find(tCong(:,end) == checkDate);
                
                if sum(tCong(Indx, 1:5) == tCheck(1:5)) ~= 5
                    disp('ERROR: failed during check')
                    ok = 0;
                    return
                end
            end
            close(c)
            ok = 1;
        end
        
        function [dateIndx] = getDateIndx(obj, array, date)
            
            dateIndx = find(array(:,end) == date);
            
        end
        
    end
    
    
    
end
