#!/bin/bash
sudo systemctl stop create_wifi_hotspot.service
sudo systemctl disable create_wifi_hotspot.service
notify-send "WiFi Hotspot Service Stopped and Disabled"
