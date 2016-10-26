import csv
import matplotlib.pyplot as plt
import numpy as np


def read_file(dir):
    ch1 = []
    ch2 = []
    ch3 = []
    ch4 = []
    ch5 = []
    ch6 = []
    ch7 = []
    ch8 = []
    ch9 = []
    ch10 = []
    ch11 = []
    ch12 = []
    ch13 = []
    ch14 = []
    channel = [ch1,ch2,ch3,ch4,ch5,ch6,ch7,ch8,ch9,ch10,ch11,ch12,ch13,ch14]
    i = 0
    with open(dir, 'rt') as f:
        reader = csv.reader(f)
        for item in reader:
            if i == 0:
                i = i + 1
                continue
            ch1.append(float(item[2]))
            ch2.append(float(item[3]))
            ch3.append(float(item[4]))
            ch4.append(float(item[5]))
            ch5.append(float(item[6]))
            ch6.append(float(item[7]))
            ch7.append(float(item[8]))
            ch8.append(float(item[9]))
            ch9.append(float(item[10]))
            ch10.append(float(item[11]))
            ch11.append(float(item[12]))
            ch12.append(float(item[13]))
            ch13.append(float(item[14]))
            ch14.append(float(item[15]))
    return channel


def max(a , b):
    if a > b:
        return a
    else:
        return b

def min(a , b):
    if a > b:
        return b
    else:
        return a

def blink_detect(data, ch):

    channel = data[ch-1]
    threshold = 4200 * 1.05
    count = 0
    cur = 0
    buffer = []
    interval = []
    while(count < len(channel)):
        if channel[count] < threshold:
            count += 1
            continue

        if cur > channel[count]:
            buffer = channel[max(0,count-50):min(len(channel),count+50)]
            plt.plot(buffer)
            plt.show()
            ans = input("Is this a blink?")
            if ans == "1":
                interval.append([max(0,count-50),min(len(channel),count+50)])
                buffer = []
                count = min(len(channel),count+50)
                cur = channel[count-1]
            else:
                print("no")
                count = count + 25
                cur = channel[min(len(channel),count+25-1)]
        else:
            cur = channel[count]
            count +=1
    return interval

def wink_detect(data, ch1,ch2):

    channel1 = data[ch1-1]
    channel2 = data[ch2-1]

    threshold = 4200 * 1.05
    count = 0
    cur1 = 0
    cur2 = 0
    buffer1 = []
    buffer2 = []
    interval1 = []
    interval2 = []
    while(count < len(channel1)):
        if channel1[count] < threshold and channel2[count] < threshold:
            count += 1
            continue
        if cur1 < channel1[count] and cur2 < channel2[count]:
            cur1 = channel1[count]
            cur2 = channel2[count]
            count +=1
        else:
            buffer1 = channel1[max(0,count - 50):min(len(channel1),count + 50)]
            buffer2 = channel2[max(0, count - 50):min(len(channel2), count + 50)]
            plt.figure(1)
            plt.subplot(211)
            plt.plot(buffer1)
            plt.subplot(212)
            plt.plot(buffer2)
            plt.show()
            ans = input("Is this a wink?")
            if ans == "1":
                interval1.append([max(0,count-50),min(len(channel1),count+50)])
                interval2.append([max(0, count - 50), min(len(channel2), count + 50)])
                buffer1 = []
                buffer2 = []
                count = min(len(channel1),count+50)
                cur1 = channel1[count-1]
                cur2 = channel2[count - 1]
            else:
                print("no")
                count = count + 25
                cur1 = channel1[min(len(channel1),count+25-1)-1]
                cur2 = channel2[min(len(channel2), count + 25 - 1)-1]
    return [interval1,interval2]

def write_blink(data, interval, ch, filename):
    with open(filename,'w') as f:
        writer = csv.writer(f)

        channel = data[ch-1]
        for item in interval:
            writer.writerow(channel[item[0]:item[1]])

def write_wink(data, interval1,interval2, ch1,ch2, filename):
    with open(filename,'w') as f:
        writer = csv.writer(f)
        channel1 = data[ch1-1]
        channel2 = data[ch2-1]
        for item in interval1:
            writer.writerow(channel1[item[0]:item[1]])
        for item in interval2:
            writer.writerow(channel2[item[0]:item[1]])


dir = "CSV winks/jon-1R-12.10.16.02.32.51.csv"
data = read_file(dir)
res = wink_detect(data,2,13)
dir1 = "wink_result/winks_for_jon-1R-12.10.16.02.32.51.csv"
write_wink(data,res[0],res[1],2,13,dir1)



