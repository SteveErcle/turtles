function [theta] = BFtideFinder(signal, PLOT, A, P)


signal = Filterer(signal);

theta = zeros(1,length(P))

modLen = 500;
tideSig = signal(1:modLen+1);
tideSigd = diff(tideSig);

res = .01;
t = 0:modLen;

sqre = [];
sqreTot = [];

size(tideSig)
size(t)


for w = 1:3
    for i = 1:length(theta)
        
        for j = 0:res:2*pi
            
            theta(i) = j;
            
            model = mean(tideSig);
            for k = 1:length(theta)
                model = model + A(k)*cos(2*pi*1/P(k)*t + theta(k));
            end
     
            modeld = diff(model);
            
            errorTerm = [sum((tideSigd - modeld).^2), theta];
            sqre = [sqre; errorTerm];
            
        end
        
        theta(i) = sqre(find(sqre == min(sqre(:,1))),i+1);
        sqreTot = [sqreTot; sqre];
        sqre = [];
        
    end
end


model = mean(tideSig);
for k = 1:length(theta)
    model = model + A(k)*cos(2*pi*1/P(k)*t + theta(k));
end

if PLOT == 1

figure()
plot(signal,'r')

figure()
plot(sqreTot(:,1))

figure()
plot(model,'b');
hold on;
plot(tideSig,'r');
title('Brute Force');

end 
