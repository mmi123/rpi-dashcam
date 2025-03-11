from picamera2 import Picamera2, Preview
import time
from multiprocessing import Process
import subprocess

def preview_internal_camera(camera_id):
    cam = Picamera2(camera_num=camera_id)
    cam.start_preview(Preview.QT)
    cam.start()
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        cam.stop()
        cam.close()

def preview_usb_camera(device):
    command = [
        "ffplay",
        "-f", "v4l2",
        "-framerate", "30",
        "-video_size", "1920x1080",
        "-i", device
    ]
    subprocess.run(command)

if __name__ == "__main__":
    # Internal cameras (Pi cameras)
    camera_0_process = Process(target=preview_internal_camera, args=(0,))
    camera_1_process = Process(target=preview_internal_camera, args=(1,))
    
    # USB cameras - update /dev/videoX to the correct device paths
    usb_camera_1_process = Process(target=preview_usb_camera, args=("/dev/webcam_j5",))  # Change /dev/video0 to the device address for camera1
    usb_camera_2_process = Process(target=preview_usb_camera, args=("/dev/webcam_c930e",))  # Change /dev/video1 to the device address for camera2
    
    # Start all processes
    camera_0_process.start()
    camera_1_process.start()
    usb_camera_1_process.start()
    usb_camera_2_process.start()
    
    # Wait for all processes to finish
    camera_0_process.join()
    camera_1_process.join()
    usb_camera_1_process.join()
    usb_camera_2_process.join()
