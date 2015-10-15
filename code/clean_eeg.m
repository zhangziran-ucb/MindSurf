function [output, kept] = clean_eeg(input, threshold)

output = input-mean(input); % remove mean
step = 2; % (pts)
width = 200;

fs = 512; % sampling frequency (Hz)
L = numel(input);
x = width/2+1; % begining
kept = ones(1,L);

if threshold==0
    sigma = std(input)
    threshold = 3*sigma;
end

while x <= L
    if abs(output(x)) >= threshold
        output(x-width/2:x+width/2) = 0;
        kept(x-width/2:x+width/2) = 0;
    end
    x = x+step;
end

output = output(1:L);
kept = numel(kept(kept==1)) / L;
