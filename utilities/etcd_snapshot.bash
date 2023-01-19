#!/usr/bin/env bash

PROGNAME=`basename $0`
LOGGER=$(which logger)

ssh_user=""
ssh_opts="-o StrictHostKeyChecking=no"
etcd_snapshot_storage_server=""
etcd_server="" # this is a tricky. If a RancherOS VM gets restarted, it will lose the ${ssh_user}, hence the commands will fail!
email_server=""
email_server_user=""
etcd_snapshot_name="etcd_snapshot_$(date +%d_%m_%Y)"
etcd_snapshot_directory_container=""
etcd_snapshot_directory_storage_server=""
email_to=""
email_message_subject="${PROGNAME}"
email_message_failure="Something failed with the etcd snapshot transfer to backup location."
email_message_success="Etcd snapshot export transferred successfuly under ${etcd_snapshot_directory_storage_server} on ${etcd_snapshot_storage_server}."

preflight_check() {

  echo "Ensure snapshot destination directory exists on ${etcd_snapshot_storage_server}..."
  if [ -d ${etcd_snapshot_directory_storage_server} ]; then
    echo "${etcd_snapshot_directory_storage_server} exists. Proceeding."
  else
    echo "Cloud storage backup location is not mounted on ${etcd_snapshot_directory_storage_server} - please check the mounts. Exiting." && exit 1
  fi
}

command_etcd() {

  echo "Running: etcdctl snapshot save..."
  ssh -i $HOME/.ssh/${ssh_user} ${ssh_opts} ${ssh_user}@${etcd_server} docker exec etcd etcdctl snapshot save ${etcd_snapshot_directory_container}/${etcd_snapshot_name}

  echo "Running: etcdctl --write-out=table snapshot status..."
  ssh -i $HOME/.ssh/${ssh_user} ${ssh_opts} ${ssh_user}@${etcd_server} docker exec etcd etcdctl --write-out=table snapshot status ${etcd_snapshot_directory_container}/${etcd_snapshot_name}

  echo "Running: Copy snapshot out of the etcd container into the host..."
  ssh -i $HOME/.ssh/${ssh_user} ${ssh_opts} ${ssh_user}@${etcd_server} docker cp etcd:${etcd_snapshot_directory_container}/${etcd_snapshot_name} ${etcd_snapshot_directory_container}/${etcd_snapshot_name}

  echo "Running: Delete snapshot from the etcd container..."
  ssh -i $HOME/.ssh/${ssh_user} ${ssh_opts} ${ssh_user}@${etcd_server} docker exec etcd rm ${etcd_snapshot_directory_container}/${etcd_snapshot_name}
}

transfer_etcd_snapshot() {

  echo "Running: Transfer etcd snapshot from etcd host to backup location..."
  rsync --verbose --human-readable --progress -e "ssh -i $HOME/.ssh/${ssh_user} -o StrictHostKeyChecking=no" ${ssh_user}@${etcd_server}:${etcd_snapshot_directory_container}/${etcd_snapshot_name} ${etcd_snapshot_directory_storage_server}/${etcd_snapshot_name}
}

cleanup() {

  echo "Cleaning up..."
  ssh -i $HOME/.ssh/${ssh_user} ${ssh_opts} ${ssh_user}@${etcd_server} rm ${etcd_snapshot_directory_container}/${etcd_snapshot_name}
}

email_result() {

  echo "Running: Sending email with the result..."
  ssh -i $HOME/.ssh/${email_server_user} ${ssh_opts} ${email_server_user}@${email_server} "echo -e 'Subject: ${email_message_subject}' '\n$@' | sendmail ${email_to}"
  if [ $? -ne 0 ]; then
    echo "An error occurred on attempt to send email." && exit 1
  else
    echo "Email sent to ${email_to}"
  fi
}

${LOGGER} -si -t ${PROGNAME} [info] called at `date -u`

preflight_check
command_etcd
transfer_etcd_snapshot
cleanup

# If the snapshot transfer was completed, send email accordingly.

if [ $? -ne 0 ]; then
  email_result ${email_message_failure}
else
  email_result ${email_message_success}
fi