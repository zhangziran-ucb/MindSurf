function list_avg = list_avg_per_channel(channel_id,list,param)
%   list_avg_per_channel gives a list of movmean for each chunk of a chosen electrod signal
%   channel_id is the column id of the EEG electrod signal wanted
%   param is the number of point processed for the moving avg

nb_chunks = size(list,2);
list_avg{nb_chunks} = [];

for i = 1:nb_chunks %loop that calculates the moving average of the
    % chunk and stores it in a new list: list_avg
    list_avg{i}(:,channel_id) = movmean(list{i}(:,channel_id),param);
end


end

