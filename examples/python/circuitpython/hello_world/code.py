import board
import gc
import microcontroller
import time

print("Hello world!")


# Flash size
flash_size = microcontroller.nvm
print("Flash size:", len(flash_size), "bytes")

print("Minimum free heap size: {} bytes".format(gc.mem_free()))

# Countdown and reset
for i in range(10, -1, -1):
    print("Restarting in {} seconds...".format(i))
    time.sleep(1)

print("Restarting now.")
microcontroller.reset()
