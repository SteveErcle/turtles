function [theta] = TideFinder(signal, PLOT, A, P)



theta = zeros(P,1);

modLen = 200;
tideSig = signal(1:201);

res = .01;
t = 0:modLen;

sqre = [];
sqreTot = [];


for w = 1:3
    for i = 1:length(theta)
        
        for j = 0:res:2*pi
            
            theta(i) = j;
            
            model = mean(tideSig);
            for k = 1:length(theta)
                model = model + A(k)*cos(2*pi*1/P(k)*t + theta(k));
            end
            
            errorTerm = [sum((tideSig - model).^2), theta];
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

end 
