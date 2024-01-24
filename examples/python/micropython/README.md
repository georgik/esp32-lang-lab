# MicroPython

Binary of runtime: https://micropython.org/download/ESP32_GENERIC/

## Installation of prerequisites

```
cargo install espflash
pip install adafruit-ampy
```

## Deployment of runtime

```
curl -o ESP32_GENERIC.bin https://micropython.org/resources/firmware/ESP32_GENERIC-20240105-v1.22.1.bin
espflash write-bin 0x1000 ESP32_GENERIC.bin
```

### Deployment of MicroPython code

```
ampy --port /dev/tty.usbserial-0001 put main.py
espflash monitor # Press CTRL+R to reset the chip
```
