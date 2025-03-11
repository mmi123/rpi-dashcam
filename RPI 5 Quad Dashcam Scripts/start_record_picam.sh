#!/bin/bash
sudo systemctl enable record_picam.service
sudo systemctl start record_picam.service
notify-send "Record Picam Service Enabled and Started"
