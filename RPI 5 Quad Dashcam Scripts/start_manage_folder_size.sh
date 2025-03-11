#!/bin/bash
sudo systemctl enable manage_folder_size.service
sudo systemctl start manage_folder_size.service
notify-send "Service Enabled and Started"
