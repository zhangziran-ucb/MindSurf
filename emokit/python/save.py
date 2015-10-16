# This is an example of popping a packet from the Emotiv class's packet queue
# and printing the gyro x and y values to the console. 

from emokit.emotiv import Emotiv
import platform
if platform.system() == "Windows":
    import socket  # Needed to prevent gevent crashing on Windows. (surfly / gevent issue #459)
import gevent
from datetime import datetime
from sys import argv

i = 0
fs = 128
if len(argv) == 2:
    script, minutes = argv
else:
    minutes = 1
T = fs * 60 * minutes

if __name__ == "__main__":
    headset = Emotiv()
    gevent.spawn(headset.setup)
    gevent.sleep(0)
    t = datetime.now()
    filename = t.strftime('%Y-%m-%d-%H-%M')
    target = open('../../data/emokit/' + filename+'.txt', 'w')
    target.write("# H:M:S.f Gyro(x) Gyro(y) F3 F4 P7 FC6 F7 F8 T7 P8 FC5 AF4 T8 O2 O1 AF3\n")
    try:
        while i < fs * 60:
            packet = headset.dequeue()
            # print packet.gyro_x, packet.gyro_y
            timestamp = datetime.now()
            timestamp = timestamp.strftime('%H:%M:%S.%f')
            target.write(timestamp)
            target.write(' ')
            # target.write(str(packet.gyro_x))
            # target.write(' ')
            # target.write(str(packet.gyro_y))
            # target.write(' ')
            for k in enumerate(headset.sensors):
                    if k[1] not in ["Y","X","Unknown"]:
                        target.write(str(headset.sensors[k[1]]['value']))
                        target.write(' ')
            target.write('\n')
            gevent.sleep(0)
            i = i+1
    except KeyboardInterrupt:
        headset.close()
    finally:
        headset.close()