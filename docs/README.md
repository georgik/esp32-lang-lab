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
| Flash size  | 2MB        | 4MB (?)    | 8192 (?)      | 4 MB (?)    | n/a         |          | n/a  |
| Free heap   | 300892     | 237568     | 113424        | 164064      | 179200 (1.) |          | n/a  |

Notes:

0. Results marked with (?) does not seems to be correct, requires further validation.
1. Rust no_std does not support non-continuous memory. ESP32 memory contains WiFi part in the middle.
Other ESP32-* chips does not suffer from this problem, so it should be possible to allocate more memory.

### Results for ESP32-S2:

|             | ESP-IDF C  | Arduino    | CircuitPython | MicroPython | Rust no_std | Rust std | Toit |
|-------------|------------|------------|---------------|-------------|-------------|----------|------|
| Chip Target | esp32s2    | n/a        |               |             |             |          |      |
| CPU Cores   | 1          | 1          |               |             |             |          |      |
| Features    | WiFi       | WiFi       |               |             |             |          |      |
| Flash size  | 2MB        | 4MB        |               |             |             |          |      |
| Free heap   | 246696     | 229688     |               |             | 178176      |          |      |


### Results for ESP32-S3:

|             | ESP-IDF C  | Arduino    | CircuitPython | MicroPython | Rust no_std | Rust std | Toit |
|-------------|------------|------------|---------------|-------------|-------------|----------|------|
| Chip Target | esp32s3    | n/a        |               |             |             |          |      |
| CPU Cores   | 2          | 2          |               |             |             |          |      |
| Features    | WiFi/BLE   | WiFi/BLE   |               |             |             |          |      |
| Flash size  | 2MB        | 8MB external |               |             |             |          |      |
| Free heap   | 386744     | 36992      |               |             |  33280       |          |      |

### Results for ESP32-C3:

|             | ESP-IDF C  | Arduino    | CircuitPython | MicroPython | Rust no_std | Rust std | Toit |
|-------------|------------|------------|---------------|-------------|-------------|----------|------|
| Chip Target | esp32c3    |            |               |             |             |          |      |
| CPU Cores   | 1          |            |               |             |             |          |      |
| Features    | WiFi/BLE   |            |               |             |             |          |      |
| Flash size  | 2MB        |            |               |             |             |          |      |
| Free heap   | 327840     |            |               |             | 322556      |          |      |

### Results for ESP32-C6:

|             | ESP-IDF C  | Arduino    | CircuitPython | MicroPython | Rust no_std | Rust std | Toit |
|-------------|------------|------------|---------------|-------------|-------------|----------|------|
| Chip Target | esp32c6    | Not supported           |               |             |             |          |      |
| CPU Cores   | 1          |            |               |             |             |          |      |
| Features    | WiFi/BLE 802.15.4 (Zigbee/Thread)  |            |               |             |             |          |      |
| Flash size  | 2MB        |            |               |             |             |          |      |
| Free heap   | 468852     |            |               |             | 440316      |          |      |

### Results for ESP32-H2:

|             | ESP-IDF C  | Arduino    | CircuitPython | MicroPython | Rust no_std | Rust std | Toit |
|-------------|------------|------------|---------------|-------------|-------------|----------|------|
| Chip Target | esp32h2    | Not supported |               |             |             |          |      |
| CPU Cores   | 1          |            |               |             |             |          |      |
| Features    | BLE, 802.15.4 (Zigbee/Thread)   |            |               |             |             |          |      |
| Flash size  | 2MB        |            |               |             |             |          |      |
| Free heap   | 262644     |            |               |             |             |          |      |

### Results for ESP32-P4:

|             | ESP-IDF C  | Arduino    | CircuitPython | MicroPython | Rust no_std | Rust std | Toit |
|-------------|------------|------------|---------------|-------------|-------------|----------|------|
| Chip Target | esp32p4    | Not supported |               |             |             |          |      |
| CPU Cores   | 2          |            |               |             |             |          |      |
| Features    | none       |            |               |             |             |          |      |
| Flash size  | 2MB        |            |               |             |             |          |      |
| Free heap   | 618680     |            |               |             |             |          |      |
