#![no_std]
#![no_main]

use esp_backtrace as _;
use esp_println::println;
use hal::{clock::ClockControl, peripherals::Peripherals, prelude::*, Delay};

#[entry]
fn main() -> ! {
    let peripherals = Peripherals::take();
    let system = peripherals.SYSTEM.split();

    let clocks = ClockControl::max(system.clock_control).freeze();
    let mut delay = Delay::new(&clocks);

    println!("Hello world!");

    // println!("This is ESP32 chip with ... CPU core(s), ...");

    // println!("Minimum free heap size: ... bytes");

    // Countdown from 10 to 0 with a 1-second delay
    for i in (0..=10).rev() {
        println!("starting in {} seconds...", i);
        delay.delay_ms(1000u32);
    }

    println!("Restarting now.");

    loop {
    }
}
