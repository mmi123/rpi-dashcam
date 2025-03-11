#!/usr/bin/env python3
from picamera2 import Picamera2, Preview
import time
from multiprocessing import Process

def preview_internal_camera(camera_id):
    cam = Picamera2(camera_num=camera_id)
    # Configure the camera
    config = cam.create_preview_configuration(main={'size': (2592, 1944), 'format': 'RGB888'})
    cam.configure(config)
    # Set the frame rate
    cam.set_controls({"FrameDurationLimits": (1_000_000 // 15, 1_000_000 // 15)})
    # Start the camera preview
    cam.start_preview(Preview.QT)
    cam.start()
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        cam.stop()
        cam.close()

if __name__ == "__main__":
    # Create a process for each camera
    camera_0_process = Process(target=preview_internal_camera, args=(0,))
    camera_1_process = Process(target=preview_internal_camera, args=(1,))
    
    # Start the processes
    camera_0_process.start()
    camera_1_process.start()
    
    # Wait for both processes to finish
    camera_0_process.join()
    camera_1_process.join()
