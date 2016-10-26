import numpy as np

NUM_CHANNELS = 14
CSV_FIRST_COLUMN = 2
CSV_LAST_COLUMN = 16

class Signal:
    class __SignalIterator:
        def __init__(self, data, window_size, step):
            self.__data = data
            self.__win_size = window_size
            self.__step = step

            self.__head = 0                         # inclusive
            self.__tail = window_size               # exclusive
            self.__signal_length = len(data)
            if self.__signal_length < self.__tail:
                raise Exception('window size is too long')

        def has_next(self):
            return self.__tail < self.__signal_length
        def next(self):
            output = self.__data[self.__head:self.__tail, :]
            self.__head += self.__step
            self.__tail += self.__step
            return output

    def __init__(self, cvs_file):
        data = np.genfromtxt(cvs_file, delimiter=',', skip_header=1)
        self.__data = np.copy(data[:, CSV_FIRST_COLUMN:CSV_LAST_COLUMN])

    """
        copy data from the ith channel

        Args:
            i: int, channel number (0 ~ NUM_CHANNELS-1)

        Return:
            A list containing all data points in a channel
    """
    def copy_from_channel(self, i):
        return np.copy(self.__data[:, i])

    """
        get an iterator to scan data in different channels

        Args:
            channels: int list, indicating the channels to be scanned, if none, all channels will be selected
            window_size: int, the size of the sliding window
            step: int, step length of iteration

        Return:
            a iterator object with two methods
            iter.has_next(): if the window can be moved to the next position
            iter.next(): return a m by n matrix containing data in the next window,
                         where m is the number of points per channel, and n is the number of channels
    """
    def iterator(self, channels=None, window_size=500, step=1):
        if channels is None:
            channels = range(0, NUM_CHANNELS)
        try:
            for c in channels:
                if not isinstance(c, int) or c < 0 or c >= NUM_CHANNELS:
                    raise Exception()
        except:
            raise Exception('invalid channels')

        return self.__SignalIterator(self.__data[:, channels], window_size, step)
