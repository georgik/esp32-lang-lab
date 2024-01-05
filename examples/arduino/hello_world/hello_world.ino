#include <Arduino.h>

void setup() {
    Serial.begin(115200);
    delay(1000); // Give time for serial monitor to start

    Serial.println("Hello world!");

    // Print chip information
    esp_chip_info_t chip_info;
    esp_chip_info(&chip_info);
    Serial.print("This is ESP32 chip with ");
    Serial.print(chip_info.cores);
    Serial.print(" CPU core(s), ");

    if (chip_info.features & CHIP_FEATURE_WIFI_BGN) Serial.print("WiFi/");
    if (chip_info.features & CHIP_FEATURE_BT) Serial.print("BT");
    if (chip_info.features & CHIP_FEATURE_BLE) Serial.print("BLE");
    if (chip_info.features & CHIP_FEATURE_IEEE802154) Serial.print(", 802.15.4 (Zigbee/Thread)");

    unsigned major_rev = chip_info.revision / 100;
    unsigned minor_rev = chip_info.revision % 100;
    Serial.print(" silicon revision v");
    Serial.print(major_rev);
    Serial.print(".");
    Serial.println(minor_rev);

    uint32_t flash_size;
    if(esp_flash_get_size(NULL, &flash_size) != ESP_OK) {
        Serial.println("Get flash size failed");
        return;
    }
    Serial.print(flash_size / (uint32_t)(1024 * 1024));
    Serial.print("MB ");
    Serial.print((chip_info.features & CHIP_FEATURE_EMB_FLASH) ? "embedded" : "external");
    Serial.println(" flash");

    Serial.print("Minimum free heap size: ");
    Serial.print(esp_get_minimum_free_heap_size());
    Serial.println(" bytes");
}

void loop() {
    // Countdown and restart
    for (int i = 10; i >= 0; i--) {
        Serial.print("Restarting in ");
        Serial.print(i);
        Serial.println(" seconds...");
        delay(1000);
    }
    Serial.println("Restarting now.");
    ESP.restart();
}
