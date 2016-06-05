classdef TurtleTCP < handle
    
    properties
        
        t;
        port;
        
        isNewMin = 1;
        
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
                        accumSpread.sum = accumSpread.sum - price*size;
                        accumSpread.total = [accumSpread.total; accumSpread.sum];
                        accumSpread.ask(position+1,:) = [price, size];
                    elseif side == 1
                        accumSpread.sum = accumSpread.sum + price*size;
                        accumSpread.total = [accumSpread.total; accumSpread.sum];
                        accumSpread.bid(position+1,:) = [price, size];
                    end
                    
                    accumSpread.time = [accumSpread.time; now];
                    accumSpread.minute = [accumSpread.minute; {datestr(now,15)}];
                    
                    if obj.isNewMin == 1
                        addLen = length(accumSpread.hi) + 1;
                        obj.isNewMin = 0;
                    else
                        addLen = length(accumSpread.hi);
                    end 
                    accumSpread.op(addLen) = accumSpread.total(1)';
                    accumSpread.hi(addLen) = max(accumSpread.total);
                    accumSpread.lo(addLen) = min(accumSpread.total);
                    accumSpread.cl(addLen) = accumSpread.total(end);
                    
%                     if length(accumSpread.op) == 2
%                         accumSpread.op = accumSpread.op';
%                         accumSpread.hi = accumSpread.hi';
%                         accumSpread.lo = accumSpread.lo';
%                         accumSpread.cl = accumSpread.cl';
%                     end 
%                     
                    
                end
                
                
                unqT = unique(accumSpread.minute);
                
                if length(unqT) > 1
                    
%                     thisT = unqT(1);
%                     
%                     indx = strmatch(thisT, accumSpread.minute);
%                     accumSpread.op = [accumSpread.op; accumSpread.total(indx(1))];
%                     accumSpread.hi = [accumSpread.hi; max(accumSpread.total(indx))];
%                     accumSpread.lo = [accumSpread.lo; min(accumSpread.total(indx))];
%                     accumSpread.cl = [accumSpread.cl; accumSpread.total(indx(end))];
%                     accumSpread.ti = [accumSpread.ti; accumSpread.time(1)];
%                     accumSpread.mi = [accumSpread.mi; accumSpread.minute(1)];
                    
                    accumSpread.total = [];
                    accumSpread.time = [];
                    accumSpread.minute = [];
                    
                    obj.isNewMin = 1
                    
                end
                
            end
            
        end
        
        function priceAction = readInAllDataPA(obj, num, precision, priceAction)
            
            while obj.t.BytesAvailable > 0
                
                dataPA = fread(obj.t, num, precision);
                
                if ~isempty(dataPA)
                    
%                     open = dataPA(1);
%                     high = dataPA(2);
%                     low = dataPA(3);
%                     close = dataPA(4);
%                     
                    priceAction.price = [priceAction.price; dataPA'];
                    priceAction.time = [priceAction.time; now];
                    priceAction.minute = [priceAction.minute; {datestr(now,15)}];
                end
                
                
                unqT = unique(priceAction.minute);
                
                if length(unqT) > 1
                    
%                     thisT = unqT(1);
%                     
%                     indx = strmatch(thisT, priceAction.minute);
                    priceAction.op = [priceAction.op; priceAction.price(1,1)];
                    priceAction.hi = [priceAction.hi; max(priceAction.price(1:end-1,2))];
                    priceAction.lo = [priceAction.lo; min(priceAction.price(1:end-1,3))];
                    priceAction.cl = [priceAction.cl; priceAction.price(end-1,4)];
                    priceAction.ti = [priceAction.ti; priceAction.time(1)];
                    priceAction.mi = [priceAction.mi; priceAction.minute(1)];
                    
                    priceAction.price(1:end-1,:) = [];
                    priceAction.time(1:end-1,:) = [];
                    priceAction.minute(1:end-1,:) = [];
                    
                end
                
            end
            
        end
          
    end 
        
end

