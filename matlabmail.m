function recipient = matlabmail(recipient, subject, message, sender, psswd)
% MATLABMAIL Send an email from a predefined gmail account.
%
% MATLABMAIL( recipient, message, subject )
%
%   sends the character string stored in 'message' with subjectline 'subject'
%   to the address in 'recipient'.
%   This requires that the sending address is a yahoo email account.
%
% MATLABMAIL( recipient, subkect, message, sender, passwd ) 

% if nargin<4
%     sender = '';
%     psswd = '';
% end

% sendto = '@txt.att.net';
% mail = ''; %Your email address
% password = '';  %Your password

setpref('Internet','SMTP_Server','smtp.mail.yahoo.com'); %replace live with gmail for gmail mail.yahoo for yahoo
setpref('Internet','E_mail',sender);
setpref('Internet','SMTP_Username',sender);
setpref('Internet','SMTP_Password',psswd);

props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

tic;
sendmail(recipient,subject,message)
toc;
