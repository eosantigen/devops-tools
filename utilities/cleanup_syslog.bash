#!/bin/bash

# Log housekeeping. Removes logs older than the current month.
# Set to cron to be executed once every two months.
# /etc/cron.d/webroot_apps_log_remover
# min hour day month 		weekday
# 0   0	   30  1,3,5,7,9,11 *

find /srv/www/*/log -type f -not -name "*.log.$(date +%Y)-$(date +%m)" -exec rm {} \;
