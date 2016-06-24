clc; close all; clear all;

ib = ibtws('',7497);

pause(1)

ibContract = ib.Handle.createContract;


% ibContract.symbol = 'EUR';
% ibContract.secType = 'CASH';
% ibContract.exchange = 'IDEALPRO';
% ibContract.currency = 'GBP';

ibContract.symbol = 'TSLA';
ibContract.secType = 'STK';
ibContract.exchange = 'SMART';
ibContract.primaryExchange = 'NASDAQ';
ibContract.currency = 'USD';


% f = '233';

d = getdata(ib,ibContract)
    
% tickerid = realtime(ib,ibContract,f)
% 
% pause(1)
% 
% 
% ibBuiltInRealtimeData


% startdate = now-20;
% enddate = now;
% barsize = '20 mins';
% tickType = '';
% 
% 
% d = timeseries(ib,ibContract,startdate,enddate,barsize,tickType,true)