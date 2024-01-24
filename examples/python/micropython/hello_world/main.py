import machine
import esp
import gc
import time
import os

print("Hello world!")

# Flash size
flash_size = esp.flash_size()
print("Flash size: {} MB".format(flash_size // (1024 * 1024)))

# Minimum free heap size
print("Minimum free heap size: {} bytes".format(gc.mem_free()))

# Countdown and restart
for i in range(10, -1, -1):
    print("Restarting in {} seconds...".format(i))
    time.sleep(1)

print("Restarting now.")
machine.reset()
