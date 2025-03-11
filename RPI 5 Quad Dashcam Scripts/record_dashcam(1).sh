#!/bin/bash

# Wait for initial 5 seconds after boot
sleep 5

# Directory to save videos
VIDEO_DIR="/home/carcam/Recordings/Dashcam"

# Create video directory if it doesn't exist
mkdir -p "$VIDEO_DIR"

# Function to record from a camera
record_camera() {
    local CAMERA=$1
    local DEVICE=$2
    local SEGMENT_TIME=$3
    while :; do
        TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
        FILENAME="${VIDEO_DIR}/${CAMERA}_${TIMESTAMP}_%04d.mkv"
        gst-launch-1.0 -e v4l2src device="$DEVICE" ! video/x-h264,framerate=30/1,width=1920,height=1080 ! \
        h264parse ! splitmuxsink max-size-time=$SEGMENT_TIME location="${FILENAME}"
        sleep 0.05  # Ensures the loop continues smoothly and doesn't overload the system
    done &
    echo $! > "/tmp/${CAMERA}_pid.txt"  # Save PID of the process to a temporary file
}

# Ensure no other process is using the cameras
sudo fuser -k /dev/webcam_c930e
sudo fuser -k /dev/webcam_j5

# Start recording from both cameras with 1-minute segments
SEGMENT_TIME=$((60 * 1000000000))  # 1 minute in nanoseconds
record_camera "camera1" "/dev/webcam_c930e" $SEGMENT_TIME
record_camera "camera2" "/dev/webcam_j5" $SEGMENT_TIME

# Function to clean up the processes
cleanup() {
    for CAMERA in "camera1" "camera2"; do
        if [ -f "/tmp/${CAMERA}_pid.txt" ]; then
            PID=$(cat "/tmp/${CAMERA}_pid.txt")
            kill $PID  # Send SIGTERM to stop the recording process
            rm "/tmp/${CAMERA}_pid.txt"
        fi
    done
}

# Trap termination signals and call cleanup function
trap cleanup SIGINT SIGTERM EXIT

# Wait for all background processes to finish
wait
