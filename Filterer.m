
function [signalFilt] = Filterer(signal)

deg_filt = 5;               % Enter order of filterg
norm_freqz = 0.2;           % Enter strength of filter

[b a] = butter(deg_filt,norm_freqz, 'low');
signalFilt = filtfilt(b,a,signal);

end