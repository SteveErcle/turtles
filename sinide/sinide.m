function [frq,amp,phi,ave,ssq,cnt] = sinide(y,fs,ipr,varargin)
%   Amplitude, frequency, phase and mean value of sampled sine wave
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The function sinide.m evaluates frequency, amplitude, phase and mean
% value of a uniformly sampled harmonic signal. The function replaces 
% the function sinfapm: www.mathworks.com/matlabcentral/fileexchange/19902
% and solves the unknown parameters of the sampled function
%       y(t) = amp.sin(2.pi.frq.t + phi) + ave
% The parameters to be determined, are found in the least squares sense by
% the function LMFnlsq & extr that can be found at:
%
%       www.mathworks.com/matlabcentral/fileexchange/17534
%       www.mathworks.com/matlabcentral/fileexchange/10272
%
% The user does not need to supply his initial guess of parameter values.
%
% Calls:
%   sinide                            %  Display this help
%   frq = sinide(y,fs);               %  Get frequency of sine-wave [Hz]
%   [frq,amp] = sinide(y,fs);         %  Get frequency and amplitude
%   [frq,amp,phi] = sinide(y,fs,ipr); %  Get frequency, amplitude and phase
%   [frq,amp,phi,ave] = sinide(y,fs); %  ditto plus mean value
%   
% Input arguments:
%   y           vector of function samples
%   fs          sampling frequency [Hz]
%   ipr         iteration period for output of intermediate results
%               0  = no display,  n = complete display after n-th iteration
%               -n = display without lambdas (see help LMFnlsq)
%   varargin    possible pairs of names and values of options for the
%               function LMFnlsq. See its description (help).
%
% Output arguments:
%   frq     frequency of y [Hz]
%   amp     amplitude of y
%   phi     phase in radians
%   ave     mean offset
%   ssq     sum of squares of residuals
%   cnt     number od goal function evaluations.
%
% Example 1 (by Will Wehner):   t  = (0:0.01:1);
%                               y1 = 2*sin(2*pi*10*t + 3) + 5
%                               fs = 100 [Hz] 
%   The call
%           [frq,amp,phi,ave,ssq,cnt] = sinide(y1,fs,-5);
%
%   displays initial and each n-th iteration current ssq, sought parameters 
%   parameter increments and the final (exact) solution:
%
%       ssq = 2.1794e-027
%       cnt = 6
%
%       frq = 10.0000
%       amp = 2.0000
%       phi = 3.0000
%       ave = 5.0000
%
% Example 2: As Example 1, where  y = y1 + ra*randn(size(t)).
%   It is obvious that the additional noise was stronger than the useful
%   signal. The obtained solution with ra=2 was the following:
%
%       ssq = 3,8486e+002
%       cnt = 6
%
%       frq = 9.9533
%       amp = 2.0021
%       phi = 3.2235
%       ave = 5.0608
%
%   Results for repeated run with the same data will differ if  ra~=0.
%   Both examples are used from a run of the test program Wehner.m that is
%   included in the set with the function sinide.m. The figures of the
%   given functions (blue) and obtained solutions are in the header of this 
%   function description. The final solutions are drawn as red asterisks.

%   Miroslav Balda
%   balda at cdm dot cas dot cz
%   1998-10-26 - v 1.0  As sinfapm.m
%   2008-05-05 - v 1.1  Complemented evaluation of phase and mean value
%   2014-02-12 - v 2.0  as sinide.m with completely new algorithm
%   2014-03-17 - v 3.0  Completely rebuilt for solving both standard
%                       tasks and fatal noisy tasks.
%   2014-09-24 - v 3.1  Improved input of data from files *.mat and *.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin==0 && nargout==0, help sinide, return, end
if nargin<2, error('Number of input arguments should be >= 2'), end
if nargin<3, ipr=0; end

p    = zeros(4,1);
y    = y(:);                          %   Make y the column vector
N    = length(y);                     %   Length of time series y
arg  = (1:N)';
p(4) = mean(y);                       %   guess of mean value
x = y-p(4);                           %   centered signal
X = abs(fft(x.*(1.173913-cos((arg-1)*(2*pi)/N))*.46)); % DFT of hamminged x
[Xm,K] = max(abs(X));
K = min([K,length(x)-K]);
if K<50 && Xm/mean(X(50:end-50))>100    %     FATAL CASE  
    [yhi,Khi] = max(x.*((N:-1:1)'/fs));     %   first peak
    [ylo,Klo] = min(x.*((N:-1:1)'/fs));     %   first valey
    dK  = Khi-Klo;
    p(1) = fs/(2*abs(dK));                  %   guess of frequency [Hz]
    p(3) = (2-(Khi+Klo)/(2*dK))*pi;         %   guess of phi
    p(2) = (yhi-ylo)/2;                     %   guess of amplitude
else                                    %     NORMAL CASE
%       extr:       www.mathworks.com/matlabcentral/fileexchange/10272
    L = extr(x);
    L{1}(1) = false;   L{2}(1) = false;
    L{1}(end) = false; L{2}(end) = false;
    iper = (arg(K)-1);                      %   period guess
    imx  = arg(L{1});                       %   peaks
    imn  = arg(L{2});                       %   valeys
    p(3) = 2*pi*imx(1)/iper - pi/2;         %   guess of phi
    p(2) = (mean(x(imx))-mean(x(imn)))/2;   %   guess of amplitude
    p(1) = fs*iper/(N-1);                   %   guess of frequency [Hz]
end
if ipr
    fprintf([char('*'*ones(1,50)) '\n']);
    fprintf('      p0  =');
    fprintf('\n         %13.4e',p);
    fprintf('\n\n');
end
res  = @(z) z(2)*sin(2*pi*z(1)*(arg-1)/fs + z(3)) + z(4) - y; 
%       LMFnlsq:    www.mathworks.com/matlabcentral/fileexchange/17534
[q,ssq,cnt] = LMFnlsq(res,p,'Display',ipr);
if (q == 1 & ssq == 1 & cnt == 1)
    frq = 1;
    amp = 1;
    phi = 1;
    ave = 1;
    return;
end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if q(2)<0
    q(2) = -q(2);
    q(3) = q(3)+pi;
end
frq = q(1);
amp = q(2);
phi = rem(q(3),2*pi); 
ave = q(4);
