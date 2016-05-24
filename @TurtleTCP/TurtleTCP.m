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
            
            data = [];
       
%             while(obj.t.BytesAvailable)
                data = [data; fread(obj.t, num, precision)];
%             end
            
        end

    end
 
end

