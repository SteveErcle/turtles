classdef TurtleData
    
    properties
        
    end
    
    methods
        
        function [mPast, mCong, wPast, wCong, dCong] = getData(obj, stock, past, simulateFrom, simulateTo)
            
            c = yahoo;
            
            dCong = fetch(c,stock,simulateFrom, simulateTo, 'd');
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
        end

        function [ok] = checkData(obj, stock, tCong, hlcoDs, checkDateFrom, checkDateTo)
            
            for i = 1:40
                if abs(tCong(1,1) - tCong(i,1)) ~= 0 & abs(tCong(1,1) - tCong(i,1)) < 20
                    timePeriod  = 'w';
                    break
                elseif abs(tCong(1,1) - tCong(i,1)) ~= 0 & abs(tCong(1,1) - tCong(i,1)) > 20
                   timePeriod = 'm';
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
        
    end
    
    
    
end
