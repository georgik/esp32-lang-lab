## Build Rust no_std example

The project is using .cargo/config.toml alias mechanism.

Instead of `cargo run`, use alias:

```
cargo esp32 --release
cargo esp32s2 --release
cargo esp32s3 --release
cargo esp32c3 --release
cargo esp32c6 --release
cargo esp32h2 --release
```