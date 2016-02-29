

% arduino testing
clear all; close all; clc;

a = arduino('/dev/tty.usbmodem1411','Uno')

volt = [];
configureDigitalPin(a,7, 'input');
configureDigitalPin(a,8, 'output');


writeDigitalPin(a,8,1)

for i = 1:1000

    disp([readDigitalPin(a,7),...
        readDigitalPin(a,6),...
        readDigitalPin(a,5),...
        readDigitalPin(a,4),...
        readVoltage(a,0),...
        readVoltage(a,1)]);

% i;
% 
% if i == 5
%     writeDigitalPin(a,8,1)
% end
% 
% if i == 6
%     writeDigitalPin(a,8,0)
% end
% 
% if readDigitalPin(a,7) == 1
% 
%     disp('1');
% else
%     disp('0');
% end


% pause(0.1)

end 









% while (true)
%     
%         voltage = readVoltage(a,2)
%         volt = [volt;voltage];
%     
%         plot(volt)
% %     
% %     if readDigitalPin(a,7) == 1
% %         for i = 1:1
% %             configureDigitalPin(a,7, 'unset');
% %             writeDigitalPin(a,7,0);
% %             configureDigitalPin(a,7,'unset')
% %         end
% %         
% %         if readDigitalPin(a,7) == 1
% %             configureDigitalPin(a,7, 'unset');
% %             writeDigitalPin(a,7,0);
% %             configureDigitalPin(a,7,'unset')
% %           
% %             
% %             disp('1')
% %         end
%         
%         
% %         
% %     else
% %         disp('0');
% %     end
%     
%     pause(0.025)
%     
%     
% end
%
%     volt = [];
% configureDigitalPin(a,7, 'input');
% configureDigitalPin(a,8, 'output');
% writeDigitalPin(a,8,0);
%


% pause

% writeDigitalPin(a, 7, 1);
% pause
% writeDigitalPin(a, 7, 0);
% pause
%
%
% pause