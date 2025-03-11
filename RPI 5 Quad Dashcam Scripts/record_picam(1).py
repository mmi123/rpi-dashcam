import os
import subprocess
from datetime import datetime
from multiprocessing import Process

# Define the recording parameters
output_path = "/home/carcam/Recordings/Picam"
resolution = "2592x1944"
fps = 12
bitrate_mbps = 2  # Bitrate in megabits per second
bitrate = bitrate_mbps * 1000000  # Convert to bits per second
chunk_duration = 60  # 1 minute in seconds

# Create the output directory if it doesn't exist
os.makedirs(output_path, exist_ok=True)

# Function to start recording from a camera
def start_recording(camera_id):
    while True:
        try:
            # Generate the filename based on the camera ID and current time
            timestamp = datetime.now().strftime("%Y_%m_%d_%H%M%S")
            filename_template = f"camera_{camera_id}_{timestamp}_%03d.mkv"
            filepath = os.path.join(output_path, filename_template)
            # Notify that recording is starting
            print(f"Camera {camera_id} is now recording...")
            # Command to start recording using libcamera
            command = [
                "libcamera-vid",
                "--width", resolution.split('x')[0],
                "--height", resolution.split('x')[1],
                "--framerate", str(fps),
                "--bitrate", str(bitrate),
                "--camera", str(camera_id),
                "-t", str(chunk_duration * 1000),  # Duration in milliseconds
                "--codec", "libav",
                "--libav-format", "matroska",
                "--nopreview",
                "-o", "-"  # Output to stdout
            ]
            # Command to segment the video using ffmpeg
            ffmpeg_command = [
                "ffmpeg",
                "-fflags", "+genpts",
                "-f", "matroska",
                "-i", "-",  # Input from stdin
                "-c:v", "copy",
                "-f", "segment",
                "-segment_time", str(chunk_duration),
                "-reset_timestamps", "1",
                filepath
            ]
            # Start the recording and segmentation process
            print(f"Starting libcamera-vid with command: {' '.join(command)}")
            recording_process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            print(f"Starting ffmpeg with command: {' '.join(ffmpeg_command)}")
            segmentation_process = subprocess.Popen(ffmpeg_command, stdin=recording_process.stdout, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

            recording_process.stdout.close()  # Allow libcamera to receive a SIGPIPE if ffmpeg exits
            stdout, stderr = segmentation_process.communicate()  # Wait for the segmentation process to complete
            # Log output for debugging
            print(f"FFmpeg stdout: {stdout}")
            print(f"FFmpeg stderr: {stderr}")
            # Notify that the video has been saved
            print(f"Camera {camera_id} has saved the video: {filename_template}")
        except subprocess.CalledProcessError as e:
            # Log error for debugging
            print(f"An error occurred with camera {camera_id}: {e}")
            print("Restarting recording...")

# Start recording from both cameras simultaneously
if __name__ == "__main__":
    # Create a process for each camera
    camera_0_process = Process(target=start_recording, args=(0,))
    camera_1_process = Process(target=start_recording, args=(1,))
    # Start the processes
    camera_0_process.start()
    camera_1_process.start()
    # Wait for both processes to finish
    camera_0_process.join()
    camera_1_process.join()
