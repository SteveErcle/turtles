classdef MoonFinder
    
    properties
        
        signal_pure;
        
    end
    
    
    methods
        
        function obj = MoonFinder(signal_pure)
            obj.signal_pure = signal_pure;
        end
        
        [] = getAandP(obj)
        
    end
    
    
    
    
end
