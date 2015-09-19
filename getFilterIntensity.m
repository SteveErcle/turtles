getFilterIntensity

% FindFiltIntensity = Evaluator(1,1,evalBF.model_predict);
% 
% [tag1] = FindFiltIntensity.peakAndTrough(FindFiltIntensity.model_predict);
% target_num_of_extrema = length(tag1)
% 
% signal = SigObj.getSignal();
% signalHighPass = getFiltered(signal, filt, 'high');
% sigHigh = signalHighPass(day : day  + modLen+predLen)+15;
% 
% 
% for filt_intensity = 0.075: 0.001:0.175
%     sigHighLow = getFiltered(sigHigh, filt_intensity, 'low');
%     [tag1, max1, min1] = FindFiltIntensity.peakAndTrough(sigHighLow);
%     if abs(length(tag1) - target_num_of_extrema) <= 1
%         found_filt_intensity = filt_intensity;
%         break
%     end
% end
% 
% found_filt_intensity