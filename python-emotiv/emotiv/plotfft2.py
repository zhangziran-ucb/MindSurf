# http://www.astropy.org/astropy-tutorials/plot-catalog.html

from matplotlib.dates import datestr2num, DateFormatter
import pylab
import numpy as np
import matplotlib.pyplot as plt
from scipy.fftpack import rfft, irfft, fftfreq

# https://stackoverflow.com/questions/1574088/plotting-time-in-python-with-matplotlib

filename = '201510131721.txt'
# list_of_files = [ (filename, 'label 1')]

# datalist = [ ( pylab.loadtxt(filename, converters={0:strpdate2num('%H:%M:%S.%f')}), label ) for filename, label in list_of_files ]
# numpy.loadtxt(filename, converters={0:strpdate2num('%H:%M:%S.%f')

datalist = pylab.loadtxt(filename, converters={0:datestr2num})

t = datalist[:, 0]
y = datalist[:, 5]
len_data = len(datalist)

ti = np.linspace(t[0], t[-1], len_data)
yi = np.interp(ti, t, y)
t, y = ti, yi

plt.figure(figsize=(10, 10))
plt.subplot(511)
plt.plot_date(t, y, 'b-')
plt.xlabel("time[sec]")
plt.ylabel("original signal")
plt.subplot(512)
F = np.fft.fft(y)
N = len(t)
w = np.fft.fftfreq(N, (t[1] - t[0]))
ipos = np.where(w > 0)
freq = w[ipos]
mags = abs(F[ipos])
plt.plot(freq, mags)
ip = np.where(F > 0)[0]
Fs = np.copy(F)
yf = np.fft.ifft(Fs)
ip = np.where(F > 0)[0]
Ff = np.copy(F)
Ff[ip > ip[[(181)]]] = 0
Ff[ip < ip[[(175)]]] = 0
magsf = abs(Ff[ipos])
plt.plot(freq, magsf, 'r-')
plt.subplot(513)
Fr = mags - magsf
plt.plot(freq, Fr)
plt.subplot(514)
yf = np.fft.ifft(Ff)
yr = np.fft.ifft(Fr)
plt.plot_date(t, yf, 'b-')
plt.subplot(515)
flux = y - np.real(yf)
plt.plot_date(t, flux, 'b-')
plt.plot_date(t, y, 'b-')
plt.show()