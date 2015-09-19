function [theta] = BFtideFinder(obj)


filt_signal_mod_against = obj.sigMod;
A = obj.A;
P = obj.P;
type = obj.type;

tideFiltered = filt_signal_mod_against;
tideFiltd = diff(tideFiltered);


theta = zeros(1,length(P));
t = 1:length(tideFiltered);

res = .01;

sqre = [];
sqreTot = [];

% cr = 0:res:2*pi;
% cr = length(cr)-1
% parfor jj = 0:cr;
%     
%     j = jj*res;


for w = 1:2
    for i = 1:length(theta)
        for j = 0:res:2*pi
            
            theta(i) = j;
            
            model = mean(tideFiltered);
            for k = 1:length(theta)
                model = model + A(k)*cos(2*pi*1/P(k)*t + theta(k));
            end
     
            modeld = diff(model);
            
            spacing = linspace(0,1,length(modeld));
            
            logGrowth = (-log(1-spacing.^4));
            logGrowth(end) = logGrowth(end-1);

            offset = 1;
            scale  = 100;
            
            adjuster = offset + scale*(logGrowth-min(logGrowth))/(range(logGrowth));
            
            if type == 1
                cost = sum((tideFiltd - modeld).^2);
            else
                cost = sum(((tideFiltd - modeld).^2).* adjuster);
            end
            
            errorTerm = [cost, theta];
            sqre = [sqre; errorTerm];
            
            
        end
        
        theta(i) = sqre(find(sqre == min(sqre(:,1))),i+1);
        sqreTot = [sqreTot; sqre];
        sqre = [];
        
        
    end
end


end 
