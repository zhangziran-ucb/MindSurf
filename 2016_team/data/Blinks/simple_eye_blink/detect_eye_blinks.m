
%import eeg recordings
data = importdata('Yaoyang-1st-27.09.16.02.17.08.csv');

for i=1:size(data,2)-1
    data(:,i) = -(mean(data(:,i))-data(:,i))/(max(data(:,i)-min(data(:,i))));
end
%figure
%plot(data(:,15),data(:,14));

% create a figure to show the results
figure('color','w');
hold on;

% sampling frequency
fs = 128;

% define the eye blink length (approx 450ms)
eye_blink_length = 0.45*fs;

% define the frame dimensions
frame_size = 110;
% determine the number of frames in the recording
nb_frames = floor(size(data,1)/frame_size);

% flags to track eye blinks across frames
this_frame_is_a_blink = 0;
next_frame_is_a_blink = 0;

% go through all frames
for i=1:nb_frames
    
    % define start-end points of the frame
    frame_start = (i-1)*frame_size+1;
    frame_end = i*frame_size;
    
    % update eye blink tracking flags
    this_frame_is_a_blink = next_frame_is_a_blink;
    next_frame_is_a_blink = 0;
    
    % channel 2 - processing
    % *remove mean
    temp_data_1 = data(frame_start:frame_end,2)-mean(data(frame_start:frame_end,2));
    nb_eye_blink_samples = sum(temp_data_1(:) <= -0.1);
    
    % find where the eye blink "start"
    idx_1 = find(temp_data_1 <= -0.1);
    if(~isempty(idx_1))
        idx_1 = idx_1(1);
    end
    
    % channel 1 - processing
    % *remove mean
    temp_data_2 = data(frame_start:frame_end,2)-mean(data(frame_start:frame_end,2));
    nb_eye_blink_samples = nb_eye_blink_samples+sum(temp_data_2(:) <= -75);
    
    % find where the eye blink "start"
    idx_2 = find(temp_data_2 <= -75);
    if(~isempty(idx_2))
        idx_2 = idx_2(1);
    end
    
    % define the full range of the frame
    range = frame_start:frame_end;
    
    
    % apply the blink detection condition
    if(nb_eye_blink_samples>2 || this_frame_is_a_blink)
        
        % if eye-blink detected draw the frame in red
        plot(frame_start:frame_end,data(frame_start:frame_end,2)+2-mean(data(:,2)),'r');
        plot(frame_start:frame_end,data(frame_start:frame_end,2)-mean(data(:,2)),'r');
        
        % draw a line where the eye blink starts
        if(~isempty(idx_1))
            line([range(idx_1) range(idx_1)], [350 450],'linewidth',2,'color','g');
        end
        
        if(~isempty(idx_2))
            line([range(idx_2) range(idx_2)], [-50 50],'linewidth',2,'color','g');
        end
    else
        % if no eye-blink draw in blue
        plot(frame_start:frame_end,data(frame_start:frame_end,2)+2-mean(data(:,2)),'b');
        plot(frame_start:frame_end,data(frame_start:frame_end,2)-mean(data(:,2)),'b');
    end
    
    % check if the eye-blink span to the next frame
    if(nb_eye_blink_samples>2)
        if(frame_size - min(idx_1,idx_2) < eye_blink_length)
            next_frame_is_a_blink = 1;
        end
    end
    
end
