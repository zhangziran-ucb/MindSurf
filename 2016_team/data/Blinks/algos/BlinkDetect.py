import numpy as np
import csv
import matplotlib.pyplot as plt

class Test:
    trained = []
    para = []
    def __init__(self, trained, para):
        self.trained = trained
        self.para = para
    def __getPearson(self, T2):
        T1 = self.trained
        cnt = len(T1)
        sum1 = sum(T1)
        sum2 = sum(T2)
        sqSum1 = sum(pow(num, 2) for num in T1)
        sqSum2 = sum(pow(num, 2) for num in T2)
        mulSum = sum(T1[i]*T2[i] for i in range(cnt))
        son = mulSum-sum1*sum2/cnt
        mot = np.sqrt((sqSum1-pow(sum1, 2)/cnt)*(sqSum2-pow(sum2, 2)/cnt))
        if mot == 0:
            r = 0
        else:
            r = son/mot
        return r
    def doTest(self, testFile):
        blinkMoment = []
        threshold = 0.3
        interval = self.para['interval']
        sampling = self.para['sampling']
        file = open(testFile, 'r')
        reader = csv.reader(file)
        data = [row[3] for row in reader]
        file.close()
        data = data[1:len(data)]
        for i in range(0, len(data)):
            data[i] = float(data[i])
        i = 0
        stopPoint = len(data) - interval
        while i < stopPoint:
            seg = data[i: i + interval]
            pearson = self.__getPearson(seg)
            if threshold < pearson:
                blinkMoment.append([i / sampling, pearson])
                i += interval
            i += 1
        return blinkMoment

class Train:
    csvFiles = []
    parameter = []
    def __init__(self, csvFiles, parameter):
        self.csvFiles = csvFiles
        self.para = parameter
    def doTraining(self):
        timeGap = self.para['sampling'] * self.para['gap']
        num = 10
        interval = self.para['interval']
        seg = [0 for j in range(0, interval)]
        interval = int(interval / 2)
        for cf in self.csvFiles:
            file = open(cf, 'r')
            reader = csv.reader(file)
            data = [row[3] for row in reader]
            file.close()
            data = data[1:len(data)]
            for i in range(0, len(data)):
                data[i] = float(data[i])
            x = range(0, len(data))
            plt.plot(x, data)
            plt.show()

            mid = int(input('1st mid position = '))
            newSeg = data[mid - interval:mid + interval]
            seg = [seg[j] + newSeg[j] for j in range(0, len(seg))]
            for i in range(1, num):
                mid += timeGap
                tempSeg = data[mid - interval:mid + interval]
                mid += tempSeg.index(max(tempSeg)) - interval
                newSeg = data[mid - interval:mid + interval]
                seg = [(seg[j] + newSeg[j])/2 for j in range(0, len(seg))]
        return seg

csvNames = ['ethan-1st-27.09.16.02.35.29.csv', 'Robin-1st-27.09.16.02.23.55.csv']
para = {'interval':500, 'sampling':128, 'gap':5}
t = Train(csvNames, para)
trained = t.doTraining()
test = Test(trained, para)
blinkMoments = test.doTest(csvNames[0])
print(blinkMoments)
