# CircuitPython

Binary of runtime: https://circuitpython.org/board/doit_esp32_devkit_v1/

## Installation of prerequisites

```
cargo install espflash
pip install adafruit-ampy
```

## Deployment of runtime

```
curl -o circuitpython.bin https://downloads.circuitpython.org/bin/doit_esp32_devkit_v1/en_US/adafruit-circuitpython-doit_esp32_devkit_v1-en_US-8.2.9.bin
espflash write-bin 0x1000 circuitpython.bin
```

### Deployment of MicroPython code

```
ampy --port /dev/tty.usbserial-0001 put main.py
espflash monitor # Press CTRL+R to reset the chip
```
