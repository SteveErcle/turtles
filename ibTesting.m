clc; close all; clear all;

ib = ibtws('',7497);

tc = TurtleCall;

f = findobj('Tag','IBStreamingDataWorkflow');
if isempty(f)
    f = figure('Tag','IBStreamingDataWorkflow','MenuBar','none',...
        'NumberTitle','off')
    pos = f.Position;
    f.Position = [pos(1) pos(2) pos(3)+370 1090];
    colnames = {'Trade','Size','Bid','BidSize','Ask','AskSize',...
        'Total Volume'};
    rownames = {'AAA','BBB','DDDD'};
    data = cell(3,6);
    streamer = uitable(f,'Data',data,'RowName',rownames,'ColumnName',colnames,...
        'Position',[10 30 800 760],'Tag','SecurityDataTable')
    uicontrol('Style','text','Position',[10 5 497 20],'Tag','IBMessage')
    uicontrol('Style','pushbutton','String','Close',...
        'Callback',...
        'evalin(''base'',''close(ib);close(findobj(''''Tag'''',''''IBStreamingDataWorkflow''''));'')',...
        'Position',[512 5 80 20])
end


ibContract1 = ib.Handle.createContract;
ibContract1.symbol = 'TSLA';
ibContract1.secType = 'STK';
ibContract1.exchange = 'SMART';
ibContract1.primaryExchange = 'NASDAQ';
ibContract1.currency = 'USD';


ibContract2 = ib.Handle.createContract;
ibContract2.symbol = 'MSFT';
ibContract2.secType = 'STK';
ibContract2.exchange = 'SMART';
ibContract2.primaryExchange = 'NASDAQ';
ibContract2.currency = 'USD';

ibContract3 = ib.Handle.createContract;
ibContract3.symbol = 'FB';
ibContract3.secType = 'STK';
ibContract3.exchange = 'SMART';
ibContract3.primaryExchange = 'NASDAQ';
ibContract3.currency = 'USD';


contracts = {ibContract1;ibContract2;ibContract3};
f = '100';

tickerID = realtime(ib,contracts,f,...
                    @(varargin)tc.ibStreamer(varargin{:}));

% close(ib)




return


% pause(1)
%
% ibContract = ib.Handle.createContract;


% ibContract.symbol = 'EUR';
% ibContract.secType = 'CASH';
% ibContract.exchange = 'IDEALPRO';
% ibContract.currency = 'GBP';

% ibContract.symbol = 'TSLA';
% ibContract.secType = 'STK';
% ibContract.exchange = 'SMART';
% ibContract.primaryExchange = 'NASDAQ';
% ibContract.currency = 'USD';


% f = '233';
%
% d = getdata(ib,ibContract)
%
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

% close(ib)