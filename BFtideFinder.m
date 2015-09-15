function [theta] = BFtideFinder(filt_signal_mod_against, A, P)

tideFiltered = filt_signal_mod_against;
tideFiltd = diff(tideFiltered);


theta = zeros(1,length(P));
t = 1:length(tideFiltered);

res = .01;

sqre = [];
sqreTot = [];


for w = 1:3
    for i = 1:length(theta)
        
        for j = 0:res:2*pi
            
            theta(i) = j;
            
            model = mean(tideFiltered);
            for k = 1:length(theta)
                model = model + A(k)*cos(2*pi*1/P(k)*t + theta(k));
            end
     
            modeld = diff(model);
            
            errorTerm = [sum((tideFiltd - modeld).^2), theta];
            sqre = [sqre; errorTerm];
            
        end
        
        theta(i) = sqre(find(sqre == min(sqre(:,1))),i+1);
        sqreTot = [sqreTot; sqre];
        sqre = [];
        
    end
end


end 
