import numpy as np
from matplotlib.dates import datestr2num, DateFormatter
from scipy.fftpack import fft
import pylab

filename = '201510131721.txt'
datalist = pylab.loadtxt(filename, converters={0:datestr2num})

time = np.array(datalist[:,0])
signal = np.array(datalist[:,5], dtype=float)

# Number of samplepoints
N = signal.size

fs = 128.0

# sample spacing
T = 1.0 / fs
x = np.linspace(0.0, N*T, N)
y = signal

yf = fft(y)
xf = np.linspace(0.0, 1.0/(2.0*T), N/2)

import matplotlib.pyplot as plt
plt.ylim([0,5])
plt.plot(xf, 2.0/N * np.abs(yf[0:N/2]))
plt.grid()
plt.show()