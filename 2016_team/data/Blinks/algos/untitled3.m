%% Initialization
clear ; close all; clc

%% Load Data
channels_list = [1 3:5 9 14:15];
[list,meta_data] = chunking(256, 'Robin-2.csv', channels_list);
nb_channels = size(meta_data,2);
time = meta_data(:,1);

%% Moving average 
channel_id = 4;
param = 10;
list_avg = list_avg_per_channel(channel_id, param);

%% divide the signal into chunks

chunking(256,'Robin-2.csv');



figure
subplot(3,2,1)
plot(time, list_avg{1}(:,2));
findpeaks(list_avg{1}(:,2),'MinPeakHeight',4300)

subplot(3,2,2)

plot(time, list_avg{1}(:,3));
findpeaks(list_avg{1}(:,3),'MinPeakHeight',4500)

subplot(3,2,3)
plot(time, list_avg{1}(:,4));
findpeaks(list_avg{1}(:,4),'MinPeakHeight',4250)

subplot(3,2,4)
plot(time, list_avg{1}(:,5));
findpeaks(list_avg{1}(:,5),'MinPeakHeight',4200)

subplot(3,2,5)
plot(time, list_avg{1}(:,6));
findpeaks(list_avg{1}(:,6),'MinPeakHeight',4250)
xlabel('chunk time'); ylabel('amplitude');

subplot(3,2,6)
plot(time, list_avg{1}(:,7));
findpeaks(list_avg{1}(:,7),'MinPeakHeight',4200)
xlabel('chunk time'); ylabel('amplitude');

% figure
% subplot(3,2,1)
% plot(time, list_avg{1}(:,8));
% findpeaks(-list_avg{1}(:,8),'MinPeakHeight',4200)
% xlabel('chunk time'); ylabel('amplitude');
% 
% subplot(3,2,2)
% plot(time, list_avg{1}(:,9));
% findpeaks(-list_avg{1}(:,9),'MinPeakHeight',4200)
% xlabel('chunk time'); ylabel('amplitude');
% 
% subplot(3,2,3)
% plot(time, list_avg{1}(:,10));
% findpeaks(-list_avg{1}(:,10),'MinPeakHeight',4200)
% xlabel('chunk time'); ylabel('amplitude');
% 
% subplot(3,2,4)
% plot(time, list_avg{1}(:,11));
% findpeaks(-list_avg{1}(:,11),'MinPeakHeight',4200)
% xlabel('chunk time'); ylabel('amplitude');
% 
% subplot(3,2,5)
% plot(time, list_avg{1}(:,12));
% findpeaks(-list_avg{1}(:,12),'MinPeakHeight',4200)
% xlabel('chunk time'); ylabel('amplitude');
% 
% subplot(3,2,6)
% plot(time, list_avg{1}(:,13));
% findpeaks(-list_avg{1}(:,13),'MinPeakHeight',4200)
% xlabel('chunk time'); ylabel('amplitude');
% 
% figure
% subplot(3,2,1)
% plot(time, list_avg{1}(:,14));
% findpeaks(-list_avg{1}(:,14),'MinPeakHeight',4200)
% xlabel('chunk time'); ylabel('amplitude');
% 
% subplot(3,2,2)
% plot(time, list_avg{1}(:,15));
% findpeaks(-list_avg{1}(:,15),'MinPeakHeight',4200)
% xlabel('chunk time'); ylabel('amplitude');



%legend('Plot of the moving mean of each chunk');


%% boucle decoupage des blinks, renvoie un 1 si un blink a été trouvé dans le chunk

% a blink is defined as an important variance in the data
mean_list{nb_chunks} = [];
var_list{nb_chunks} = [];
blink{nb_chunks} = [];
for i = 1:nb_chunks
    mean_list{i} = mean(list{i});
    var_list{i} = var(list{i}); 
    blink{i} = var_list{i} < 1000; %renvoie un vecteur de taille (1XNb_channels) avec des 1 et 0
end

max = 0;

% for i =1:nb_chunks
%     
%     max = max(sum(blink{i}),max);
%     
% end

%max;
