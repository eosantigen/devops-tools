#!/bin/bash

## DB DETAILS

# DB_USER=""
# DB_PASS=""
# DB_ENVIRONMENT=""

DATABASES=( )
DATE=`date +%d-%m-%y-%H:%M`

for db in "${DATABASES[@]}"
do
    mysqldump --defaults-extra-file=/etc/mysql/debian.cnf "$db" > ${DB_ENVIRONMENT}_${DATE}_"$db".sql
done
