classdef TurtleTCP < handle
    
    properties
        
        t;
        port;
        
    end
    
    methods
        
        function obj = TurtleTCP(portNum)
            
            obj.port = portNum;
            
        end
        
        function connect(obj)
            
            sprintf('Connecting to port %d...', obj.port)
            obj.t = tcpip('127.0.0.1', obj.port, 'NetworkRole', 'server');
            fopen(obj.t);
            sprintf('Connected to port %d', obj.port)
            
        end
        
        function data = readInData(obj, num, precision)
            
            data = fread(obj.t, num, precision);
        end
        
        function accumSpread = readInAllDataAS(obj, num, precision, accumSpread)
            
            while obj.t.BytesAvailable > 0
                
                dataAS = fread(obj.t, num, precision);
                
                if ~isempty(dataAS)
                    position   = dataAS(1);
                    side       = dataAS(2);
                    price      = dataAS(3);
                    size       = dataAS(4)/10000;
                    
                    if side == 0
                        accumSpread.sum = accumSpread.sum - price*size
                        accumSpread.total = [accumSpread.total; accumSpread.sum];
                    elseif side == 1
                        accumSpread.sum = accumSpread.sum + price*size
                        accumSpread.total = [accumSpread.total; accumSpread.sum];
                    end
                    
                    accumSpread.time = [accumSpread.time; now];
                    accumSpread.minute = [accumSpread.minute; {datestr(now,15)}];
                    
                end
                
            end
            
        end
        
        
        function priceAction = readInAllDataPA(obj, num, precision, priceAction)
            
            
            while obj.t.BytesAvailable > 0
                
                dataPA = fread(obj.t, num, precision)
                
                if ~isempty(dataPA)
                    priceAction.price = [priceAction.price; dataPA];
                    priceAction.time = [priceAction.time; now];
                    priceAction.minute = [priceAction.minute; {datestr(now,15)}];
                end
                
            end
            
        end
        
        
        
    end
    
end

