#!/bin/bash
sudo systemctl enable record_audio.service
sudo systemctl start record_audio.service
notify-send "Record Audio Service Enabled and Started"
