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
                w = fetch(c,stock,hlcoDs.da(i)-50, hlcoDs.da(i),'w');
                w(1,end+1) = hlcoDs.da(i);
                wCong = [wCong; w(1,:)];
            end 
        end
    end
    
    
   
    
end 
