function [modMME, predMME, modMMElist, predMMElist] = MME(obj)

model_predict = obj.model_predict;
sigPred = obj.sigPred;
modLen = obj.modLen;

for i = 1:2
    
    if i == 1
        [Modindex,Modindexpeak,Modindextrough] = obj.peakAndTrough(model_predict(1:modLen));
        [Sigindex,Sigindexpeak,Sigindextrough] = obj.peakAndTrough(sigPred(1:modLen));
    else
        [Modindex,Modindexpeak,Modindextrough] = obj.peakAndTrough(model_predict(modLen:end));
        [Sigindex,Sigindexpeak,Sigindextrough] = obj.peakAndTrough(sigPred(modLen:end));
    end
    
%     Modindexpeak'
%     Sigindexpeak'
%     Modindextrough'
%     Sigindextrough'
    
    MME = [];
    
    if Modindexpeak(1) > Modindextrough(1)
        Modindextrough(1) = [];
    else
        Modindexpeak(1) = [];
    end
    
    if Modindexpeak(end) < Modindextrough(end)
        Modindextrough(end) = [];
    else
        Modindexpeak(end) = [];
    end
    
    if Sigindexpeak(1) > Sigindextrough(1)
        Sigindextrough(1) = [];
    else
        Sigindexpeak(1) = [];
    end
    
    if Sigindexpeak(end) < Sigindextrough(end)
        Sigindextrough(end) = [];
    else
        Sigindexpeak(end) = [];
    end
    
%     Modindexpeak'
%     Sigindexpeak'
%     Modindextrough'
%     Sigindextrough'
    
    for m = Modindexpeak
        MME = [MME; (min(abs((m - Sigindexpeak)))).^2];
    end
    
    for m = Modindextrough
        MME = [MME; (min(abs((m - Sigindextrough)))).^2];
    end
    
    if i == 1
        modMMElist = MME;
    else
        predMMElist = MME;
    end
end

modMME = sum(modMMElist);
predMME = sum(predMMElist);

end
