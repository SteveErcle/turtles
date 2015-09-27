
function plotPlay(obj, projection, sigPlt, ticker)

%% Plots the model and the prediction against the stock;


sigMod  = obj.sigMod;

% obj.plotPro(projection, sigPlt(1:length(sigMod)));
%
% pause;
%
% obj.plotPro(projection, sigPlt);



predLen = obj.predLen;

t = 1:length(projection);

model = projection(1:end-predLen);
prediction = projection(end-predLen:end);


figure()
for i = 1:2
    
    if i == 1
        sigPlay = sigPlt(1:length(sigMod));
    else
        sigPlay = sigPlt(1:length(sigMod)+ticker);
    end 
        
        tsg = 1:length(sigPlay);
        plot(tsg, sigPlay, 'r')
        
        hold on;
        plot(t(1:end-predLen), model, 'k')
        hold on;
        plot(t(end-predLen:end), prediction, 'b')
        
%         axis([ 500 length(sigPlt) min(sigPlay(end-300:end)) max(sigPlay(end-300:end)) ]);
        
        pause;
        
end


end
