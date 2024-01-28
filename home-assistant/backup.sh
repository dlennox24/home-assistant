#!/bin/bash
readonly containers='[
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
readonly len=$(echo "$containers" | grep -o '{' | wc -l)

for ((i = 0; i < len; i++)); do

  DOCKER_CONTAINER=$(echo "$containers" | grep -oP '"dockerName": "\K[^"]+' | sed -n $((i+1))p)
  SOURCE_DIR=$(echo "$containers" | grep -oP '"srcDir": "\K[^"]+' | sed -n $((i+1))p)
  BACKUP_DIR=$(echo "$containers" | grep -oP '"backupDir": "\K[^"]+' | sed -n $((i+1))p)
  BACKUP_PATH="${BACKUP_DIR}/$(date '+%F')"
  LATEST_LINK="${BACKUP_DIR}/latest"

  echo "Backup starting for ${DOCKER_CONTAINER}"
  echo ''

  echo "${DOCKER_CONTAINER}"
  echo "${SOURCE_DIR}"
  echo "${BACKUP_DIR}"
  echo "${BACKUP_PATH}"
  echo "${LATEST_LINK}"

  if [ ! -d "${BACKUP_DIR}" ]; then
    echo "Creating ${BACKUP_DIR}"
    mkdir -p "${BACKUP_DIR}"
  fi

  docker stop "${DOCKER_CONTAINER}"

  rsync -a --delete \
    "${SOURCE_DIR}/" \
    --link-dest "${LATEST_LINK}" \
    "${BACKUP_PATH}"

  cd "${BACKUP_PATH}"
  tar -czf "${BACKUP_PATH}.tar.gz" .
  cd -

  rm -rf "${BACKUP_PATH}"

  if [ -d "${LATEST_LINK}" ]; then
    rm -rf "${LATEST_LINK}"
  fi

  ln -s "${BACKUP_PATH}.tar.gz" "${LATEST_LINK}"

  docker start "${DOCKER_CONTAINER}"

  if [ ! $i -eq $((len-1)) ]; then
    echo ''
    echo '===================================='
    echo ''
  fi

done