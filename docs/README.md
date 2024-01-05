# ESP32 Language Lab

The project is comparing different languages/technologies for ESP32

## hello_world

The application outputs "Hello world!". Then it prints information about chip, flash and heap size.
Then the application waits for 10 seconds before rebooting.

Comparision of results returned by each technology for ESP32:

|             | ESP-IDF C  | Arduino    | CircuitPython | MicroPython | Rust no_std | Rust std | Toit |
|-------------|------------|------------|---------------|-------------|-------------|----------|------|
| Chip Target | ESP32      | ESP32      | n/a           | n/a         | n/a         |          | n/a  |
| CPU Cores   | 2          | 2          | n/a           | n/a         | n/a         |          | n/a  |
| Features    | WiFi/BTBLE | WiFi/BTBLE | n/a           | n/a         | n/a         |          | n/a  |
| Flash size  | 2MB        | 4MB (?)    | 8192 (?)      | 4 MB (?)    | n/a         |          | n/a  |
| Free heap   | 300892     | 237568     | 113424        | 164064      | 179200 (1.) |          | n/a  |

Notes:

0. Results marked with (?) does not seems to be correct, requires further validation.
1. Rust no_std does not support non-continuous memory. ESP32 memory contains WiFi part in the middle.
Other ESP32-* chips does not suffer from this problem, so it should be possible to allocate more memory.
