#!/bin/bash

#************************ATTENTION*************************
# Please step the revision number when the script is updated
# [RevNo]	[date]	[username]	[notes]
# Output logs can be found at: /var/log/syslog
# Script location: /usr/local/bin/cleanup

PROGNAME=`basename $0`
REVISION=R2A01

LOGGER_BIN=$(which logger)

JENKINS_HOME=/var/lib/jenkins
JENKINS_WORKSPACE=$JENKINS_HOME/workspace

# log script execution
$LOGGER_BIN -si -t $PROGNAME [info] called at `date -u`

# Remove all images AND those dangling, EXCEPT certain
docker image ls --format "{{.Repository}}:{{.Tag}} {{.ID}}" | grep -Ev "openjdk|node|pybase|zabbix" | xargs docker rmi
docker image ls --format "{{.Repository}}:{{.Tag}}" | grep -E "pybase:full|pybase:slim" | tail -n +4 | xargs docker rmi
docker rmi $(docker images --filter "dangling=true" -q --no-trunc ) -f
docker image prune -f
docker system prune -f
docker volume prune -f

$LOGGER_BIN -si -t $PROGNAME [info] "All images deleted"

# clean workspace
$LOGGER_BIN -si -t $PROGNAME [info] "Cleaning workspace"

# if jenkins workspace exists
if [ -d $JENKINS_WORKSPACE ]; then

    # go to jenkins workspace
    cd $JENKINS_WORKSPACE

    # delete any folder except maven-repo
    for dir in ./*; do
        if [ -d $dir ]; then
           if [ $dir != "./maven-repo"] && [ $dir != "./maven-repo@tmp" ] && [ $dir != "./pylib-repo" ]; then
              sudo rm -rf $dir
              $LOGGER_BIN -si -t $PROGNAME  "[delete]       $dir"
           fi
        fi
    done

    # return
    cd - > /dev/null
fi

$LOGGER_BIN -si -t $PROGNAME [info] "Workspace folder is cleared"

# log script completion
$LOGGER_BIN -si -t $PROGNAME [info] exiting at `date -u`
