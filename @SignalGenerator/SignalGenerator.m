
classdef SignalGenerator
    
    properties
        
        stock;
        present;
        signalLen;
        sigLen;
        RANSTEP;
        FAKER;
        REALER;
        A;
        P;
        ph;

    end
    
    methods
        
        function obj = SignalGenerator(varargin)
            
            obj.stock     = varargin{1};
            obj.present   = varargin{2};
            obj.signalLen = varargin{3};
            obj.sigLen    = varargin{4};
            
            if nargin > 4
                
                obj.RANSTEP   = varargin{5};
                obj.FAKER     = varargin{6};
                obj.REALER    = varargin{7};
                obj.ph        = varargin{8};
                obj.A         = varargin{9};
                obj.P         = varargin{10};
                
            end

        end
       
        function [signal, sig, sigHL, sigH, sigL] = getSignal(obj, ohlc)
           %% Enter ohlc. Ex: 'h' for high, 'ac' for adjusted close.
    
          signal = getStock(obj.stock, obj.present, obj.signalLen, ohlc);
         
          sig = signal(end-obj.sigLen+1:end);
          
          filtH = 0.005;
          filtL = 0.123;

          sigH = getFiltered(sig, filtH, 'high');
          sigL = getFiltered(sig, filtL, 'low');
          sigHL = getFiltered(sigH, filtL, 'low');

        end 
            
        function [signal] = getFakeSignal(obj)
            
            signalLen   = obj.signalLen;
            RANSTEP     = obj.RANSTEP;
            FAKER       = obj.FAKER;
            REALER      = obj.REALER;
            ph          = obj.ph;
            A           = obj.A;
            P           = obj.P;

            x1 = 12;
            
            t = 1 : signalLen;
            
            for i = 1:length(A)
                x1 = x1 + A(i)*cos(2*pi*1/P(i)*t + ph(i));
            end
            
            
            stepper = zeros(length(t),1);
            
            sSizee = [1975, 1930, 1857, 1332, 1000,900, 740, 600, 450, 180, 140, 50];
            sAmp =  [7, 10, 3, -15, -5, -2, 8 ,3, 0, 4, 9, 7]/4;
            
            for i = 1:length(sSizee)
                stepper(end-(sSizee(i)-1):end) = sAmp(i)*ones(sSizee(i),1);
                
            end
            
            rander = zeros(length(t),1);
            
            for i = 1:length(rander)
                
                if mod(i,4) == 0
                    rander(i) = (-0.5+rand(1,1))*1.2;
                end
            end
            
            if RANSTEP == 1
                x1 = x1+stepper'+rander';
            end
            
            if FAKER == 1
                signal = x1;
            end
            
        end
  
    end
    
    
% function FindFiltIntensity = Evaluator(1,1,evalBF.model_predict);
% 
% [tag1] = FindFiltIntensity.peakAndTrough(FindFiltIntensity.model_predict);
% target_num_of_extrema = length(tag1)
% 
% signal = SigObj.getSignal();
% signalHighPass = getFiltered(signal, filt, 'high');
% sigHigh = signalHighPass(day : day  + sigLen+predLen)+15;
% 
% 
% for filt_intensity = 0.075: 0.001:0.175
%     sigHighLow = getFiltered(sigHigh, filt_intensity, 'low');
%     [tag1, max1, min1] = FindFiltIntensity.peakAndTrough(sigHighLow);
%     if abs(length(tag1) - target_num_of_extrema) <= 1
%         found_filt_intensity = filt_intensity;
%         break
%     end
% end
% 
% found_filt_intensity

    
    
    
end




