### Delete all images but exclude certain tags

`docker image ls --format "{{.Repository}}:{{.Tag}} {{.ID}}" | grep -Ev "openjdk|node|pybase|zabbix" | xargs docker rmi`

### Delete all images but exclude certain tags and keep last 4

`docker image ls --format "{{.Repository}}:{{.Tag}}" | grep -E "pybase:full|pybase:slim" | tail -n +4 | xargs docker rmi`

### Check the size of all containers

`du -h $(docker inspect --format='{{.LogPath}}' $(docker ps -qa))`

### Stop and remove all containers except one

`docker ps --format "{{.ID}}" | grep -v 7dd05cf5c760 | xargs docker stop`