% TideFinder

close all;
clearvars -except signal


P = [122, 84, 52, 31, 24]

A = [4, 2, 1.5, 1, 0.5]/4.3

ph = [1.2, 0.9, 1.2, 0.4, 2.4]

theta = [0,0,0,0,0];

modLen = 200;
tideSig = signal(1:201);


res = .01;

t = 0:modLen;



sqre = [];
sqreTot = [];
figure()


for w = 1:3
for i = 1:length(theta)
    
    for j = 0:res:2*pi
        
        theta(i) = j;
        
        model = 0;
        for k = 1:length(theta)
            model = model + mean(tideSig) + A(k)*cos(2*pi*1/P(k)*t + theta(k));
        end
        
        errorTerm = [sum((tideSig - model).^2), theta];
        sqre = [sqre; errorTerm];

    end
    
    theta(i) = sqre(find(sqre == min(sqre(:,1))),i+1);
    sqreTot = [sqreTot; sqre];
    sqre = [];
    
end
end 



plot(sqreTot(:,1))




%     end
%
     
%     theta
%     sqreTot = [sqreTot;sqre]
%     sqre = [];


% end




%     plot(sqreTot(:,1))


% theta = sqre(find(sqre == min(sqre(:,1))),:)
%
%
%
% for i = 1:length(theta)
%     model = mean(tideSig) + A(i)*cos(2*pi*1/P(i)*t + theta(i));
% end

% plot(model,'b');
% hold on;
% plot(tideSig,'r');