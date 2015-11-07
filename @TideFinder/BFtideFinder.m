function [theta] = BFtideFinder(obj)


sigMod = obj.sigMod;
A = obj.A;
P = obj.P;
type = obj.type;

sigModdf = diff(sigMod);

theta = zeros(1,length(P));
t = 0:length(sigMod)-1;

% sprintf('Dont forget to fix index in tideFinders')

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
            
            model = mean(sigMod);
            for k = 1:length(theta)
                model = model + A(k)*cos(2*pi*1/P(k)*t + theta(k));
            end
            
            modeldf = diff(model)';
            
            spacing = linspace(0,1,length(modeldf));
            
            logGrowth = (-log(1-spacing.^4));
            logGrowth(end) = logGrowth(end-1);
            
            offset = 1;
            scale  = 50;
            
            adjuster = offset + scale*(logGrowth-min(logGrowth))/(range(logGrowth));
            
            if type == 1
                cost = sum((sigModdf - modeldf).^2);
            else
                cost = sum(((sigModdf - modeldf).^2).* adjuster');
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
