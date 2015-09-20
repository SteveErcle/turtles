classdef Evaluator
    
   properties
       
       sigPred;
       modLen;
       model_predict;
       stop_loss = 1;
       one_trade = 0;
       Total;
       Type;
       modMME;
       predMME;
       
   end
   
   methods
       
       function obj = Evaluator(sigPred, modLen, model_predict)
           
           obj.sigPred = sigPred;
           obj.modLen = modLen;
           obj.model_predict = model_predict;
           
       end
       
       function [modDVE, predDVE, modDVElist, predDVElist] = DVE(obj)
           
           mm = obj.model_predict(1:obj.modLen);
           mp = obj.model_predict(obj.modLen:end);
           sm = obj.sigPred(1:obj.modLen);
           sp = obj.sigPred(obj.modLen:end);
           
           dmm = diff(mm);
           dmp = diff(mp);
           dsm = diff(sm);
           dsp = diff(sp);
           
           modDVElist = (dmm-dsm).^2;
           
           modDVE = sum(modDVElist);
           
           predDVElist = (dmp-dsp).^2;
           
           predDVE = sum(predDVElist);

       end 
       
       
      [Total] = percentReturn(obj);
      
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

