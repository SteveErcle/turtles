
function plotPlay(obj, projection, sigPlt)


sigMod  = obj.sigMod;

predLen = obj.predLen;

t = 1:length(projection);

model = projection(1:end-predLen);
prediction = projection(end-predLen:end);

figure()

plot(t(1:end-predLen), model, 'k')
hold on;
plot(t(end-predLen:end), prediction, 'b')

tsg = 1:length(sigMod);
sigPlay = sigPlt(1:length(sigMod));
plot(tsg, sigPlay, 'r')


ticker = 1;
tickerTotal = 0;
while ticker ~= 0
   
    
    
    ticker = input('How many days do you want to move? ')
    tickerTotal = tickerTotal + ticker;
    sigPlay = sigPlt(1:length(sigMod)+tickerTotal);
    
    tsg = 1:length(sigPlay);
    plot(tsg, sigPlay, 'r')
    
  
end


end
