
classdef Turtle
    
    properties
        
        sigMod;
        sigPred;
        modLen;
        A;
        P;
        type;
        sigPredUnfilt;
    end
    
    methods
        
        function obj = Turtle(sigMod, sigPred, modLen, A, P)
            obj.sigMod  = sigMod;
            obj.sigPred = sigPred;
            obj.modLen  = modLen;
            obj.A       = A;
            obj.P       = P;
        end
        
        function eval = predictTurtle(obj, eval_Type_String)
            
            if strcmp(eval_Type_String, 'GD')
                theta = GDtideFinder(obj);
            elseif strcmp(eval_Type_String, 'BF')
                theta = BFtideFinder(obj);
            end
            
            model_predict = modelConstruction(obj,theta);
            plotPred(obj, model_predict);
          
            title(eval_Type_String);
            
            eval = Evaluator(obj.sigPred, obj.sigPredUnfilt, obj.modLen, model_predict);
            eval.Total = eval.percentReturn();
            eval.Type = eval_Type_String;
    
            
        end
        
        [theta] = BFtideFinder(obj);
        
        [theta] = GDtideFinder(obj);
        
        [model_predict] = modelConstruction(obj, theta);
        
        plotPred(obj, model_predict);
        
    end
end


