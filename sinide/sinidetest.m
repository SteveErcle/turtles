% sinidetest.m
%%%%%%%%%%%%%%
% SINIDETEST is a driver for the function sinide.m. It reads data of a 
% signal containing harmonic function and additional noise. Data are
% comming in the form of files or are generating by sinidetest itself. 
% The forms of files are:
%   *.mat   containing fs = sampling frequency and
%                       y = vector of signal values,  or
%   *.m     m-file containing data in arbitrary form, which are at last
%           formated into  fs and y.
% The second type of data is generated by sinidetest on line . The user
% answers data in responses to the distaied prompts.
%
% Required:
% ~~~~~~~~~
% sinide        www.mathworks.com/matlabcentral/fileexchange/45567 
% LMFnlsq       www.mathworks.com/matlabcentral/fileexchange/17534
% inp           www.mathworks.com/matlabcentral/fileexchange/9033
% fig           www.mathworks.com/matlabcentral/fileexchange/9035

% Miroslav Balda
% miroslav AT balda cz
% 2014-03-16    v1.0    Initial version
% 2014-09-16    v1.1    Improved version for loading arbitrary
%                       *.mat and *.m files
%%%%%%%%%%%%%

clc
close all
clear all
fontL = {'FontSize',12, 'FontWeight','bold'};
fontT = {'FontSize',14, 'FontWeight','bold'};
                
if strcmp(inp('Load file','yes'),'yes');
    file = inp('file name','y.mat');
    I = find(file=='.');
    if isempty(I)
        ext  = '.mat';
        file = [file ext];
    else
        ext  = file(I:end);     %   file name extension
    end
    if strcmp(ext,'.mat')       %   load mat file
        a = load(file);  
        names = fieldnames(a);
        fs = eval(['a.' names{1}]);
        y  = eval(['a.' names{2}]);
        if numel(eval(['a.' names{1}])) > 1
            a  = fs;
            fs = y;
            y  = a;
        end
    elseif strcmp(ext,'.m')     %   m file
        file = file(1:I-1);
        run(file);
    else                        %   text file
        load(file)
        file = file(1:I-1);
        jt = inp('column index of t',1,'%2d');
        jy = inp('column index of y',2);
        t_ = eval([file '(:,' num2str(jt) ')']);
        fs = mean(diff(t_));
        y  = eval([file '(:,' num2str(jy) ')']); 
    end
    t = (1:length(y))'/fs;      %   column vector: times of sampling
    titl = [',  file = ' file];
else
    frq = inp('Sinus frequency  [Hz]',10);
    amp = inp('Amplitude of sinus   ',2);
    phi = inp('Phase shift [radians]',3);
    ave = inp('Sinus mean value     ',5);
    fs  = inp('Sampling frequency Hz',100);
    t   = eval(inp('Sampling times    [s]','(0:fs-1)/fs'));
    ra  = inp('Noise intensity      ',.2);
    y   = amp*sin(2*pi*frq*t+phi)+ave + ra*randn(size(t));
    titl = [',  ra = ' num2str(ra)];
end

ipr= inp('Period of iteration prints',-5);   %   tested 0, -1, -5


[frq,amp,phi,ave,ssq,cnt] = sinide(y,fs,ipr);   %   Problem solution
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        with results output
if ipr
    fprintf(['\n     ssq = %12.4e\n'...
             '     cnt = %5d\n\n'...
             '     frq = %12.4e\n'...
             '     amp = %12.4e\n'...
             '     phi = %12.4e\n'...
             '     ave = %12.4e\n\n'...
             ],ssq,cnt,frq,amp,phi,ave);
end

fun = @(z) z(2)*sin(2*pi*z(1)*t+z(3))+z(4);
figure(8);
plot(t,y,'b', t,fun([frq;amp;phi;ave]),'r.','LineWidth',1.5); 
grid on;
title(['Sinus identification' titl],fontT{:});
xlabel('time  [s]',fontL{:})
ylabel('fun(t)  [-]',fontL{:})
