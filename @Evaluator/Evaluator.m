classdef Evaluator
    
    properties
        
        sigMod;
        model;
        prediction;
        stop_loss = 10;
        one_trade = 0;
        Total;
        Type;
        modMME;
        predMME;
        
        
    end
    
    methods
        
        function obj = Evaluator(sigMod, model, prediction)
            
            obj.sigMod       = sigMod;
            obj.model        = model;
            obj.prediction   = prediction;
            
            
        end
        
        function [modDVE, modDVElist] = DVE(obj)
            
            dmm = diff(obj.model');
            
            dsm = diff(obj.sigMod);
            
            modDVElist = (dmm-dsm).^2;
            
            modDVE = sum(modDVElist);
            
        end
        
        function [Total] = prOHLC(obj, sigProMtrx)
            
            sigPro = sigProMtrx;
            prediction = obj.prediction;
            spmh = max(sigPro(end-(predLen-1):end,2));
            spml = min(sigPro(end-(predLen-1):end,3));
            spec = sigPro(end-predLen,4);
            
            if prediction(end) > prediction(1)
                (spmh - spec)/spec*100
                (spml - spec)/spec*100
            else
                (spec - spmh)/spec*100
                (spec - spml)/spec*100
            end
            
            Total = 1;
            
        end 
            
            
            
            [Total] = percentReturn(obj, sigCmp);
            
            [modMME, predMME, modMMElist, predMMElist] = MME(obj);
            
            [tagged,s_imax,s_imin] = peakAndTrough(obj, graph);
            
            
            
            % mm = evalBF.model_predict(1:modLen);
            % mp = evalBF.model_predict(modLen:end);
            % sm = sigPred(1:modLen);
            % sp = sigPred(modLen:end);
            %
            % lse1 = sum((mm-sm).^2)
            %
            % lse2 = sum((mp-sp).^2)
            %
            
            %
            %
            %
            
            
            
        end
        
    end
    
