close all
clear all
clc

mail = 'eadawadallah@hotmail.com'; %Your GMail email address
password = 'putpasswordhere';  %Your GMail password
setpref('Internet','SMTP_Server','smtp.live.com'); %replace live with gmail for gmail mail.yahoo for yahoo
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');
% Send the email.  Note that the first input is the address you are sending the email to
sendmail(mail,'Test from MATLAB','Hello! This is a test from MATLAB!')