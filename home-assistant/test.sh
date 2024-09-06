#!/bin/bash
containers='[
  {
    "dockerName": "home-assistant",
    "srcDir": "/opt/home-assistant",
    "backupDir": "/mnt/backup/home-assistant"
  },
  {
    "dockerName": "esphome",
    "srcDir": "/opt/esphome",
    "backupDir": "/mnt/backup/esphome"
  }
]'

# Loop over containers array without jq
len=$(echo "$containers" | grep -o '{' | wc -l)
for ((i = 0; i < len; i++)); do
  dockerName=$(echo "$containers" | grep -oP '"dockerName": "\K[^"]+' | sed -n $((i+1))p)
  srcDir=$(echo "$containers" | grep -oP '"srcDir": "\K[^"]+' | sed -n $((i+1))p)
  backupDir=$(echo "$containers" | grep -oP '"backupDir": "\K[^"]+' | sed -n $((i+1))p)
  echo "Container $((i+1)) Docker Name: $dockerName"
  echo "Container $((i+1)) Source Dir: $srcDir"
  echo "Container $((i+1)) Backup Dir: $backupDir"
done