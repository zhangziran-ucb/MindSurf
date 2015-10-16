# This is an example of popping a packet from the Emotiv class's packet queue
# and printing the gyro x and y values to the console. 

from emokit.emotiv import Emotiv
import platform
if platform.system() == "Windows":
    import socket  # Needed to prevent gevent crashing on Windows. (surfly / gevent issue #459)
import gevent
from datetime import datetime
from sys import argv
from os.path import exists

fs = 128
if len(argv) == 3:
    seconds = (int)(argv[2][0])
    minutes = (int)(argv[1][0])
elif len(argv) == 2:
    seconds = 5
    minutes = (int)(argv[1][0])
else:
    seconds = 5
    minutes = 1
duration = fs*60*minutes

iteration = 0
filenumber = 0

if __name__ == "__main__":
    headset = Emotiv()
    gevent.spawn(headset.setup)
    gevent.sleep(0)
    
    try:
        while iteration < duration:
            filenumber = str(iteration//(fs*seconds))
            filename = '../../data/emokit/test' + filenumber+'.txt'
            if exists(filename):
                # Update the existing file
                target = open(filename, 'a')
            else:
                # Create a new temp file
                target = open(filename, 'w')
                target.write("# (H:M:S.f) Gyro(x) Gyro(y) F3 F4 P7 FC6 F7 F8 T7 P8 FC5 AF4 T8 O2 O1 AF3\n")
            packet = headset.dequeue()
            # print packet.gyro_x, packet.gyro_y
            timestamp = datetime.now()
            timestamp = timestamp.strftime('%H:%M:%S.%f')
            # target.write(timestamp)
            # target.write(' ')
            target.write(str(packet.gyro_x))
            target.write(' ')
            target.write(str(packet.gyro_y))
            target.write(' ')
            for k in enumerate(headset.sensors):
                    if k[1] not in ["Y","X","Unknown"]:
                        target.write(str(headset.sensors[k[1]]['value']))
                        target.write(' ')
            target.write('\n')
            gevent.sleep(0)
            iteration += 1
    except KeyboardInterrupt:
        headset.close()
    finally:
        headset.close()