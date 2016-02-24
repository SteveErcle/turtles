classdef TurtleData
    
    properties
        
    end
    
    methods
        
        function [mAll, mCong, wAll, wCong, dAll, dCong] = getData(obj, stock, past, simulateFrom, simulateTo)
            
            c = yahoo;
            
            dAll = fetch(c,stock,past, simulateTo, 'd');
            wAll = fetch(c,stock,past, simulateTo, 'w');
            mAll = fetch(c,stock,past, simulateTo, 'm');
            
            dCong = fetch(c,stock,simulateFrom, simulateTo, 'd');
            dCong(:,end) = dCong(:,1);
       
            hlcoDs = TurtleVal(dCong);

             wCong = [];
            for i=1:length(hlcoDs.da)
                disp(datestr(hlcoDs.da(i)))
                w = fetch(c,stock,hlcoDs.da(i)-20, hlcoDs.da(i),'w');
                w(1,end+1) = hlcoDs.da(i);
                wCong = [wCong; w(1,:)];
            end
            
            
            mCong = [];
            for i=1:length(hlcoDs.da)
                disp(datestr(hlcoDs.da(i)))
                m = fetch(c,stock,hlcoDs.da(i)-50, hlcoDs.da(i),'m');
                m(1,end+1) = hlcoDs.da(i);
                mCong = [mCong; m(1,:)];
            end
  
            close(c)
            
        end
        
        function [] = saveData(obj, stock, mAll, mCong, wAll, wCong, dAll,dCong)
            
            save(strcat(stock, 'data'), 'mAll', 'mCong', 'wAll', 'wCong', 'dAll', 'dCong');
       
        end
        
        function [mAll, mCong, wAll, wCong, dAll, dCong] = loadData(obj, stock)
            
            load(strcat(stock, 'data'));
            
        end

        function [tPast] = resetPast(obj, tCong, tAll, pastDate)
                
            allDate = tCong(obj.getDateIndx(tCong(:,end), pastDate),1);
            
            dateIndx = obj.getDateIndx(tAll(:,1), allDate);
 
            tPast = tAll(dateIndx+1:end,:);
        
        end
        
        function [timePeriod, tickSize] = determineTimePeriod(obj, tCong)
            
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
        end 
        
        function [ok] = checkData(obj, stock, tCong, hlcoDs, checkDateFrom, checkDateTo, isPlot, figHandle)
            
            
            if isPlot
                tf = TurtleFun;
            end
            
            
            [timePeriod, tickSize] = obj.determineTimePeriod(tCong)
            
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
