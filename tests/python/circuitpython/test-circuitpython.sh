#!/bin/bash

set -e

TARGET="$1"
BASE_DIR="$2"
RELEASE_TAG="$3"

# Define allowed targets
declare -A ALLOWED_TARGETS=(
    ["esp32"]=1
    ["esp32s2"]=1
    ["esp32s3"]=1
    ["esp32c3"]=1
    ["esp32c6"]=1
    ["esp32h2"]=1
)

TARGET="$1"

# Check if the provided target is allowed
if [[ -z "${ALLOWED_TARGETS[$TARGET]}" ]]; then
    echo "Error: Invalid target '${TARGET}'. Allowed targets are: ${!ALLOWED_TARGETS[@]}"
    exit 1
fi


# source path to wokwi-cli
export PATH=$PATH:${HOME}/bin

export SUPPORT_DIR="${BASE_DIR}/support"
export PROJECT="${BASE_DIR}/examples/python/circuitpython/hello_world/"

echo "Project path: ${PROJECT}"
cd ${PROJECT}

# Prepare report
echo '[]' > results.json


# Define URL prefixes and binary names for each target
declare -A DEVKIT
declare -A CIRCUITPYTHON_VERSION

CIRCUITPYTHON_VERSION_DEFAULT="9.0.0-rc.1"
BASE_URL="https://downloads.circuitpython.org/bin"
VENDOR="espressif"

DEVKIT[esp32]="lyrat"
DEVKIT[esp32s2]="devkitc_1_n4"
DEVKIT[esp32s3]="devkitm_1_n8"
DEVKIT[esp32c3]="devkitm_1_n4"
DEVKIT[esp32c6]="devkitc_1_n8"
DEVKIT[esp32h2]="devkitm_1_n4"

CIRCUITPYTHON_VERSION[esp32]=${CIRCUITPYTHON_VERSION_DEFAULT}
CIRCUITPYTHON_VERSION[esp32s2]=${CIRCUITPYTHON_VERSION_DEFAULT}
CIRCUITPYTHON_VERSION[esp32s3]=${CIRCUITPYTHON_VERSION_DEFAULT}
CIRCUITPYTHON_VERSION[esp32c3]=${CIRCUITPYTHON_VERSION_DEFAULT}
CIRCUITPYTHON_VERSION[esp32c6]=${CIRCUITPYTHON_VERSION_DEFAULT}
CIRCUITPYTHON_VERSION[esp32h2]=${CIRCUITPYTHON_VERSION_DEFAULT}

SELECTED_DEVKIT=${DEVKIT[$TARGET]}
SELECTED_VERSION=${CIRCUITPYTHON_VERSION[$TARGET]}

DOWNLOAD_PREFIX="${BASE_URL}/${VENDOR}_${TARGET}_${SELECTED_DEVKIT}/en_US"
RUNTIME_BIN="adafruit-circuitpython-${VENDOR}_${TARGET}_${SELECTED_DEVKIT}-en_US-${SELECTED_VERSION}.bin"

echo "Runtime: ${RUNTIME_BIN}"
if [ ! -e ${RUNTIME_BIN} ]; then
    echo "Downloading CircuitPython for ${TARGET} from ${DOWNLOAD_PREFIX}/${RUNTIME_BIN}"
    curl -L ${DOWNLOAD_PREFIX}/${RUNTIME_BIN} -o ${RUNTIME_BIN}
fi

echo "Building ${TARGET}"
OUTPUT_PREFIX="python-circuitpython-hello-world-${TARGET}-${RELEASE_TAG}"
OUTPUT_BIN="out.bin"
OUTPUT_TXT="${OUTPUT_PREFIX}.txt"

# Extract information from partition table for creating custom FS
ls -l ${RUNTIME_BIN}
echo dd if=${RUNTIME_BIN} of=partitions.bin bs=4096 count=1 skip=8 # 0x8000
dd if=${RUNTIME_BIN} of=partitions.bin bs=4096 count=1 skip=8 # 0x8000

echo "Partition table:"
python3 ${SUPPORT_DIR}/python/gen_esp32part.py partitions.bin | tee partitions.txt

USER_FS_OFFSET=$(grep user_fs partitions.txt | \
    sed -e 's/user_fs,data,fat,//' \
    -e 's/,.*//' | \
    tr -d '\n')

USER_FS_SIZE_KB=$(grep user_fs partitions.txt | \
    sed -e 's/K,.*$//' \
    -e 's/.*,//' | \
    tr -d '\n')
USER_FS_SIZE=$((USER_FS_SIZE_KB * 1024))
echo "User FS offset: ${USER_FS_OFFSET}; size: ${USER_FS_SIZE}"

# Create an empty FAT filesystem image
echo dd if=/dev/zero of=circuitpython_fs.img bs=${USER_FS_SIZE} count=1
dd if=/dev/zero of=circuitpython_fs.img bs=${USER_FS_SIZE} count=1
mkfs.fat -S 512 circuitpython_fs.img

# Mount the image and copy the code.py file into it
mkdir -p mountpoint
sudo mount -o loop circuitpython_fs.img mountpoint
sudo cp code.py mountpoint/
sudo umount mountpoint

# cp ${RUNTIME_BIN} ${OUTPUT_BIN}

echo esptool.py --chip ${TARGET} merge_bin -o ${OUTPUT_BIN} --flash_mode dio --flash_size 8MB 0x00 ${RUNTIME_BIN} ${USER_FS_OFFSET} circuitpython_fs.img
file ${OUTPUT_BIN}
esptool.py --chip ${TARGET} merge_bin -o ${OUTPUT_BIN} --flash_mode dio --flash_size 8MB 0x00 ${RUNTIME_BIN} ${USER_FS_OFFSET} circuitpython_fs.img

# Prepare Wokwi test
cp ${SUPPORT_DIR}/wokwi/diagram-${TARGET}.json diagram.json

echo '[wokwi]' > wokwi.toml
echo 'version = 1' >> wokwi.toml
echo "elf = \"${OUTPUT_BIN}\"" >> wokwi.toml
echo "firmware = \"${OUTPUT_BIN}\"" >> wokwi.toml

# Run Wokwi test
wokwi-cli --timeout 15000 \
    --timeout-exit-code 0 \
    --serial-log-file ${PROJECT}/${OUTPUT_TXT} \
    --elf ${OUTPUT_BIN} \
    "."


# Extract heap size (you might need to adjust the parsing command)
HEAP_SIZE=$(grep 'Minimum free heap size' ${OUTPUT_TXT} | tr -d '\n' | sed -e 's/Minimum free heap size: //' -e 's/ bytes//')

# Add a new record to the JSON database
jq --arg target "$TARGET" \
    --arg language "Python" \
    --arg flavor "CircuitPython" \
    --arg example "hello-world" \
    --arg property "heap" \
    --arg value "$HEAP_SIZE" \
    --arg unit "bytes" \
    --arg note "" \
    --arg version "8.2.9" \
    --arg timestamp "$(date -Iseconds)" \
    '. += [{
        target: $target,
        language: $language,
        flavor: $flavor,
        example: $example,
        property: $property,
        value: $value,
        unit: $unit,
        note: $note,
        version: $version,
        timestamp: $timestamp
    }]' results.json > temp.json && mv temp.json results.json

cat result.json
