classdef Evaluator
    
   properties
       
       sigPred;
       modLen;
       model_predict;
       stop_loss = 1;
       one_trade = 0;
       Total;
       Type;
       
   end
   
   methods
       
       function obj = Evaluator(sigPred, modLen, model_predict)
           
           obj.sigPred = sigPred;
           obj.modLen = modLen;
           obj.model_predict = model_predict;
           
       end
       
      [Total] = percentReturn(obj);
      
      [tagged,s_imax,s_imin] = peakAndTrough(obj, graph);
       
   end  
    
end

