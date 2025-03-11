#!/bin/bash
sudo systemctl enable record_dashcam.service
sudo systemctl start record_dashcam.service
notify-send "Record Dashcam Service Enabled and Started"
