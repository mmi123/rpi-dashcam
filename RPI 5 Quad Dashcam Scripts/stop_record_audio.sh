#!/bin/bash
sudo systemctl stop record_audio.service
sudo systemctl disable record_audio.service
notify-send "Record Audio Service Stopped and Disabled"
