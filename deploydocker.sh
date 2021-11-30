#!/bin/bash

while echo $1 | grep -q ^-; do
    eval $( echo $1 | sed 's/^-//' )=$2
    shift
    shift
done
echo dockername=${dockername}
echo setting=${setting}

function deploydocker {
containerid=$(docker ps | grep ${dockername}  | awk '{print $1}')
imageid=$(docker images  | grep ${dockername}  | awk '{print $3}')
if [ -z "$containerid" ]; then
    echo "NOTTHING TO KILLED"
    sudo rm -rf /opt/${module}/${module}/config/${setting}
	sudo rm -rf /opt/${module}/${module}/config/application.yml	
    sudo yes | cp -f /home/"$user"/${module}/${setting} /opt/${module}/${module}/config/
	sudo mv /opt/${module}/${module}/config/${setting} /opt/${module}/${module}/config/application.yml
    cd /opt/${module}/${module}
    sudo su -c "docker-compose up -d"
else
    echo "${containerid}"
    echo "${imageid}" 
    sudo rm -rf /opt/${module}/${module}/config/${setting}
	sudo rm -rf /opt/${module}/${module}/config/application.yml	
    sudo yes | cp -f /home/"$user"/${module}/${setting} /opt/${module}/${module}/config/
	sudo mv /opt/${module}/${module}/config/${setting} /opt/${module}/${module}/config/application.yml	
    sudo su -c "docker stop $containerid"
    sudo su -c "docker rm $containerid"
    sudo su -c "docker rmi -f $imageid"
    cd /opt/${module}/${module}
    sudo su -c "docker-compose up -d"
fi
}

deploydocker





