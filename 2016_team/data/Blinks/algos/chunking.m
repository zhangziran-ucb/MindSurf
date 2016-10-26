function [list, meta_data] = chunking(size_chunk, string, channels_list )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% columns corresponds to the i-th electrod,  1st column is the time,
% channel 4 is good for blinks, the string should a .csv file title like
% 'Robin-2.csv' 

meta_data = csvread(string);
meta_data = meta_data(:,channels_list);

nb_chunks = floor(size(meta_data,1)/size_chunk); 
list{nb_chunks} = [];
meta_data(:,1) = [1:size(meta_data,1)]';

for i = 1:nb_chunks % loop that divides the .csv in chunks
    list{i}= meta_data((i-1)*size_chunk+1:size_chunk*(i),:); 
end  

end

