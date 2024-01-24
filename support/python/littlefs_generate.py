
# Source: https://github.com/minasouliman/wokwi_esp32_micropython/blob/main/tools/filesystem_generate.py
 
import os
from littlefs import LittleFS
import subprocess

workspace_dir = './'

#files = os.listdir(f"{workspace_dir}/src")


output_image = f"{workspace_dir}/littlefs.img"

lfs = LittleFS(block_size=4096, block_count=512, prog_size=256)

#for filename in files:
with open(f"{workspace_dir}/main.py", 'rb') as src_file:
    with  lfs.open("main.py", 'wb') as lfs_file:
        lfs_file.write(src_file.read())

with open(output_image, 'wb') as fh:
    fh.write(lfs.context.buffer)


#subprocess.run(f"esptool.py --chip esp32 merge_bin -o {workspace_dir}/out.bin --flash_mode dio --flash_size 4MB 0x1000 {workspace_dir}/ESP32_GENERIC-20231227-v1.22.0.bin 0x200000 {workspace_dir}/littlefs.img", shell=True)

