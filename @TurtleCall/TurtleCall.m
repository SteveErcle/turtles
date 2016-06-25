classdef TurtleCall < handle
    
    properties
        
        P = [];
        lastP = [];
        
        mode = 'l';
        
        
        data = [];
        
    end
    
    methods
        
        function callMouse(obj, object, eventdata)
            
            obj.P = get(gca, 'CurrentPoint');
            obj.P;
            xlimit = xlim;
            plot([xlimit(1), xlimit(2)], [obj.P(1,2), obj.P(1,2)]);
            
        end
        
        
        function callKey(obj, object, eventdata);
            key = eventobj.data.Key;
            
            obj.mode = key
            
        end
        
        
        function callClick(obj, object, eventdata)
            get(gca, 'CurrentPoint')
            
        end
        
        
        function ibStreamer(obj, varargin)
            
            
            
            % Get ticker request ID's
            tickerID = evalin('base','tickerID');
            
            % Process event based on identifier
            switch varargin{end}
                
                case 'tickSize'
                    
                    % Get table index
                    tInd = find(varargin{6}.id == tickerID);
                    
                    switch varargin{6}.tickType
                        case 0
                            % BID SIZE
                            obj.data{tInd,4} = varargin{6}.size;
                        case 3
                            % ASK SIZE
                            obj.data{tInd,6} = varargin{6}.size;
                        case 5
                            % LAST SIZE
                            obj.data{tInd,2} = varargin{6}.size;
                        case 8
                            % VOLUME
                            obj.data{tInd,7} = varargin{6}.size;
                    end
                    %                     set(t,'obj.data',obj.data)
                    
                case 'tickString'
                    
                    switch varargin{6}.tickType
                        
                        case 45
                            % Display current time
                            
                            % IB base date is 01/01/1970
                            dateEpoch = datenum('01-Jan-1970');
                            
                            % Convert IB current time to MATLAB date number
                            currentTime = datestr(dateEpoch + str2double(varargin{6}.value)/(24*60*60));
                            
                    end
                    
                case 'tickPrice'
                    
                    % Get table index
                    tInd = find(varargin{7}.id == tickerID);
                    
                    switch varargin{7}.tickType
                        case 1
                            % BID PRICE
                            obj.data{tInd,3} = varargin{7}.price;
                        case 2
                            % ASK PRICE
                            obj.data{tInd,5} = varargin{7}.price;
                        case 4
                            % LAST PRICE
                            obj.data{tInd,1} = varargin{7}.price;
                    end
                    
            end
            
            obj.data
            
        end
        
    end
end
