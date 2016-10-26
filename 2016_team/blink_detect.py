from Signal import *
import numpy as np
import matplotlib.pyplot as plt

class BlinkDetector:
    """
        constructor of BlinkDetector

        Args:
            file: a dict with
            'file_ideal_blink': a csv file containing ideal-blink chunk in all channels, no header
            'file_train': a csv file with training data, format tbd

            training file will be omitted if there has been a ideal blink file
    """
    def __init__(self, **file):
        try:
            if not file['file_ideal_blink'] is None:
                self.ideal_blink = np.genfromtxt(file['file_ideal_blink'], delimiter=',')
            elif not file['file_train'] is None:
                self.ideal_blink = self.__train(file['file_train'])
            self.__window_size = len(self.ideal_blink)
        except:
            raise Exception('invalid file args')

    def __train(self, file_train):
        # TODO
        return None

    def __getPearson(self, chunk1, chunk2):
        cnt = len(chunk1)
        sum1 = sum(chunk1)
        sum2 = sum(chunk2)
        sqSum1 = sum(pow(num, 2) for num in chunk1)
        sqSum2 = sum(pow(num, 2) for num in chunk2)
        mulSum = sum(chunk1[i] * chunk2[i] for i in range(cnt))
        son = mulSum-sum1*sum2/cnt
        mot = np.sqrt((sqSum1-pow(sum1, 2)/cnt)*(sqSum2-pow(sum2, 2)/cnt))
        if mot == 0:
            r = 0
        else:
            r = son/mot
        return r

    def detect(self, signal, channels=[0], threshold=0.7, step=1):
        len_channels = len(channels)
        chunks1 = self.ideal_blink[:, channels]
        it = signal.iterator(channels, self.__window_size, step)
        record_posi = []
        rec_on = False
        curr_max = 0
        curr_posi = int(self.__window_size / 2)
        max_posi = 0
        while it.has_next():
            chunks2 = it.next()
            sum_pearson = 0
            for i in range(0, len_channels):
                sum_pearson += self.__getPearson(chunks1[:, i], chunks2[:, i])

            pearson = sum_pearson / len_channels
            if rec_on and pearson < threshold:
                rec_on = False
                record_posi.append(max_posi)
            elif rec_on and threshold <= pearson:
                if curr_max < pearson:
                    curr_max = pearson
                    max_posi = curr_posi
            elif not rec_on and threshold <= pearson:
                rec_on = True
                curr_max = pearson
                max_posi = curr_posi

            curr_posi += step
        return np.array(record_posi)

    def convert_to_time(self, position, freq=128):
        return position / freq



file_ideal_blink = 'ideal_blink.csv'
file_signal = 'Robin-1st-27.09.16.02.23.55.csv'

bd = BlinkDetector(file_ideal_blink=file_ideal_blink)
signal = Signal(file_signal)
posi = bd.detect(signal, [0], 0.6)
print(bd.convert_to_time(posi, 128))
