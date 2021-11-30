#!/bin/bash
function deploydocker {
containerid=$(docker ps | grep mcweb  | awk '{print $1}')
imageid=$(docker images  | grep mcweb  | awk '{print $3}')
if [ -z "$containerid" ]; then
    echo "NOTTHING TO KILLED"
    cd /opt/DockerMC
    sudo su -c "docker-compose up -d"
else
    echo "${containerid}"
    echo "${imageid}" 
    sudo su -c "docker stop $containerid"
    sudo su -c "docker rm $containerid"
    sudo su -c "docker rmi -f $imageid"
    cd /opt/DockerMC
    sudo su -c "docker-compose up -d"
fi
}
deploydocker





