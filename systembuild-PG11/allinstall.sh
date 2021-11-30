#!/bin/bash
while echo $1 | grep -q ^-; do
    eval $( echo $1 | sed 's/^-//' )=$2
    shift
    shift
done

function localRpm {
sudo yes | cp -f /mnt/usb/download.tar.gz /home
cd /home
sudo rm -rf download
sudo tar xzf download.tar.gz
}


function installsystem {
echo "install system"
sudo /home/$user/./systeminstall.sh -u $user
}

function installmysql {
echo "installmysql"
sudo /home/$user/./mysqlinstall.sh -user $user
}

function installpostgresql {
echo "install postgresql"
sudo /home/$user/./postgresinstall.sh -user $user
}


function staenv {
echo "env=STA"
setvisudo
mvscriptsetsshkey
unzipfile
if [ $project == "AT" ]
then
    installmysql
    installsystem
    startmodule
elif [ $project == "EC" ]
then
    installpostgresql
    installsystem
    startmodule
elif [ $project == "IL" ]
then
    installpostgresql
    installsystem
    startmodule
else
    echo "project input error"
fi
}

function vm1env {
echo "env=VM1"
setvisudo
mvscriptsetsshkey
unzipfile
installsystem
startmodule
}

function vm2env {
echo "env=VM2"
setvisudo
mvscriptsetsshkey
unzipfile
if [ $project == "AT" ]
then
    installmysql
elif [ $project == "EC" ]
then
    installpostgresql
elif [ $project == "IL" ]
then
    installpostgresql
else
    echo "project input error"
fi
}

function startmodule {
echo "starting module"
sudo /home/$user/./startmodule.sh
} 

function mvscriptsetsshkey {
sudo rm -rf /home/$user/*.sh
sudo rm -rf /home/$user/*.zip
sudo yes | cp -f /mnt/usb/*.sh   /home/$user
sudo yes | cp -f /mnt/usb/*.zip  /home/$user
sudo yes | cp -f /mnt/usb/*.rpm  /home/$user
sudo chown $user:$user /home/$user/*.sh
sudo  chmod +x /home/$user/*.sh
sudo /home/$user/./setsshkey.sh -u $user
}


function setvisudo {
sudo rm -rf /etc/sudoers.d/waagent
sudo yes | cp -f /mnt/usb/waagent /etc/sudoers.d/
cd /etc/sudoers.d
sudo chown root:root waagent
sudo chmod 440 waagent
}

#function setuser {
#if [ -d "/home/$user"  ];
#then
#echo "user already add"
#else
#sudo useradd vmadmin
#fi
#}

function unzipfile {
sudo yum -y install unzip   
sudo rm -rf /home/"$user"/systembuild
cd /home/"$user"
sudo unzip /home/"$user"/systembuild.zip
}

function uninstall()  {
if [ $uninstall=="yes"  ]
then
echo "$1 will be uninstall"

fi
}

function chooseenv {
if [ $env == "STA" ]
then 
staenv
uninstall $env
elif [ $env == "VM1" ]
then
vm1env
uninstall $env
elif [ $env == "VM2" ]
then
vm2env
uninstall $env
else
echo "env input error"
fi
}

function changelocalrepo {
sudo yes | cp -f /mnt/usb/download.tar.gz /home
cd /home
sudo rm -rf download
sudo tar -xzf download.tar.gz
sudo mkdir -p /etc/yum.repos.d/bak
sudo rm -rf /etc/yum.repos.d/localyum.repo
sudo mv /etc/yum.repos.d/CentOS-* /etc/yum.repos.d/bak
sudo mv /etc/yum.repos.d/*.repo  /etc/yum.repos.d/bak
sudo yes | cp -f /mnt/usb/localyum.repo /etc/yum.repos.d/
sudo yum clean all
sudo yum makecache
}

function remove {
	sudo mv /etc/yum.repos.d/bak/* /etc/yum.repos.d
	sudo rm -rf /etc/yum.repos.d/bak
	sudo rm -rf /etc/yum.repos.d/localyum.repo
	sudo rm -rf /home/download*
}



if [ $offline == "yes" ]
then
remove
changelocalrepo
echo "offline=$offline"
chooseenv
elif [ $offline == "no" ]
then
remove
localRpm
chooseenv
echo "offline=$offline"
else
echo "offline input error"
fi


