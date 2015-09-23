
function [signalFilt] = getFiltered(signal, filter_intensity, type_string)

%% Filters signal using low pass filter
% norm_freqz of 0 to 1. The lower the norm_freqz the more intense the
% filtering


deg_filt = 5;                   % Enter order of filter
norm_freqz = filter_intensity;  % Enter strength of filter

[b a] = butter(deg_filt,norm_freqz, type_string);
signalFilt = filtfilt(b,a,signal);

end