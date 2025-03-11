#!/bin/bash
sudo systemctl stop record_picam.service
sudo systemctl disable record_picam.service
notify-send "Record Picam Service Stopped and Disabled"
