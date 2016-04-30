classdef TurtleData
    
    properties
        
    end
    
    methods
        
        function [mAll, mCong, wAll, wCong, dAll, dCong, iAll] = getData(obj, stock, past, simulateFrom, simulateTo)
            
            c = yahoo;
            
            dAll = fetch(c,stock,past, simulateTo, 'd');
            wAll = fetch(c,stock,past, simulateTo, 'w');
            mAll = fetch(c,stock,past, simulateTo, 'm');
            
            dCong = fetch(c,stock,simulateFrom, simulateTo, 'd');
            dCong(:,end+1) = dCong(:,1);
            
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
            
            iAll = [];
            iAll.date = [];
            
            minutes = 5;
            interval = num2str(60*minutes);
            prevdays = '100d';
            stockexchange = 'NYSE';
            try
                iAll = IntraDayStockData(stock,stockexchange,interval,prevdays);
                iAll.dateDay = datestr(iAll.date,2);
            catch
                disp('Failed to fetch intraday data')
            end
            
        end
        
        function [] = saveData(obj, stock, mAll, mCong, wAll, wCong, dAll, dCong, iAll)
            
            save(strcat(stock, 'data'), 'mAll', 'mCong', 'wAll', 'wCong', 'dAll', 'dCong', 'iAll');
            
        end
        
        function [mAll, mCong, wAll, wCong, dAll, dCong, iAll] = loadData(obj, stock)
            
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
            
            if isa(date, 'char')
                date = datenum(date,'mm/dd/yyyy');
            end
            
            dateIndx = find(array(:,end) == date);
            
            if isempty(dateIndx)
                
                %                 disp('Finding Closest Date')
                
                [M dateIndx] = min( abs(array - date));
                
            end
            
        end
        
        function [primaryRange, secondaryRange, primaryDates, secondaryDates] = setRanges(obj, handles, tAll)
            
            
            primaryStartDate = floor(get(handles.axisView, 'Value'));
            secondaryStartDate = floor(get(handles.axisSecondary, 'Value'));
            
            primaryStartIndx = obj.getDateIndx(tAll.GSPC(:,1), primaryStartDate);
            secondaryStartIndx = obj.getDateIndx(tAll.GSPC(:,1), secondaryStartDate);
            
            offSet = floor(get(handles.axisLen, 'Value'));
            
            primaryEndDate = primaryStartDate - offSet;
            secondaryEndDate = secondaryStartDate - offSet;
            
            primaryEndIndx = obj.getDateIndx(tAll.GSPC(:,1), primaryEndDate);
            secondaryEndIndx = obj.getDateIndx(tAll.GSPC(:,1), secondaryEndDate);
            
            
            primaryRange = primaryStartIndx:primaryEndIndx;
            secondaryRange = secondaryStartIndx:secondaryEndIndx;
            
            if length(primaryRange) > length(secondaryRange)
                secondaryRange = secondaryStartIndx:secondaryEndIndx+1;
            elseif length(primaryRange) < length(secondaryRange)
                secondaryRange = secondaryStartIndx:secondaryEndIndx-1;
            end
            
            primaryDates = [primaryEndDate, primaryStartDate];
            
            secondaryDates = [secondaryEndDate, secondaryStartDate];
            
        end
        
        function [tNow] = getTimeDomain(obj, dateIndx, tCong)
            
            
            tNow = [];
            thisT = tCong(dateIndx:end,1:7);
            
            for j = flipud(unique(thisT(:,1)))'
                tNow = [tNow; thisT(min(find(thisT == j)), :)];
            end
            
        end
        
        function time = getAdjustedIntra(obj, time)
            
            time.open = time.close(1:end-1);
            time.high = time.high(2:end);
            time.low = time.low(2:end);
            time.close = time.close(2:end);
            time.volume(2) = time.volume(2) + time.volume(1);
            time.volume = time.volume(2:end);
            time.date = time.date(1:end-1);
            time.datestring = time.datestring(1:end-1);
            
            if length(time.date) == 77 || length(time.date) == 12
                time.open = [time.open(1); time.high];
                time.high = [time.open(1); time.high];
                time.low = [time.open(1); time.low];
                time.close = [time.open(1); time.close];
                time.volume = [0; time.volume];
                time.date = [0; time.date];
                time.datestring = [{'Missing 9:30'}; time.datestring];
            end
            
        end
        
        function time = getIntraForDate(obj, timeAll, dateSelected)
            
            dateSelected = datenum(dateSelected);
            dateSelected = datestr(dateSelected,2);
            
            intraIndx = strmatch(dateSelected, datestr(timeAll.date,2));
            
            if isempty(intraIndx)
                disp('** Intraday data not available **')
            end
            
            time.high = timeAll.high(intraIndx);
            time.low = timeAll.low(intraIndx);
            time.close = timeAll.close(intraIndx);
            time.volume = timeAll.volume(intraIndx);
            time.date = timeAll.date(intraIndx);
            time.datestring = timeAll.datestring(intraIndx);

        end
        
        
    end
    
end
