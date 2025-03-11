#!/bin/bash
sudo systemctl stop manage_folder_size.service
sudo systemctl disable manage_folder_size.service
notify-send "Service Stopped and Disabled"
