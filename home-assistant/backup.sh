#!/bin/bash
readonly SOURCE_DIR="/opt/home-assistant"
readonly BACKUP_DIR="/mnt/backup/home-assistant"
readonly BACKUP_PATH="${BACKUP_DIR}/$(date '+%F')"
readonly LATEST_LINK="${BACKUP_DIR}/latest"

if [ ! -d "${BACKUP_DIR}" ]; then
  echo "${BACKUP_DIR} does not exist. Creating ${BACKUP_DIR}"
  mkdir -p "${BACKUP_DIR}"
fi

docker stop home-assistant

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

docker start home-assistant
