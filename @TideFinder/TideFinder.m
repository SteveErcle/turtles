
classdef TideFinder
    
    properties
        sigMod;
        A;
        P;
        type = 1;
    end
    
    methods
        
        function obj = TideFinder(sigMod, A, P)
            obj.sigMod  = sigMod;
            obj.A       = A;
            obj.P       = P;
        end
        
        
        [theta] = BFtideFinder(obj);
        
        [theta] = GDtideFinder(obj);
        
        
        
        function theta = getTheta(obj, eval_Type_String)
            
            if strcmp(eval_Type_String, 'GD')
                theta = GDtideFinder(obj);
            elseif strcmp(eval_Type_String, 'BF')
                theta = BFtideFinder(obj);
            end
            
        end
        
        %         function eval = predictTurtle(obj, eval_Type_String)
        %
        %             if strcmp(eval_Type_String, 'GD')
        %                 theta = GDtideFinder(obj);
        %             elseif strcmp(eval_Type_String, 'BF')
        %                 theta = BFtideFinder(obj);
        %             end
        %
        %             model_predict = modelConstruction(obj,theta);
        %             plotPred(obj, model_predict);
        %
        %             title(eval_Type_String);
        %
        %             eval = Evaluator(obj.sigPred, obj.sigPredUnfilt, obj.modLen, model_predict);
        %             eval.Total = eval.percentReturn();
        %             eval.Type = eval_Type_String;
        %
        %
        %         end
        %
        
        
    end
end

