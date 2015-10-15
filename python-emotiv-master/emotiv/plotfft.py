# http://www.astropy.org/astropy-tutorials/plot-catalog.html

from matplotlib.dates import datestr2num, DateFormatter
import pylab
import numpy as np
import matplotlib.pyplot as plt
from scipy.fftpack import rfft, irfft, fftfreq

# https://stackoverflow.com/questions/1574088/plotting-time-in-python-with-matplotlib

filename = '201510131721.txt'
list_of_files = [ (filename, 'label 1')]

# datalist = [ ( pylab.loadtxt(filename, converters={0:strpdate2num('%H:%M:%S.%f')}), label ) for filename, label in list_of_files ]
# numpy.loadtxt(filename, converters={0:strpdate2num('%H:%M:%S.%f')

datalist = pylab.loadtxt(filename, converters={0:datestr2num})

signal = datalist[:,3]

W = fftfreq(signal.size, d=datalist[0,0]-datalist[:,3])
f_signal = rfft(signal)

# If our original signal time was in seconds, this is now in Hz    
cut_f_signal = f_signal.copy()
cut_f_signal[(W<6)] = 0

cut_signal = irfft(cut_f_signal)

pylab.subplot(221)
pylab.plot(time,signal)
pylab.subplot(222)
pylab.plot(W,f_signal)
pylab.xlim(0,10)
pylab.subplot(223)
pylab.plot(W,cut_f_signal)
pylab.xlim(0,10)
pylab.subplot(224)
pylab.plot(time,cut_signal)
pylab.show()


# for data, label in datalist:
#    pylab.plot( data[:,0], data[:,1], label=label )

# pylab.plot_date(datalist[:,0], datalist[:,2])
# pylab.plot_date(datalist[:,0], datalist[:,5])																																																																																																															])
# pylab.gca().xaxis.set_major_formatter(DateFormatter("%H:%M:%S.%f"))
# pylab.legend()
# pylab.title("Title of Plot")
# pylab.xlabel("X Axis Label")
# pylab.gcf().autofmt_xdate()
# pylab.ylabel("Y Axis Label")
# pylab.show()