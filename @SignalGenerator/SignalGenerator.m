
classdef SignalGenerator
    
    properties
        
        stockp;
        presentp;
        sigLenp;
        RANSTEPp;
        FAKERp;
        REALERp;
        Ap;
        Pp;
        php;

    end
    
    
    methods
        
        function obj = SignalGenerator(stock, present, signal_length, RANSTEP, FAKER, REALER, ph, A, P);
             
             obj.stockp     = stock;
             obj.presentp   = present;
             obj.sigLenp    = signal_length;
             obj.RANSTEPp   = RANSTEP;
             obj.FAKERp     = FAKER;
             obj.REALERp    = REALER;
             obj.php        = ph;
             obj.Ap         = A;
             obj.Pp         = P;
  

       end
        
        function [signal] = getSignal(obj)
            
            stock   = obj.stockp;
            present = obj.presentp;
            sigLen  = obj.sigLenp;
            RANSTEP = obj.RANSTEPp;
            FAKER   = obj.FAKERp;
            REALER  = obj.REALERp;
            ph      = obj.php;
            A       = obj.Ap;
            P       = obj.Pp;
            
            
           
            
            yc = getStock(stock, present, sigLen, 'ac');
            signal = yc';
%             x1 = 12;
%             
%             t = 1 : sigLen;
%             
%             for i = 1:length(A)
%                 x1 = x1 + A(i)*cos(2*pi*1/P(i)*t + ph(i));
%             end
%             
%             
%             stepper = zeros(length(t),1);
%             
%             sSizee = [1975, 1930, 1857, 1332, 1000,900, 740, 600, 450, 180, 140, 50];
%             sAmp =  [7, 10, 3, -15, -5, -2, 8 ,3, 0, 4, 9, 7]/4;
%             
%             for i = 1:length(sSizee)
%                 stepper(end-(sSizee(i)-1):end) = sAmp(i)*ones(sSizee(i),1);
%                 
%             end
%             
%             rander = zeros(length(t),1);
%             
%             for i = 1:length(rander)
%                 
%                 if mod(i,4) == 0
%                     rander(i) = (-0.5+rand(1,1))*1.2;
%                 end
%             end
%             
%             if RANSTEP == 1
%                 x1 = x1+stepper'+rander';
%             end
%             
%             if FAKER == 1
%                 signal = x1;
%             end
%             
%             if REALER == 1
%                 signal = yc';
%             end
%             
%             
        end
  
    end
    
end




