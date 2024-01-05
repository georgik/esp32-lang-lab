#![no_std]
#![no_main]

extern crate alloc;
use core::mem::MaybeUninit;
use esp_backtrace as _;
use esp_println::println;
use hal::{clock::ClockControl, peripherals::Peripherals, prelude::*, Delay};

#[global_allocator]
static ALLOCATOR: esp_alloc::EspHeap = esp_alloc::EspHeap::empty();

fn init_heap() {
    #[cfg(feature = "esp32")]
    const HEAP_SIZE: usize = 175 * 1024;
    #[cfg(feature = "esp32s2")]
    const HEAP_SIZE: usize = 174 * 1024;
    #[cfg(feature = "esp32s3")]
    const HEAP_SIZE: usize = 325 * 1024;
    #[cfg(feature = "esp32c3")]
    const HEAP_SIZE: usize = 315 * 1024;
    #[cfg(feature = "esp32c6")]
    const HEAP_SIZE: usize = 430 * 1024;
    #[cfg(feature = "esp32h2")]
    const HEAP_SIZE: usize = 100 * 1024;


    static mut HEAP: MaybeUninit<[u8; HEAP_SIZE]> = MaybeUninit::uninit();

    unsafe {
        ALLOCATOR.init(HEAP.as_mut_ptr() as *mut u8, HEAP_SIZE);
    }
}

#[entry]
fn main() -> ! {

    init_heap();

    let peripherals = Peripherals::take();
    let system = peripherals.SYSTEM.split();

    let clocks = ClockControl::max(system.clock_control).freeze();
    let mut delay = Delay::new(&clocks);

    println!("Hello world!");

    // println!("This is ESP32 chip with ... CPU core(s), ...");

    println!("Minimum free heap size: {} bytes", ALLOCATOR.free());

    // Countdown from 10 to 0 with a 1-second delay
    for i in (0..=10).rev() {
        println!("starting in {} seconds...", i);
        delay.delay_ms(1000u32);
    }

    println!("Restarting now.");

    loop {
    }
}
