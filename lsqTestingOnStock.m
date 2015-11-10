close all
clear
clc

addpath('/Users/Roccotepper/Documents/turtles/TurtleData')
addpath('/Users/Roccotepper/Documents/turtles/sinide')


filtL = 0.4;
filtH = 0.0005;
stock = 'JPM'

sampLen = 418;
predLen = 10;
interval = 10;

day = 1850;
futer = 0;
present = day;

% sFFT = SignalGenerator(stock, present+2, 2000);
% [sigFFT, sigHL, sigH, sigL] = sFFT.getSignal('c', filtH, filtL);
%
% m = MoonFinder(sigFFT);
% m.getAandP();

foundP = [209 121 81 62 41 33 22 8];
% foundP = [41 33 22 8];
foundA = [0.67 0.63 0.43 0.29 0.16 0.19 0.14 0.08]*4;
% foundP = [209 121 81 62];
% foundA = [0.67 0.63 0.43 0.29];
theta = [1,2,3,4,5,6,7,8];


icl = 1;
hsvNum = futer/interval;
hsvNum = 2;
col = hsv(hsvNum);
figure()
plot(sort(foundP'),'k')


for i = 0:futer/interval
    present = day + i*interval
    
    sMod = SignalGenerator(stock, present+2, sampLen);
    [sig, sigHL, sigH, sigL] = sMod.getSignal ('c', filtH, filtL);
    sigMod = sig;
    
%     figure(10)
%     plot(sigMod)
%     drawnow
    t = (0:length(sigMod)-1).';
    
    fun = @(x)loopClosure(theta, t, sigMod, x);
    
    resMajor = [];
    
    for ii = 1:1
        
        ii
        
        parfor i = 1:500
            
            guess      = zeros(length(theta),3);
            guess(:,1) = rand(length(theta),1)*1;
            %       guess(:,1) = foundA %+ ((-0.5+rand(1,length(foundP)))*2)*1
            %    guess(:,2) = rand(length(theta),1)*210;
            guess(:,2) = foundP + ((-0.5+rand(1,length(foundP)))*2)*5;
            %         guess(end,2 ) = 10;
            guess(:,3) = rand(length(theta),1)*2*pi;
            guess = guess';
            guess = guess(:);
            guess(end+1) = mean(sigMod);
            
            x0 = [guess'];
            
            lb = [];
            ub = [];
            options = optimset('Display', 'off');
            
            [x, resnorm] = lsqnonlin(fun, x0, lb, ub, options);
            
            
            resMinor = [resnorm/sampLen , x];
            resMajor = [resMajor; resMinor];
            
        end
        
        resMajor = sortrows(resMajor,1);
        
        %     if resMajor(1,1) < 1.5
        %         break
        %     end
        
    end
    
    
    sPro = SignalGenerator(stock, present+2+predLen, sampLen+predLen);
    [sigPro, sigHL, sigH, sigL] = sPro.getSignal('c', filtH, filtL);
    
    
    t = TideFinder(sigMod, foundA, foundP);
    t.getTheta('BF');
    c = Construction(foundA, foundP, theta, predLen, sigMod);
    [model, prediction, projection] = c.constructPro();
    c.plotPro(projection-mean(projection), sigPro-mean(sigPro));
    title('BF');
    e = Evaluator(sigMod, model, prediction);
    pr1 = e.percentReturn(sigPro);
    
    
    x = resMajor(1,2:end);
    xReshaped = reshape(x(1:end-1),3,length(theta));
    A = xReshaped(1,:)';
    P = xReshaped(2,:)';
    theta = xReshaped(3,:)';
    storeProps = [P,A,theta];
    storeProps = sortrows(storeProps,1);
    P = storeProps(:,1);
    A = storeProps(:,2);
    %         if P(1) < 8
    %             A(1) = A(1)*10;
    %         end
    theta = storeProps(:,3);
    
    c = Construction(A, P, theta, predLen, sigMod);
    [model, prediction, projection] = c.constructPro();
    c.plotPro(projection-mean(projection), sigPro-mean(sigPro));
    title('lsqBest');
    e = Evaluator(sigMod, model, prediction);
    pr2 = e.percentReturn(sigPro)
    
    display([sort(foundP'), sort(P)]);
    sum(abs(sort(foundP') - sort(P)));
    resMajor(1:3,1);
    
%     figure(1)
%     hold on
%     plot(P,'color', col(icl,:))
%     icl = icl + 1;
    
    x = resMajor(end,2:end);
    xReshaped = reshape(x(1:end-1),3,length(theta));
    A = xReshaped(1,:)';
    P = xReshaped(2,:)';
    theta = xReshaped(3,:)';
    storeProps = [P,A,theta];
    storeProps = sortrows(storeProps,1);
    P = storeProps(:,1);
    A = storeProps(:,2);
    %     if P(1) < 8
    %         A(1) = A(1)*10;
    %     end
    theta = storeProps(:,3);
    
    c = Construction(A, P, theta, predLen, sigMod);
    [model, prediction, projection] = c.constructPro();
    c.plotPro(projection-mean(projection), sigPro-mean(sigPro));
    title('lsqWorst');
    e = Evaluator(sigMod, model, prediction);
    pr3 = e.percentReturn(sigPro);
    
    display([sort(foundP'), sort(P)]);
    sum(abs(sort(foundP') - sort(P)));
    resMajor(1:3,1);
    
%     figure(1)
%     hold on
%     plot(P,'color', col(icl,:))
%     icl = icl + 1;
    
    pr_me = [pr1,pr2,pr3]
    
    pause
    
    close 2
    
end


% deltaSum = [];
% for i = 1:size(resMajor,1)
%     resP = resMajor(i,3:3:size(resMajor,2));
%     selectedP = sortrows(abs(resP)',-1);
%     deltaP = abs(selectedP-foundP');
%     deltaSum = [deltaSum; sum(deltaP),resMajor(i,:)];
% end
%
%
% deltaSum = sortrows(deltaSum,1);
% deltaSum = deltaSum(:,2:end);
%
% x = deltaSum(1,2:end);
% xReshaped = reshape(x(1:end-1),3,length(theta));
% A = xReshaped(1,:);
% P = xReshaped(2,:);
% theta = xReshaped(3,:);
%
% display([sort(foundP'), sort(P')]);
% sum(abs(sort(foundP') - sort(P')))
%
%
%
% c = Construction(A, P, theta, predLen, sigMod);
% [model, prediction, projection] = c.constructPro();
% c.plotPro(projection-mean(projection), sigPro-mean(sigPro));

%     sprintf('Properties found via sorting deltaSum')
%     display([A',P',theta'])


% pause;
% close all;

% end

% figure()
% plot(resMajor(:,1))




% [frq,amp,phi,ave,ssq,cnt] = sinide(sigMod,1,0);
%
% P = 1/frq;
% A = amp;
% theta = phi - pi/2;
% ssq/1000;
%
% props = [P, A, theta, sampLen];
%
% c = Construction(A, P, theta, predLen, sigMod);
% [model, prediction, projection] = c.constructPro();
% c.plotPro(projection, sigPro);
%
% sprintf('Properties found via sinide')
% display([A;P;theta])




