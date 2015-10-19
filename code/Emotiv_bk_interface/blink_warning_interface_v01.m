function varargout = blink_warning_interface_v01(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @blink_warning_interface_v01_OpeningFcn, ...
                   'gui_OutputFcn',  @blink_warning_interface_v01_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before blink_warning_interface_v01 is made visible.
function blink_warning_interface_v01_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for blink_warning_interface_v01
handles.output = hObject;

clc
% init data
handles.bk = 0;
handles.ref = 0.2;
handles.nb_seg = 0;
set(handles.warning,'visible','off')
% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = blink_warning_interface_v01_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% --- Executes on button press in cb_run.
function cb_run_Callback(hObject, eventdata, handles)

pause off
%==================%
% LOOK FOR LAST FILE
%==================%

idx = 0;
%root = '..\..\data\emokit' % root AD
%root = '/Users/GG/MindSurf/data/emokit'; % root GG
root = '/Users/GG/Documents/Documents/Etudes/ESPCI_Paristech/4A/ITE_Berkeley/Emotiv/RT_test'; % temp root for test
cd(root)

nb_seg = handles.nb_seg;
warning = 0;
seg_time = 5; % duration of each segment (s)
fs = 128;

% check run status
while get(hObject,'Value')

%disp(['> Looking at file ' num2str(idx)])
current_file = sprintf('test%d.txt',idx);

confirm = 0;
while confirm==0
    % check run status
    drawnow
    if ~get(hObject,'Value'), break; disp('> Stop'); end
    % check file status
    if exist(current_file,'file')==2 % check file existence
        file = fopen(current_file,'r');
        disp(['> File ' current_file ' existing'])
        data = textscan(file,'%q %q %d %d %d %d %d %d %d %d %d %d %d %d %d %d','HeaderLines',1,'Delimiter',' ');
        %data = textscan(file,'%d %d %d %d','HeaderLines',1,'Delimiter','\t');
        if numel(data{1}) == seg_time*fs
            disp(['> File ' current_file ' complete'])
            confirm = 1;
            nb_seg = nb_seg+1;
        end
    else
        disp(['> File ' current_file ' not existing'])
    end
    uiwait(gcf,1)
end

%try
%===========%
% DEFINE DATA
%===========%

% define time
fs = 128; % sampling frequency
% load channels
C = cell(1,numel(data)-2);
for i=3:numel(data) % without gyro
    %C{i} = C{i}(end-fs*1:end); % keep only last second
    C{i-2} = data{i};
    disp(['  > Channel ' num2str(i-2) ' saved'])
    %C{i-2} = C{i-2} - mean(C{i-2}); % remove offset
end
time = 0:1/fs:(length(C{1})-1)*1/fs; % time array

%================%
% DETECT BLINKINGS
%================%

% define signal
S = double(C{3}+C{12}+C{1}+C{14}-C{7}-C{8});
% filter filter
[b,a] = butter(4,0.03,'high');
Shigh = filter(b,a,S);
S = S - Shigh;
S = S - median(S);

% find local maxs => artifacts
threshold = 150;
h_min = 100;
min_dist = 0; % in nb of pts
subplot(1,3,2), findpeaks(S,'MinPeakProminence',threshold,'MinPeakHeight',h_min','MinPeakDistance',min_dist,'Annotate','extents') % display local max
xlabel('time []'),ylabel('Amplitude [uV]'), title('Blinkings identification')
[peaks,locs,w,p] = findpeaks(S,'MinPeakProminence',threshold,'MinPeakHeight',h_min','MinPeakDistance',min_dist);
w = w/fs;

handles.bk = handles.bk + numel(w); % add number of peaks found

%=========================%
% CONCLUDE ON BLINKING RATE
%=========================%

ref = handles.ref; % average number of bk /sec
disp(['> Ref is ' num2str(ref) ' bk/sec'])
temp = numel(w)/seg_time; % number of bk /sec in the last segment
disp(['> Temp is ' num2str(temp) ' bk/sec'])
% compare
if temp > 2*ref, warning = 1; else warning = 0; end
% update ref
X = [ref*ones(1,nb_seg) temp]; ref = mean(X); 
handles.ref = ref;
disp(['> New ref is ' num2str(ref) ' bk/sec'])

%=============%
% STORE RESULTS
%=============%

% create txt files
%temp = fopen('temp.txt','w');
%total = fopen('total.txt','w');

% file txt files
%fprintf(temp,'%d\n',cha(k));
%fprintf(temp,'%d\n',cha(k));

% close txt files
%fclose(temp);
%fclose(total);


%=================%
% ADAPT INTERFACE
%=================%

% define audio
WarnWave = [sin(1:.6:400), sin(1:.7:400), sin(1:.4:400)];
Audio = audioplayer(WarnWave, 22050);

% plot ref
subplot(1,3,3), plot(idx,temp,'rd'), hold on, plot(idx,ref,'bx'), plot(idx,2*ref,'k-')
xlim([0 idx+1]), title('Temp bk rate /sec'), xlabel('Nb of segments'), ylabel('bk/sec')
% display "warning"
if warning==1 
    set(handles.warning,'visible','on')
    play(Audio);
else
    set(handles.warning,'visible','off')
end
% iterate the bk number on the interface
set(handles.blinks,'string',num2str(handles.bk))

% global data
guidata(hObject,handles)

idx = idx+1;
%catch
%end % end try
drawnow
end % end while 
