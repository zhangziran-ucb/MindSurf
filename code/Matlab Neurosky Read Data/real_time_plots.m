function real_time_plots
%run this function to connect and plot raw EEG data
%choose which waves and mindwave params to show
%make sure to change portnum1 to the appropriate COM port
%based on readRAW.m

clear all
close all

test_time = 5; %predicted time in minutes of test. overestimate
%preallocate storage for all samples in a structure
[data.att,...
    data.med,...
    data.raw,...
    data.delta,...
    data.theta,...
    data.alpha1,...
    data.alpha2,...
    data.beta1,...
    data.beta2,...
    data.gamma1,...
    data.gamma2,...
    data.blink] = zeros(1,512*60*test_time);

portnum1 = 4;   %COM Port #
comPortName1 = sprintf('\\\\.\\COM%d', portnum1);


% Baud rate for use with TG_Connect() and TG_SetBaudrate().
TG_BAUD_57600 =      57600;


% Data format for use with TG_Connect() and TG_SetDataFormat().
TG_STREAM_PACKETS =     0;


% Data type that can be requested from TG_GetValue().
TG_DATA_RAW =         4;

%load thinkgear dll
loadlibrary('Thinkgear.dll');
fprintf('Thinkgear.dll loaded\n');

%get dll version
dllVersion = calllib('Thinkgear', 'TG_GetDriverVersion');
fprintf('ThinkGear DLL version: %d\n', dllVersion );


%%
% Get a connection ID handle to ThinkGear
connectionId1 = calllib('Thinkgear', 'TG_GetNewConnectionId');
if ( connectionId1 < 0 )
    error( sprintf( 'ERROR: TG_GetNewConnectionId() returned %d.\n', connectionId1 ) );
end;

% Set/open stream (raw bytes) log file for connection
errCode = calllib('Thinkgear', 'TG_SetStreamLog', connectionId1, 'streamLog.txt' );
if( errCode < 0 )
    error( sprintf( 'ERROR: TG_SetStreamLog() returned %d.\n', errCode ) );
end;

% Set/open data (ThinkGear values) log file for connection
errCode = calllib('Thinkgear', 'TG_SetDataLog', connectionId1, 'dataLog.txt' );
if( errCode < 0 )
    error( sprintf( 'ERROR: TG_SetDataLog() returned %d.\n', errCode ) );
end;

% Attempt to connect the connection ID handle to serial port "COM3"
errCode = calllib('Thinkgear', 'TG_Connect',  connectionId1,comPortName1,TG_BAUD_57600,TG_STREAM_PACKETS );
if ( errCode < 0 )
    error( sprintf( 'ERROR: TG_Connect() returned %d.\n', errCode ) );
end

fprintf( 'Connected.  Reading Packets...\n' );




%%
%record data

j = -255; %keeps track of every half second (256 samples), don't plot first half second
i = 0; %keeps track of full length of test
k = 0; %keeps track of current plot indices
while (i < 512*60*test_time)   %stop when record is full
    if (calllib('Thinkgear','TG_ReadPackets',connectionId1,1) == 1)   %if a packet was read...
        
        if (calllib('Thinkgear','TG_GetValueStatus',connectionId1,TG_DATA_RAW) ~= 0)   %if RAW has been updated 
            j = j + 1;
            i = i + 1;
            data.att(i) = calllib('Thinkgear','TG_GetValue',connectionId1,TG_DATA_ATTENTION); % attention data
            data.med(i) = calllib('Thinkgear','TG_GetValue',connectionId1,TG_DATA_MEDITATION); % meditation data
            data.raw(i) = calllib('Thinkgear','TG_GetValue',connectionId1,TG_DATA_RAW); % raw data
            data.delta(i) = calllib('Thinkgear','TG_GetValue',connectionId1,TG_DATA_DELTA); % delta data
            data.theta(i) = calllib('Thinkgear','TG_GetValue',connectionId1,TG_DATA_THETA); % theta data
            data.alpha1(i) = calllib('Thinkgear','TG_GetValue',connectionId1,TG_DATA_ALPHA1); % alpha1 data
            data.alpha2(i) = calllib('Thinkgear','TG_GetValue',connectionId1,TG_DATA_ALPHA2); % alpha2 data
            data.beta1(i) = calllib('Thinkgear','TG_GetValue',connectionId1,TG_DATA_BETA1); % beta1 data
            data.beta2(i) = calllib('Thinkgear','TG_GetValue',connectionId1,TG_DATA_BETA2); % beta2 data
            data.gamma1(i) = calllib('Thinkgear','TG_GetValue',connectionId1,TG_DATA_GAMMA1); % gamma1 data
            data.gamma2(i) = calllib('Thinkgear','TG_GetValue',connectionId1,TG_DATA_GAMMA2); % gamma2 data
            data.blink(i) = calllib('Thinkgear','TG_GetValue',connectionId1,TG_DATA_BLINK_STRENGTH); % blink strength data
        end
    end
     
    if (j == 256)
        %figure out indices to plot using k
        %plot the data from the past second, update every .5 seconds (512 points)
        inds = k:k+511;
        plotAttMed(data.att(inds), data.med(inds)); 
        k = k + 256;
        j = 0;
    end
    
end





%disconnect             
calllib('Thinkgear', 'TG_FreeConnection', connectionId1 );





