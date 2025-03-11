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
    printf "\e[32m$service: $status (enabled: $enabled)\e[0m\n"
  elif [[ $status == "inactive" ]]; then
    printf "\e[33m$service: $status (enabled: $enabled)\e[0m\n"
  else
    printf "\e[31m$service: $status (enabled: $enabled)\e[0m\n"
  fi
}

show_usage_bar() {
  local usage=$1
  local total=20  # Adjust this value to change bar length
  local used=$(( usage * total / 100 ))
  local free=$(( total - used ))

  printf "\e[36m["
  for i in $(seq 1 $used); do printf "#"; done
  for i in $(seq 1 $free); do printf "."; done
  printf "]\e[0m %d%%\n" $usage
}

get_cpu_usage() {
  local cpu_line=$(grep 'cpu ' /proc/stat)
  local user=$(echo $cpu_line | awk '{print $2}')
  local nice=$(echo $cpu_line | awk '{print $3}')
  local system=$(echo $cpu_line | awk '{print $4}')
  local idle=$(echo $cpu_line | awk '{print $5}')
  local iowait=$(echo $cpu_line | awk '{print $6}')
  local irq=$(echo $cpu_line | awk '{print $7}')
  local softirq=$(echo $cpu_line | awk '{print $8}')
  local steal=$(echo $cpu_line | awk '{print $9}')
  
  local total1=$((user + nice + system + idle + iowait + irq + softirq + steal))
  local idle1=$((idle + iowait))

  sleep 0.5

  cpu_line=$(grep 'cpu ' /proc/stat)
  user=$(echo $cpu_line | awk '{print $2}')
  nice=$(echo $cpu_line | awk '{print $3}')
  system=$(echo $cpu_line | awk '{print $4}')
  idle=$(echo $cpu_line | awk '{print $5}')
  iowait=$(echo $cpu_line | awk '{print $6}')
  irq=$(echo $cpu_line | awk '{print $7}')
  softirq=$(echo $cpu_line | awk '{print $8}')
  steal=$(echo $cpu_line | awk '{print $9}')

  local total2=$((user + nice + system + idle + iowait + irq + softirq + steal))
  local idle2=$((idle + iowait))

  local total_diff=$((total2 - total1))
  local idle_diff=$((idle2 - idle1))
  local usage=$(((1000 * (total_diff - idle_diff) / total_diff + 5) / 10))

  echo $usage
}

clear
while true; do
  tput home

  tput cup 0 0
  printf "\e[36mSystem Uptime: $(uptime -p)\e[0m\n"

  cpu_usage=$(get_cpu_usage)
  tput cup 1 0
  printf "\e[36mCPU Usage: $cpu_usage%%\e[0m\n"

  mem_usage=$(free | awk '/Mem/ {printf("%.0f", $3/$2 * 100.0)}')
  tput cup 2 0
  printf "\e[36mMemory Usage:\e[0m\n"
  tput cup 3 0
  show_usage_bar $mem_usage

  disk_usage=$(df / | awk 'NR==2 {printf("%.0f", $3/$2 * 100.0)}')
  tput cup 4 0
  printf "\e[36mDisk Usage:\e[0m\n"
  tput cup 5 0
  show_usage_bar $disk_usage

  row=6
  for service in "${services[@]}"; do
    tput cup $row 0
    check_service_status $service
    ((row++))
  done
  sleep 1
done
