function PowerSpectrum( hax, rawData, Fs )
%POWERSPECTRUM Plots power vs frequency for raw signal data
%   Obtain the periodogram using fft. The signal is real-valued and has
%       even length. Because the signal is real-valued, you only need power
%       estimates for the positive or negative frequencies. In order to
%       conserve the total power, multiply all frequencies that occur in
%       both sets -- the positive and negative frequencies -- by a factor
%       of 2. Zero frequency (DC) and the Nyquist frequency do not occur
%       twice. Plot the result.
N = length(rawData);
xdft = fft(rawData);
xdft = xdft(1:N/2+1);
psdx = (1./(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(rawData):Fs/2;

plot(hax,freq,10*log10(psdx))
title(sprintf('Periodogram over last %d seconds', N/512)) 
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')

end

