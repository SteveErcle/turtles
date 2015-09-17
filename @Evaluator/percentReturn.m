function [Total] = percentReturn(obj)

% , sigPred, modLen, model_predict, stop_loss, one_trade)


%% Finds the percent return from long buys and short sales
% Input getStock 'all' matrix and total signal 
% Stop loss = 1 and one trade = 0 for general analysis
% Stop loss is a feature that will be added
% This function will be cleaned up for future use



% yHIGH = yMatrix(end-(length(eq_test))+1:end,2);
% yLOW = yMatrix(end-(length(eq_test))+1:end,3);
% 
% y = yMatrix(end-(length(eq_test))+1:end,4);
% 
% yhl = zeros(length(y),3);
% yhl(:,1) = y; %y;
% yhl(:,2) = yHIGH; %dataH_fut;
% yhl(:,3) = yLOW; %dataL_fut;


sigPred = obj.sigPred;
modLen = obj.modLen;
model_predict = obj.model_predict;
stop_loss = obj.stop_loss;
one_trade = obj.one_trade;

sigPred = sigPred(modLen:end);

y = sigPred;
yhl(:,1) = sigPred;
yhl(:,2) = sigPred;
yhl(:,3) = sigPred;


eq_test = model_predict(modLen:end);


[tagged,imax,imin] = obj.peakAndTrough(eq_test);

actual = [];
tagged;
Long_sum = 0;
Short_sum = 0;
Total = 0;
for i=1:length(tagged)
    actual = [actual; y(tagged(i)),eq_test(tagged(i))];
end


if one_trade == 1
    
    imin = find(eq_test == min(eq_test));
    imax = find(eq_test == max(eq_test));
    
    if (imin < imax)
        actual = [y(imin);y(imax)];
        tagged = [imin;imax];
    end
    
    if (imin > imax)
        actual = [y(imax);y(imin)];
        tagged = [imax;imin];
    end
    
end


i = 1;

if (imin(1) < imax(1))
    
    while i < length(tagged)
        long = (actual(i+1)-actual(i))/actual(i);
        for t = tagged(i):tagged(i+1)
            t;
            y(tagged(i));
            yhl(t,3);
            if yhl(t,3) < y(tagged(i))*(1-stop_loss)
                long = -stop_loss;
                break
            end
        end
        
        i = i + 1;
        Total = Total + long;
        Long_sum = Long_sum + long;
        
        
        if i < length(tagged)
            short =(actual(i)-actual(i+1))/actual(i);
            for t = tagged(i):tagged(i+1)
                t;
                y(tagged(i));
                yhl(t,2);
                if yhl(t,2) > y(tagged(i))*(1+stop_loss)
                    short = -stop_loss;
                    break
                end
            end
            i = i + 1;
            Total = Total + short;
            Short_sum = Short_sum + short;
            
        end
    end
    
else
    
    while i < length(tagged)
        short =(actual(i)-actual(i+1))/actual(i);
        actual;
        for t = tagged(i):tagged(i+1)
            t;
            y(tagged(i));
            yhl(t,2);
            if yhl(t,2) > y(tagged(i))*(1+stop_loss);
                short = -stop_loss;
                break
            end
        end
        i = i + 1;
        Total = Total + short;
        Short_sum = Short_sum + short;
        
        if i < length(tagged)
            long = (actual(i+1)-actual(i))/actual(i);
            actual;
            for t = tagged(i):tagged(i+1)
                t;
                y(tagged(i));
                yhl(t,3);
                if yhl(t,3) < y(tagged(i))*(1-stop_loss)
                    long = -stop_loss;
                    break
                end
            end
            i = i + 1;
            Total = Total + long;
            Long_sum = Long_sum + long;
        end
    end
end

Long_sum;
Short_sum;
Total;

Total = Total*100;

end