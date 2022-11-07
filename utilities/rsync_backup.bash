#!/bin/bash

# Added as cronjob to sync VM snapshots of VMs exported from Proxmox to cloud-storage and keep it clean at the same time :
# - the Domain Controller (DC)
# - ...more to be added....

PROG_NAME=`basename $0`
SNAPSHOT_PATH="/mnt/pool/backup/dump"
SNAPSHOT_PREFIX__DC="vzdump-qemu-105"
SNAPSHOT_ITEMS__DC="7"


rsync_snapshot_dc() {

  find ${SNAPSHOT_PATH} -type f -name "${SNAPSHOT_PREFIX__DC}-$(date +%Y)_$(date +%m)_*.vma.lzo" | tail -n ${SNAPSHOT_ITEMS__DC} | sort > file_list.txt

  basename -s ${SNAPSHOT_PATH} $(cat file_list.txt) > file_list.txt

  rsync --human-readable --verbose --recursive --delete-before --compress --progress --files-from=file_list.txt -e "ssh -i /root/backup.key -o StrictHostKeyChecking=no" ${SNAPSHOT_PATH} rancher@rancher.devanet:/mnt/backup/dc

}


rsync_snapshot_dc

if [[ $? -ne 0 ]]; then
  echo -e "Subject: [Error] - Tethys Cronjob - ${PROG_NAME}" "\nAn issue with the backup of the DC1 VM - please check storage and settings." | sendmail eos.antigen@gmail.com
  exit 1
else
  echo -e "Subject: [Info] - Tethys Cronjob - ${PROG_NAME}" "\n`tail -n ${SNAPSHOT_ITEMS__DC} ${SNAPSHOT_PATH}/${SNAPSHOT_PREFIX__DC}-$(date +%Y)_$(date +%m)_*.log`" | sendmail eos.antigen@gmail.com
  exit 0
fi