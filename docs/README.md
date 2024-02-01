# ESP32 Language Lab

The project is comparing different languages/technologies for ESP32

## hello_world

The application outputs "Hello world!". Then it prints information about chip, flash and heap size.
Then the application waits for 10 seconds before rebooting.

### Results for ESP32:

|             | ESP-IDF C  | Arduino    | CircuitPython | MicroPython | Rust no_std | Rust std | Toit |
|-------------|------------|------------|---------------|-------------|-------------|----------|------|
| Chip Target | ESP32      | n/a        | n/a           | n/a         | n/a         |          | n/a  |
| CPU Cores   | 2          | 2          | n/a           | n/a         | n/a         |          | n/a  |
| Features    | WiFi/BTBLE | WiFi/BTBLE | n/a           | n/a         | n/a         |          | n/a  |
| Flash size  | 2MB [^1]   | 4MB        | 8192 (?)[^4]  | 4 MB        | n/a         |          | n/a  |
| Free heap   | 300892     | 237568     | 113424        | 164064      | 179200 [^2] | 296028   | n/a  |

### Results for ESP32-S2:

|             | ESP-IDF C  | Arduino    | CircuitPython | MicroPython | Rust no_std | Rust std | Toit |
|-------------|------------|------------|---------------|-------------|-------------|----------|------|
| Chip Target | esp32s2    | n/a        |               |             |             |          |      |
| CPU Cores   | 1          | 1          |               |             |             |          |      |
| Features    | WiFi       | WiFi       |               |             |             |          |      |
| Flash size  | 2MB [^1]   | 4MB        |               |             |             |          |      |
| Free heap   | 246696     | 229688     | 70848         | 2059520     | 178176 [^3] | 246844   |      |


### Results for ESP32-S3:

|             | ESP-IDF C  | Arduino    | CircuitPython | MicroPython | Rust no_std | Rust std | Toit |
|-------------|------------|------------|---------------|-------------|-------------|----------|------|
| Chip Target | esp32s3    | n/a        |               |             |             |          |      |
| CPU Cores   | 2          | 2          |               |             |             |          |      |
| Features    | WiFi/BLE   | WiFi/BLE   |               |             |             |          |      |
| Flash size  | 2MB [^1]   | 8MB external |             |             |             |          |      |
| Free heap   | 386744     | 36992      |  150432       |             |  332800     | 388016   |      |

### Results for ESP32-C3:

|             | ESP-IDF C  | Arduino    | CircuitPython | MicroPython | Rust no_std | Rust std | Toit |
|-------------|------------|------------|---------------|-------------|-------------|----------|------|
| Chip Target | esp32c3    |            |               |             |             |          |      |
| CPU Cores   | 1          |            |               |             |             |          |      |
| Features    | WiFi/BLE   |            |               |             |             |          |      |
| Flash size  | 2MB [^1]   |            |               |             |             |          |      |
| Free heap   | 327840     |            | 129808        |             | 322556      | 327124   |      |

### Results for ESP32-C6:

|             | ESP-IDF C  | Arduino    | CircuitPython | MicroPython | Rust no_std | Rust std | Toit |
|-------------|------------|------------|---------------|-------------|-------------|----------|------|
| Chip Target | esp32c6    | Not supported |            |             |             |          |      |
| CPU Cores   | 1          |            |               |             |             |          |      |
| Features    | WiFi/BLE 802.15.4 (Zigbee/Thread) | |   |             |             |          |      |
| Flash size  | 2MB (1.)   |            |               |             |             |          |      |
| Free heap   | 468852     |            |               |             | 440316      | 471068   |      |

### Results for ESP32-H2:

|             | ESP-IDF C  | Arduino    | CircuitPython | MicroPython | Rust no_std | Rust std | Toit |
|-------------|------------|------------|---------------|-------------|-------------|----------|------|
| Chip Target | esp32h2    | Not supported |            |             |             |          |      |
| CPU Cores   | 1          |            |               |             |             |          |      |
| Features    | BLE, 802.15.4 (Zigbee/Thread)   |   |   |             |             |          |      |
| Flash size  | 2MB [^1]   |            |               |             |             |          |      |
| Free heap   | 262644     |            |               |             | 252924      | 265060   |      |

### Results for ESP32-P4:

|             | ESP-IDF C  | Arduino    | CircuitPython | MicroPython | Rust no_std | Rust std | Toit |
|-------------|------------|------------|---------------|-------------|-------------|----------|------|
| Chip Target | esp32p4    | Not supported |            |             |             |          |      |
| CPU Cores   | 2          |            |               |             |             |          |      |
| Features    | none       |            |               |             |             |          |      |
| Flash size  | 2MB [^1]   |            |               |             |             |          |      |
| Free heap   | 618680     |            |               |             |             |          |      |


## Notes

[^1]: Compile time value, not auto-detected.
[^2]: Rust no_std does not support non-continuous memory. ESP32 memory contains WiFi part in the middle.
[^3]: Rust no_std does not support non-continuous memory. The issue is caused by the [bootloader on ESP32-S2](https://github.com/espressif/esp-idf/blob/5b1189570025ba027f2ff6c2d91f6ffff3809cc2/components/esp_system/ld/esp32s2/memory.ld.in#L41C27-L43).
[^4]: Results marked with (?) does not seems to be correct, requires further validation.


