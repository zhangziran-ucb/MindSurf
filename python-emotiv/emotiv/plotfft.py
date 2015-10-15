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

signal = np.array(datalist[:,5], dtype=float)
fourier = np.fft.fft(signal)
n = signal.size
timestep = 1.0/128.0
freq = np.fft.fftfreq(n, d=timestep)

plt.plot(freq, fourier.real, freq, fourier.imag)
plt.show()