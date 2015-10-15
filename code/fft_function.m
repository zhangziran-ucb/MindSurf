function [freq,amp,phaz] = BM_fft(input, SR)

h = fft(input);
%figure, plot(h)
m = abs(h) * 2 / length(h); % Normalize: unit sinusoid in time ==> unit ampl.
% p = 180/pi*angle(h); % angle() doesn't work well with ratios of small numbers
%figure, plot(m)
hr = real(h); % real part
hi = imag(h); % imaginary part
		% hr(abs(hr) < arctan_tol) = zeros(length(hr(abs(hr) < arctan_tol)),1);
		% hi(abs(hi) < arctan_tol) = zeros(length(hi(abs(hi) < arctan_tol)),1);
p = 180/pi*atan2(hi,hr);
%figure, plot(p)
f = (0:length(h)-1)'/length(h) * SR;

amp = m(1:length(m)/2);   % Only look at frequencies: (0 --> folding frequency)
freq = f(1:length(f)/2);
phaz = p(1:length(p)/2);
