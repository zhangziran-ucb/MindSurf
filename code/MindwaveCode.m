% This is the code to do fourier transform similar to the Salabun paper

X = [] % amplitude and phase of a sinusoidal component of xn
n = []
x = [] % signal
k = []
N = [] % size of transform
k = []
data = []
f = []

% O(N^2) %DFT
% N(logN) %FFT
% N = 2^k

% % FAST FOURIER TRANSFORM (FFT)
% def function fft(data,N):
% 
% % INVERSE FAST FOURIER TRANSFORM (IFFT)
% def function ifft(data,N): 

% if N < length (data)
%     % sequence x is truncated
% else if N > length(data)
%     % x is padded with zero to length N
        
%DISCRETE FOURIER TRANSFORM (DFT)
for k = 0:10
    for n = 0:10
        X(k) = X(k)+x(n)*e^-(f*2*pi&k*n)/N
    end
end

%INVERSE DISCRETE FOURIER TRANSFORM (IDFT)

for n = 0:10
    for k = 0:10
        x(n) = 1/N * (x(n)+X(k)*e^(f*2*pi*k*n)/N
    end
end

