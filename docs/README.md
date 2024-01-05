# ESP32 Language Lab

The project is comparing different languages/technologies for ESP32

## hello_world

The application outputs "Hello world!". Then it prints information about chip, flash and heap size.
Then the application waits for 10 seconds before rebooting.


|             | ESP-IDF C  | Arduino    | CircuitPython | MicroPython | Rust no_std | Rust std | Toit | 
|-------------|------------|------------|---------------|-------------|-------------|----------|------|
| Chip Target | ESP32      | ESP32      | n/a           | n/a         | n/a         |          | n/a  |
| CPU Cores   | 2          | 2          | n/a           | n/a         | n/a         |          | n/a  |
| Features    | WiFi/BTBLE | WiFi/BTBLE | n/a           | n/a         | n/a         |          | n/a  |
| Flash size  | 2MB        | 4MB (?)    | 8192 (?)      | 4 MB (?)    | n/a         |          | n/a  |
| Free heap   | 300892     | 237568     | 113424        | 164064      | n/a         |          | n/a  |

