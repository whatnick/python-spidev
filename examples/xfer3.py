import sys
import spidev

## instantiate the spi object
# for Omega2 firmware v0.3.0 and up:
spi = spidev.SpiDev(0,1)
# for older firmware:
#spi = spidev.SpiDev(32766,1)

# set the speed to 4MHz
spi.max_speed_hz=4000000

# Do a half-duplex transmission where n bytes are written and m bytes are read
print("Half-duplex transmission: writing 1 byte, reading 2 bytes")
# values = spi.xfer3([<list of bytes to write>], <number of bytes to read>)
readVals = spi.xfer3([0x42], 2)

print("Read:", readVals)


print("Done")
