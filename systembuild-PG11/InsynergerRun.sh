#!/bin/bash

#################version:relpaceme###########################################

function installsystem() {
   echo "install private system "
   echo project=$1
   sudo /home/$user/./systeminstall.sh -user $user -project $1 -env $env -sta $2
}

function installsystemAT {
   echo "install AT system"
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


function staenv() {
   echo "env=STA"
   setuser
   sudo su -c 'sed -i "/\b\(currentdb\)\b/d" /etc/hosts'
   echo "127.0.0.1    currentdb" >> /etc/hosts
   getiotpackage $1
   setvisudo
   mvscriptsetsshkey
   unzipfile
   localRpm
   case $1 in
      "at" ) installmysql; installsystemAT; remoteinstall; startmodule $1;;
      "inpark" ) installpostgresql; installsystem $1 "sta"; remoteinstall; startmodule $1;;
      "infactory" ) installpostgresql; installsystem $1 "sta"; remoteinstall; startmodule $1;;
      * ) echo "project input error.";;
   esac
}

function vm1env() {
   echo "env=VM1"
   setuser
   sudo su -c 'sed -i "/\b\(currentdb\)\b/d" /etc/hosts'
   echo "$dbip    currentdb" >> /etc/hosts
   getiotpackage $1
   setvisudo
   mvscriptsetsshkey
   unzipfile
   installsystem $1 "notsta"
   remoteinstall
   startmodule $1
}

function vm2env() {
   echo "env=VM2"
   setuser
   sudo su -c 'sed -i "/\b\(currentdb\)\b/d" /etc/hosts'
   echo "$dbip    currentdb" >> /etc/hosts
   getiotpackage $1
   setvisudo
   mvscriptsetsshkey
   unzipfile
   case $1 in
      "at" ) installmysql;;
      "inpark" ) installpostgresql;;
      "infactory" ) installpostgresql;;
      * ) echo "project input error.";;
   esac
}

function startmodule() {
   echo "starting module"
   sudo /home/$user/./startmodule.sh -product $1 
}

function mvscriptsetsshkey {
   sudo rm -rf /home/$user/*.sh
   sudo rm -rf /home/$user/*.zip
   sudo yes | cp -f /mnt/usb/*.sh   /home/$user
   sudo yes | cp -f /mnt/usb/*.zip  /home/$user
   sudo yes | cp -f /mnt/usb/*.rpm  /home/$user
   sudo chown $user:$user /home/$user/*.sh
   sudo chmod +x /home/$user/*.sh
   sudo /home/$user/./setsshkey.sh -u $user
}

function getiotpackage() {
   sudo yum -y install unzip
   sudo rm -rf /mnt/usb
   sudo mkdir -p /mnt/usb
   cd /mnt/usb
   if [ $1 == "at" ]
   then
      checkNewFtpUrl "at/iotpackage.zip"
      sudo /bin/curl -O -u download:vu84y9352883637 ftp://download.insynerger.com:2100/productfile/at/iotpackage.zip
   else
      checkNewFtpUrl "relpaceme/iotpackage.zip"
	  sudo /bin/curl -O -u download:vu84y9352883637 ftp://download.insynerger.com:2100/productfile/relpaceme/iotpackage.zip
   fi   
   sudo unzip iotpackage.zip
   sudo mv iotpackage/* .
   sudo rm -rf iotpackage
}

function checkNewFtpUrl() {
curl -I --silent -u download:vu84y9352883637 ftp://download.insynerger.com:2100/productfile/$1 >/dev/null
if [ $? -eq 0 ]
then
    echo "exist"
else 
    echo "ftp://download.insynerger.com:2100/productfile/$1 notexist"
	exit 1
fi
}

function setvisudo {
   sudo rm -rf /etc/sudoers.d/waagent
   sudo yes | cp -f /mnt/usb/waagent /etc/sudoers.d/
   cd /etc/sudoers.d
   sudo chown root:root waagent
   sudo chmod 440 waagent
}

function setuser {
   if [ -d "/home/$user"  ];
   then
     echo "user already add"
   else
     sudo useradd vmadmin
   fi
}

function localRpm {
	sudo yes | cp -f /mnt/usb/download.tar.gz /home
	cd /home
	sudo rm -rf download
	sudo tar xzf download.tar.gz
}

function unzipfile {   
   sudo rm -rf /home/"$user"/systembuild
   cd /home/"$user"
   sudo unzip /home/"$user"/systembuild.zip
}

function remoteinstall {
    sudo yum -y install wget
	sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    sudo yum -y install xrdp tigervnc-server --skip-broken
	sudo systemctl enable xrdp	
	sudo systemctl start xrdp
	sudo firewall-cmd --permanent --add-port=3389/tcp
	sudo firewall-cmd --reload
	sudo rm -rf anydesk-2.9.5-1.el7.x86_64.rpm
	sudo wget https://download.anydesk.com/linux/rhel7/anydesk-2.9.5-1.el7.x86_64.rpm
	sudo yum -y localinstall anydesk-2.9.5-1.el7.x86_64.rpm
}

function checkVM() {
while true; do
    read -p "Is this VM install for DataBase?   " yn
    case $yn in
        [Yy]* ) vm2env $1; break;;
        [Nn]* ) vm1env $1; break;;
        * ) echo "Please answer y or n.";;
    esac
done
}

function getdbip() {
    read -p "Please input the DataBase IPadress:   " dbip
    dbip=$dbip
	checkVM $1
}

function checkStandAlone() {
while true; do
    read -p "Is this Project install for StandAlone?   " yn
    case $yn in
        [Yy]* ) staenv $1;   break;;
        [Nn]* ) getdbip $1;  break;;
        * ) echo "Please answer y or n.";;
    esac
done
}

function getProduct {
while true; do
    read -p "Which product do you choose? [inpark/infactory/at]   " product 
    case $product in
        "inpark" ) echo $product; checkStandAlone $product;  break;;
        "infactory" ) echo $product; checkStandAlone $product;  break;;
		"at" ) echo $product; staenv $product;  break;;
        * ) echo "Please answer inpark or infactory or at.";;
    esac
done
}




read -p "Please input Administrator user without root :  " user
echo $user
read -p "Please input Env name for this project :  " env
echo $env
getProduct





