#!/bin/bash
output_path="/home/carcam/Recordings/Audio"
chunk_duration=600  # 10 minutes in seconds

# Create the directory if it doesn't exist
mkdir -p "$output_path"

while true; do
    TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
    # Update with the correct device ID for HD Pro Webcam C930e
    arecord -D plughw:3,0 -f cd | ffmpeg -f wav -i - -c:a libmp3lame -b:a 128k -f segment -segment_time $chunk_duration -reset_timestamps 1 "$output_path/audio_${TIMESTAMP}_%03d.mp3"
done
