#!/bin/bash

function mysqlinstall {
	sudo rm -rf /home/"$user"/sql
	cd /home/"$user"
	yum -y install unzip
	sudo unzip /home/"$user"/sql.zip    
	dockerinstall
	sudo docker pull mysql/mysql-server:5.6
	sudo docker run --network host --restart=always -e MYSQL_ROOT_PASSWORD='root' --name=mysql1 -d mysql/mysql-server:5.6
	sudo docker exec -i mysql1 bash < /home/"$user"/sql/mycnf.sh
	sleep 120
	containerid=$(sudo docker ps | grep mysql/mysql-server:5.6  | awk '{print $1}')
	imageid=$(sudo docker images  | grep mysql/mysql-server:5.6  | awk '{print $3}')
	if [[ -z "$containerid" ]]; then
		echo "mysql install false"
	else	    
	    cd /home/"$user"/sql
	    sudo docker exec -i mysql1 mysql -u root --password='root' < ddl.sql
	    sudo docker exec -i mysql1 mysql -u root --password='root' < dml.sql
	    sleep 20
	    sudo docker restart mysql1
	fi
}

function dockerinstall {
	cd /home/download
	sudo rpm -ivh docker-ce-selinux-17.03.0.ce-1.el7.centos.noarch.rpm
	sudo rpm -ivh docker-ce-17.03.0.ce-1.el7.centos.x86_64.rpm
	sudo yum -y install docker
	sudo systemctl enable docker
	sudo systemctl start docker
}


function remove {
	containerid=$(sudo docker ps -a  | grep mysql-server  | awk '{print $1}')
	imageid=$(sudo docker images  | grep mysql/mysql-server  | awk '{print $3}')
	echo $containerid
	echo $imageid
	if [[ -z "$containerid" ]]; then
		echo "empty"
	else
		echo "not empty"
		sudo docker stop $containerid
		sudo docker rm $containerid
	fi
	if [[ -z "$imageid" ]]; then
		echo "empty"
	else
		echo "not empty"
		sudo docker rmi $imageid
	fi
	sudo systemctl stop docker
	sudo yum -y remove docker
	sudo rpm -e docker-ce-17.03.0.ce-1.el7.centos.x86_64.rpm
	sudo rpm -e docker-ce-selinux-17.03.0.ce-1.el7.centos.noarch
}

while echo $1 | grep -q ^-; do
    eval $( echo $1 | sed 's/^-//' )=$2
    shift
    shift
done

echo user = $user
remove
mysqlinstall

