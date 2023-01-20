#!/usr/bin/env bash

# pg_dump details
db_user="$1"
export PGPASSWORD="$2" # you need "export" because we don't use a hardcoded bash full path, and it goes through env (which is like opening a parent shell for this execution)...
db_host=""
db_port=""
# db_list=(mydb1 mydb2)
db_dump_location="/mnt/backup/devkube/db"

# Notification details
PROGNAME=`basename $0`
email_server=""
email_server_user=""
email_to=""
email_message_subject="${PROGNAME}"
email_message_failure="Failure."
email_message_success="Success."

preflight_check() {

  echo "Ensure pg_dump destination directory exists..."
  if [ -d ${db_dump_location} ]; then
    echo "${db_dump_location} exists. Proceeding.";
  else
    echo "Cloud storage backup location is not mounted - please check the mounts. Exiting for safety reasons." && exit 1
  fi
}

email_result() {

  echo "Running: Sending email with the result..."
  ssh -i $HOME/.ssh/${email_server_user} ${ssh_opts} ${email_server_user}@${email_server} "echo -e 'Subject: ${email_message_subject}' '\n$@' | sendmail ${email_to}"
  if [ $? -ne 0 ]; then
    echo "An error occurred on attempt to send email."
  else
    echo "Email sent to ${email_to}."
fi
}

preflight_check

# pg_dump cannot work inside a function, it results in recursion, and segmentation.

# for db in "${db_list[@]}"; do
#   echo ${db}
pg_dumpall -w -U ${db_user} -h ${db_host} -p ${db_port} -f ${db_dump_location}/$(date +%Y_%m_%d).sql
# done

# Email result.

if [ $? -ne 0 ]; then
  email_result ${email_message_failure}
else
  email_result ${email_message_success}
fi
