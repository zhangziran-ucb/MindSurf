function [ alpha, beta, gamma, delta, theta ] = deconstructRAW( raw_signal )
%DECONSTRUCTRAW Split a raw data signal into five brain waves
%   Splits the signal by frequency components. 512 samples are processed
%   with fft, separated into five brain wave bands, and run through ifft.
%   raw_signal is an array of raw values
%   Brainwave frequency bands are as follows:
%   Wave name | Frequency | Typical amplitude (uV)
%   Delta     | 0.1 - 4   | 100 - 200
%   Theta     | 4 - 8     | higher than 30
%   Alpha     | 8 - 13    | 30 - 50 or higher
%   Beta      | 13 - 30   | 2 - 20 or higher
%   Gamma     | 40 - 80   | 3 - 5 or higher

% As another example, to convert TGAT-based EEG sensor values (such as TGAT, TGAM, MindWave, MindWave Mobile) to voltage values, use the following conversion:
% (rawValue * (1.8/4096)) / 2000

% pad signal if necessary and compute fft
N = power(2, nextpow2(length(raw_signal)));
full_freq = fft(raw_signal, N);

% isolate brainwave frequencies
delta_freq = full_freq;
delta_freq(delta_freq < 0.1) = 0;
delta_freq(delta_freq > 4) = 0;

theta_freq = full_freq;
theta_freq(theta_freq < 4) = 0;
theta_freq(theta_freq > 8) = 0;

alpha_freq = full_freq;
alpha_freq(alpha_freq < 8) = 0;
alpha_freq(alpha_freq > 13) = 0;

beta_freq = full_freq;
beta_freq(beta_freq < 13) = 0;
beta_freq(beta_freq > 30) = 0;

gamma_freq = full_freq;
gamma_freq(gamma_freq < 40) = 0;
gamma_freq(gamma_freq > 80) = 0;

% invert ffts
delta = ifft(delta_freq);
theta = ifft(theta_freq);
alpha = ifft(alpha_freq);
beta = ifft(beta_freq);
gamma = ifft(gamma_freq);
end

