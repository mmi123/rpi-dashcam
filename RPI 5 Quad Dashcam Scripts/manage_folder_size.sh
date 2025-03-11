#!/bin/bash
FOLDER1="/home/carcam/Recordings/Dashcam"
FOLDER2="/home/carcam/Recordings/Picam"
FOLDER3="/home/carcam/Recordings/Audio"

MAX_SIZE1=$((100 * 1024 * 1024 * 1024))
MAX_SIZE2=$((100 * 1024 * 1024 * 1024))
MAX_SIZE3=$((10 * 1024 * 1024 * 1024))

manage_folder_size() {
    local FOLDER=$1
    local MAX_SIZE=$2
    echo "Checking folder: $FOLDER"
    while [ $(du -sb "$FOLDER" | awk '{print $1}') -gt $MAX_SIZE ]; do
        OLDEST_FILE=$(ls -t "$FOLDER" | tail -1)
        rm -f "$FOLDER/$OLDEST_FILE"
        if [ $? -eq 0 ]; then
            echo "Removed file: $OLDEST_FILE from $FOLDER"
        else
            echo "Error deleting file: $OLDEST_FILE from $FOLDER" >&2
            break
        fi
    done
}

while true; do
    manage_folder_size "$FOLDER1" "$MAX_SIZE1"
    manage_folder_size "$FOLDER2" "$MAX_SIZE2"
    manage_folder_size "$FOLDER3" "$MAX_SIZE3"
    sleep 600
done
