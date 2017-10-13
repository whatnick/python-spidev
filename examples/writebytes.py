import sys
import spidev
import time

# instantiate the spi object
spi = spidev.SpiDev(32766,1)
# set the speed to 4MHz
spi.max_speed_hz=4000000

# make an array of 4096 bytes of incremental data to send
vals = []
for i in range(0, 16):
    vals.extend(range(0, 256))

# number of transmissions to make
repeat = 8

print "Starting xfers, writing %d bytes %d times in a row"%(len(vals), repeat)

for i in range(0,repeat):
    # perform the transfer
    #spi.xfer(vals)
    spi.writebytes(vals)

print "Done"
