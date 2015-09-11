classdef TideFinder
    
    properties
        
        P = [122, 84, 52, 31, 24]
        
        A = [4, 2, 1.5, 1, 0.5]/4.3
        
        ph = [1.2, 0.9, 1.2, 0.4, 2.4]
        
        theta = [0,0,0,0,0];
        
%         modLen = 200;
        res = .01;
%         t = 0:modLen;
        tideSig = signal(1:201);

        
    end
    
    methods

%         function bruteForce()
%             
%             tf = TideFinder
%             
%             figure()
%             plot(signal,'r')
%             
%             sqre = [];
%             sqreTot = [];
%             
%             for w = 1:2
%                 for i = 1:length(TideFinder.theta)
%                     
%                     for j = 0:TideFinder.res:2*pi
%                         
%                         TideFinder.theta(i) = j;
%                         
%                         model = mean(TideFinder.tideSig);
%                         for k = 1:length(TideFinder.theta)
%                             model = model + TF.A(k)*cos(2*pi*1/P(k)*t + theta(k));
%                         end
%                         
%                         model(1);
%                         
%                         errorTerm = [sum((tideSig - model).^2), theta];
%                         sqre = [sqre; errorTerm];
%                         
%                     end
%                     
%                     theta(i) = sqre(find(sqre == min(sqre(:,1))),i+1);
%                     sqreTot = [sqreTot; sqre];
%                     sqre = [];
%                     
%                     theta
%                     
%                     figure()
%                     plot(sqreTot(:,1))
%                     
%                     model = mean(tideSig);
%                     for k = 1:length(theta)
%                         model = model + A(k)*cos(2*pi*1/P(k)*t + theta(k));
%                     end
%                     
%                     figure()
%                     plot(model,'b');
%                     hold on;
%                     plot(tideSig,'r');
%                     
%                 end
%             end
%             
%         end
        
        
    end
    
    
    
end % classdef











