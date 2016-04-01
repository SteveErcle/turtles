classdef TurtleAnalyzer < handle
    
    properties
        
        tf = TurtleFun;
        
    end
    
    methods
        
        function beta = calcBeta(obj)
            
            
            for i = 1:size(da)-1
                perCl = [perCl; (cl(i) - cl(i+1)) / cl(i+1)*100];
                perClD = [perClD; beta*(clD(i) - clD(i+1)) / clD(i+1)*100];
            end
            
            beta = cov(perCl, perClD) / var(perClD)
            beta = beta(1,2)
            
        end
       
        function perSecurity = percentChange(obj, varargin)
            
            if nargin == 2
                tAll = varargin{1};
                beta = 1;
            elseif nargin == 3
                    tAll = varargin{1};
                    beta = varargin{2};
            end 
                
            
            [hi, lo, cl, op, da] = obj.tf.returnOHLCDarray(tAll);
            
            perSecurity = [];
            % add beta;
            for i = 1:size(da)-1
                perSecurity = [perSecurity; beta*((op(i) - op(i+1)) / op(i+1)),...
                    beta*((hi(i) - hi(i+1)) / hi(i+1)),...
                    beta*((lo(i) - lo(i+1)) / lo(i+1)),...
                    beta*((cl(i) - cl(i+1)) / cl(i+1))];
            end
            
        end
        
        function adjustedStock = adjustPrice(obj, perStock, dAll)
            
            adjustedStock = dAll(end,2:5);
            for i = 1:size(perStock,1)-1
                adjustedStock = [adjustedStock; adjustedStock(i,:)./(1+perStock(i,:))];
            end
            
        end
        
        
    end
    
    
    
    
    
end
