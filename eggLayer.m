% eggLayer

clear all;
close all;
clc;


c = yahoo;
stock = 'COT';


yearlyHL = [];

figure()
for i = 0:1
    
    for j = 3:12
        
        year1 = 2001;
        year2 = 2001 + i;
        month = j;
        monthDay = strcat(num2str(month),'/33/');
        m = fetch(c,stock,strcat('1/1/', num2str(year1)),...
            strcat(monthDay, num2str(year2)), 'm');
        
        subplot(1,3,1)
        highlow(m(3:end,3), m(3:end,4),...
            m(3:end,3), m(3:end,4),'blue',m(3:end,1));
        
        
        
        w = fetch(c,stock,strcat('1/1/', num2str(year1)),...
            strcat(monthDay, num2str(year2)), 'w');
        
        d = fetch(c,stock,strcat('1/1/', num2str(year1)),...
            strcat(monthDay, num2str(year2)), 'd');
        
        
        
        for k = 6:-1:1
            if str2double(datestr(w(k,1),5)) == j
                
                
                subplot(1,3,2)
                highlow(w(k:end,3), w(k:end,4),...
                    w(k:end,3), w(k:end,4),'blue',w(k:end,1));
                
                datestr(w(k,1))
                
                
                f1 = find(w(k+1,1) == d(:,1))
                f2 = find(w(k,1) == d(:,1))
                datestr(d(f2:f1-1,1))
                
                for z = f1:-1:f2
                 
                    subplot(1,3,3)
                    highlow(d(z:end,3), d(z:end,4),...
                        d(z:end,3), d(z:end,4),'blue',d(z:end,1));
                    pause
                end
                
                
                pause
            end
            
            
        end
        
       
    end
end



close(c);

% highlow(d(end-i:end,3), d(end-i:end,4),...
%             d(end-i:end,3), d(end-i:end,4),'blue',d(end-i:end,1));
