classdef Evaluator
    
   properties
       
       sigMod;
       model;
       prediction;
       stop_loss = 1;
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
           
%            predDVElist = (dmp-dsp).^2;
%            
%            predDVE = sum(predDVElist);

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

