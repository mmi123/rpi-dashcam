#!/bin/bash
sudo systemctl stop record_dashcam.service
sudo systemctl disable record_dashcam.service
notify-send "Record Dashcam Service Stopped and Disabled"
