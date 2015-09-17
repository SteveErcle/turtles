
function [tagged,s_imax,s_imin] = peakAndTrough(obj, graph)

%% Finds the index of peak and troughs
% Organizes to be pasted to percentReturn();


tagged = [];
i = 1;
j = 1;
[ymax,imax,ymin,imin] = getExtrema(graph);

s_imax = sort(imax);
s_imin = sort(imin);


% start at min
if s_imax(1) < s_imin(1)
    
    while (j<=length(imax))
        tagged(i)= s_imax(j);
        if length(imax)>length(imin) && j == length(imax)
            break
        end
        tagged(i+1)=s_imin(j);
        i= i+2;
        j = j+1;
    end
    
else
    
    while (j<=length(imin))
        tagged(i)= s_imin(j);
        if length(imin)>length(imax) && j == length(imin)
            break
        end
        tagged(i+1)=s_imax(j);
        i= i+2;
        j = j+1;
    end
end
tagged;

end 




