

fn main() {
    esp_idf_svc::sys::link_patches();
    esp_idf_svc::log::EspLogger::initialize_default();

    log::info!("Hello, world!");

    // Access chip information
    let chip_info = esp_chip_info();
    // let mut features = String::new();
    // if chip_info.features & esp_idf_sys::CHIP_FEATURE_WIFI_BGN != 0 {
    //     features.push_str("WiFi/");
    // }
    // if chip_info.features & esp_idf_sys::CHIP_FEATURE_BLE != 0 {
    //     features.push_str("BLE/");
    // }

    // log::info!("This is ESP32 chip with {} CPU core(s), {}", chip_info.cores, features);

    // Get flash size
    let mut flash_size: u32 = 0;
    unsafe {
        esp_idf_sys::esp_flash_get_size(0, &mut flash_size);
    }
    log::info!("Flash size: {} MB", flash_size / (1024 * 1024));

    // Get free heap size
    let free_heap = unsafe { esp_idf_sys::esp_get_free_heap_size() };
    log::info!("Free heap size: {} bytes", free_heap);

    // Countdown
    for i in (0..=10).rev() {
        log::info!("Restarting in {} seconds...", i);
        esp_idf_sys::vTaskDelay(1000 / esp_idf_sys::portTICK_PERIOD_MS);
    }

    log::info!("Restarting now.");
    esp_idf_sys::esp_restart();
}
