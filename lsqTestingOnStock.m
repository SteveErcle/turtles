close all
clear
clc

addpath('/Users/Roccotepper/Documents/turtles/TurtleData')
addpath('/Users/Roccotepper/Documents/turtles/sinide')


filtL = 0.4;
filtH = 0.0005;
stock = 'JPM'

sampLen = 67;
predLen = 1;
interval = 10;

day = 2300;
futer = 100;
present = day;

% sFFT = SignalGenerator(stock, present+2, 2000);
% [sigFFT, sigHL, sigH, sigL] = sFFT.getSignal('c', filtH, filtL);
%
% m = MoonFinder(sigFFT);
% m.getAandP();

% foundP = [209 121 81 62 41 33 22 13 10 8];
foundP = [33 22 13 10 8];
% foundP = [41 33 22 8];
% foundA = [0.67 0.63 0.43 0.29 0.16 0.19 0.14 0.08]*4;
% foundP = [209 121 81 62];
foundA = [0.67 0.63 0.43 0.29 .19];
theta = [1,2,3,4,5];

prAll = [];

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
    
    sMtx = SignalGenerator(stock, present+2+predLen, sampLen+predLen);
    [sigMtx, sigHL, sigH, sigL] = sMtx.getSignal('all', filtH, filtL);
    
    for hide_BF = 1:1
        t = TideFinder(sigMod, foundA, foundP);
        t.getTheta('BF');
        c = Construction(foundA, foundP, theta, predLen, sigMod);
        [model, prediction, projection] = c.constructPro();
        c.plotPro(projection, sigPro);
        title('BF');
        e = Evaluator(sigMod, model, prediction);
        pr1 = e.percentReturn(sigPro);
    end
    
    for hide_lsq = 1:1
        
        x = resMajor(1,2:end);
        resMajor(1,1)
        xReshaped = reshape(x(1:end-1),3,length(theta));
        A = xReshaped(1,:)';
        P = xReshaped(2,:)';
        theta = xReshaped(3,:)';
        storeProps = [P,A,theta];
        storeProps = sortrows(storeProps,1);
        P = storeProps(:,1);
        A = storeProps(:,2);
        if P(1) < 8
            A(1) = A(1)*3;
        end
        theta = storeProps(:,3);
        
        c = Construction(A, P, theta, predLen, sigMod);
        [model, prediction, projection] = c.constructPro();
        c.plotPro(projection, sigPro);
        title('lsqBest');
        e = Evaluator(sigMod, model, prediction);
        pr2 = e.percentReturn(sigPro)
        
        display([sort(foundP'), sort(P)]);
        
    end
    
    for hide_candles = 1:1
        spPasto = sigMtx(end-predLen-10:end-predLen,1);
        spPasth = sigMtx(end-predLen-10:end-predLen,2);
        spPastl = sigMtx(end-predLen-10:end-predLen,3);
        spPastc = sigMtx(end-predLen-10:end-predLen,4);
        spPastt = length(sigPro)-(predLen)-10:length(sigPro)-predLen;
        
        spo = sigMtx(end-(predLen-1):end,1);
        sph = sigMtx(end-(predLen-1):end,2);
        spl = sigMtx(end-(predLen-1):end,3);
        spc = sigMtx(end-(predLen-1):end,4);
        spt = length(sigPro)-(predLen-1):length(sigPro);
        
        spmh = max(sigMtx(end-(predLen-1):end,2));
        spml = min(sigMtx(end-(predLen-1):end,3));
        
        speo = sigMtx(end-(predLen-1),1);
        spec = sigMtx(end,4);
        
        for cc = predLen:-1:0
            
            hold on;
            plot(sigMod,'m')
            plot(spt(1:end-cc),spo(1:end-cc),'ro')
%             pause;
            plot(sigPro(1:end-cc),'r')
            plot(spt(1:end-cc),sph(1:end-cc),'k+')
            plot(spt(1:end-cc),spl(1:end-cc),'ks')
            
            plot(spt(1:end-cc),spc(1:end-cc),'x', 'color', [0, 0.65, 0])
            plot(spt(1),speo,'ro');
            plot(spPastt,spPastc, 'x', 'color', [0, 0.65, 0], 'markers', 7)
            plot(spPastt,spPasto,'ro', 'markers', 7)
            plot(spPastt,spPasth,'k+', 'markers', 7)
            plot(spPastt,spPastl,'ks', 'markers', 7)
            
            hold off
            
            drawnow
            
        end
        
    end
    
    pause
    
    
    close all
    
    prAll = [prAll; pr2]
    


end
