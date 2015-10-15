# http://www.astropy.org/astropy-tutorials/plot-catalog.html

from matplotlib.dates import datestr2num, DateFormatter
import pylab
import numpy as np
import matplotlib.pyplot as plt

# https://stackoverflow.com/questions/1574088/plotting-time-in-python-with-matplotlib

filename = '201510131721.txt'
list_of_files = [ (filename, 'label 1')]

# datalist = [ ( pylab.loadtxt(filename, converters={0:strpdate2num('%H:%M:%S.%f')}), label ) for filename, label in list_of_files ]
# numpy.loadtxt(filename, converters={0:strpdate2num('%H:%M:%S.%f')

datalist = pylab.loadtxt(filename, converters={0:datestr2num})

# for data, label in datalist:
#    pylab.plot( data[:,0], data[:,1], label=label )

# pylab.plot_date(datalist[:,0], datalist[:,2])
pylab.plot_date(datalist[:,0], datalist[:,5])
# pylab.gca().xaxis.set_major_formatter(DateFormatter("%H:%M:%S.%f"))
pylab.legend()
pylab.title("Title of Plot")
pylab.xlabel("X Axis Label")
pylab.gcf().autofmt_xdate()
pylab.ylabel("Y Axis Label")
pylab.show()	