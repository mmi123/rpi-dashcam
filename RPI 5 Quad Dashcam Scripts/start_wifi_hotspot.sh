#!/bin/bash
sudo systemctl enable create_wifi_hotspot.service
sudo systemctl start create_wifi_hotspot.service
notify-send "WiFi Hotspot Service Enabled and Started"
