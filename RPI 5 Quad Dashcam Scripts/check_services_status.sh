#!/bin/bash

services=(
  "create_wifi_hotspot"
  "record_audio"
  "manage_folder_size"
  "record_picam"
  "record_dashcam"
)

check_service_status() {
  local service=$1
  local status=$(systemctl is-active $service)
  local enabled=$(systemctl is-enabled $service)

  if [[ $status == "active" ]]; then
    echo -e "\e[32m$service: $status (enabled: $enabled)\e[0m"
  elif [[ $status == "inactive" ]]; then
    echo -e "\e[33m$service: $status (enabled: $enabled)\e[0m"
  else
    echo -e "\e[31m$service: $status (enabled: $enabled)\e[0m"
  fi
}

for service in "${services[@]}"; do
  check_service_status $service
done
