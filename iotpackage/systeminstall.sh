#!/bin/bash

usage="
$(basename "$0") [-h] -- this script will help to setup services.

ex. 
"$0" -j yes -t yes -s yes -h yes

where:
    -j  install java jdk 121
    -t  install tomcat7.56
    -s  install all server
    -h  install httpd
"

default=yes
function javainstall {
	sudo yum -y install vim 
	sudo yum -y install unzip 
	sudo yum -y install zip 
	sudo yum -y install telnet
	cd /home/"$user"
	if [ -d "/home/${user}/systembuild" ]; then
		echo "already unzip"
	else
	cd /home/"$user"
	sudo unzip /home/"$user"/systembuild.zip
	fi
	sudo mv /home/"$user"/systembuild/jdk-8u121-linux-x64.tar.gz /opt
	cd /opt
	sudo tar xzf /opt/jdk-8u121-linux-x64.tar.gz
	sudo alternatives --install /usr/bin/java java /opt/jdk1.8.0_121/bin/java 2
	psax=$(echo -ne '\n' | sudo alternatives --config java | grep open)
	if [ -z "$psax" ]; then
		sudo alternatives --config java 1
		echo "no openjdk"
	else
		sudo alternatives --config java 2
		echo "have openjdk"
	fi
	sudo alternatives --install /usr/bin/jar jar /opt/jdk1.8.0_121/bin/jar 2
	sudo alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_121/bin/javac 2
	sudo alternatives --set jar /opt/jdk1.8.0_121/bin/jar
	sudo alternatives --set javac /opt/jdk1.8.0_121/bin/javac
	sudo yes | cp -f /home/"$user"/systembuild/profile/.bash_profile /root/
	sudo su -c " chmod 644 /root/.bash_profile"
	sudo su -c "source /root/.bash_profile"
	sudo java -version
}


function tomcatinstall {
	sudo mv /home/"$user"/systembuild/Tomcat.zip /opt
	cd /opt
	sudo rm -rf /opt/Tomcat
	sudo unzip /opt/Tomcat.zip
	sudo chmod +x /opt/Tomcat/tomcatAUTH/start-enable/*.sh
	sudo chmod +x /opt/Tomcat/tomcatEC/start-enable/*.sh
	sudo chmod +x /opt/Tomcat/tomcatECBJ/start-enable/*.sh
	sudo chmod +x /opt/Tomcat/tomcatQUARTZ/start-enable/*.sh
	sudo chmod +x /opt/Tomcat/tomcatISAS/start-enable/*.sh
	sudo chmod +x /opt/Tomcat/tomcatIFAS/start-enable/*.sh
	sudo chmod +x /opt/Tomcat/tomcatINLIGHT/start-enable/*.sh
	sudo chmod +x /opt/Tomcat/tomcatOBSIDIAN/start-enable/*.sh
	sudo chmod +x /opt/Tomcat/tomcatAUTH/bin/*.sh
	sudo chmod +x /opt/Tomcat/tomcatEC/bin/*.sh
	sudo chmod +x /opt/Tomcat/tomcatECBJ/bin/*.sh
	sudo chmod +x /opt/Tomcat/tomcatQUARTZ/bin/*.sh
	sudo chmod +x /opt/Tomcat/tomcatISAS/bin/*.sh
	sudo chmod +x /opt/Tomcat/tomcatIFAS/bin/*.sh
	sudo chmod +x /opt/Tomcat/tomcatINLIGHT/bin/*.sh
	sudo chmod +x /opt/StatisticService/tomcat/bin/*.sh
	sudo /opt/Tomcat/tomcatAUTH/start-enable/./install.sh
	sudo /opt/Tomcat/tomcatEC/start-enable/./install.sh
	sudo /opt/Tomcat/tomcatECBJ/start-enable/./install.sh
	sudo /opt/Tomcat/tomcatQUARTZ/start-enable/./install.sh
	sudo /opt/Tomcat/tomcatISAS/start-enable/./install.sh
	sudo /opt/Tomcat/tomcatIFAS/start-enable/./install.sh
	sudo /opt/Tomcat/tomcatINLIGHT/start-enable/./install.sh
	sudo mv /home/"$user"/systembuild/appdata.zip /opt
	sudo unzip /opt/appdata.zip
}





function serverinstall {
	sudo mv /home/"$user"/systembuild/server.zip /opt
	sudo cp /home/"$user"/systembuild/prometheus.zip /opt
	cd /opt
	sudo unzip /opt/server.zip
	sudo mv /opt/server/CServer /opt
	sudo mv /opt/server/CSfile  /opt
	sudo mv /opt/server/GEE /opt
	sudo mv /opt/server/INLIGHT /opt
	sudo mv /opt/server/CHART /opt
	sudo mv /opt/server/EDGE /opt
	sudo mv /opt/server/EC /opt
	sudo mv /opt/server/NS /opt
	sudo mv /opt/server/INEMS /opt
	sudo mv /opt/server/StatisticService /opt
	sudo mv /opt/server/StatisticCacheService /opt
	sudo chmod +x /opt/GEE/start-enable/*.sh
	sudo chmod +x /opt/GEE/GEE/GeeServer/*.sh
	sudo chmod +x /opt/INLIGHT/start-enable/*.sh
	sudo chmod +x /opt/INLIGHT/*.sh
	sudo chmod +x /opt/CHART/start-enable/*.sh
	sudo chmod +x /opt/CHART/*.sh
	sudo chmod +x /opt/EDGE/start-enable/*.sh
	sudo chmod +x /opt/EDGE/*.sh
	sudo chmod +x /opt/INEMS/start-enable/*.sh
	sudo chmod +x /opt/INEMS/INEMS/*.sh
	sudo chmod +x /opt/StatisticService/start-enable/*.sh
	sudo chmod +x /opt/StatisticService/StatisticService/*.sh
	sudo chmod +x /opt/StatisticCacheService/start-enable/*.sh
	sudo chmod +x /opt/StatisticCacheService/StatisticCacheService/*.sh
	sudo chmod +x /opt/CServer/CServer/cserver_service/*.sh
	sudo chmod +x /opt/CServer/CServer/*.sh
	sudo chmod +x /opt/NS/start-enable/*.sh
	sudo chmod +x /opt/NS/NS_current/*.sh
	sudo chmod +x /opt/INLIGHT/*.sh
	sudo /opt/GEE/start-enable/./install.sh
	sudo /opt/INLIGHT/start-enable/./install.sh
	sudo /opt/CHART/start-enable/./install.sh
	sudo /opt/EDGE/start-enable/./install.sh
	sudo /opt/EC/start-enable/./install.sh
	sudo /opt/NS/start-enable/./install.sh
	sudo /opt/INEMS/start-enable/./install.sh
	sudo /opt/StatisticService/start-enable/./install.sh
	sudo /opt/StatisticCacheService/start-enable/./install.sh
	sudo /opt/CServer/CServer/cserver_service/./install.sh
	sudo unzip /opt/prometheus.zip
	sudo chmod +x /opt/prometheus/*.sh
	sudo chmod +x /opt/prometheus/node_exporter-0.15.2.linux-amd64/start-enable/*.sh
	sudo chmod +x /opt/prometheus/node_exporter-0.15.2.linux-amd64/node_exporter
	sudo /opt/prometheus/node_exporter-0.15.2.linux-amd64/start-enable/./install.sh
	sudo chmod 644 /usr/lib/systemd/system/*cserver.service
	sudo chmod 644 /usr/lib/systemd/system/*gee.service
	sudo chmod 644 /usr/lib/systemd/system/*nserver.service
	sudo chmod 644 /usr/lib/systemd/system/*auth.service
	sudo chmod 644 /usr/lib/systemd/system/*ec.service
	sudo chmod 644 /usr/lib/systemd/system/*ecbj.service
	sudo chmod 644 /usr/lib/systemd/system/*quartz.service
	sudo chmod 644 /usr/lib/systemd/system/*isas.service
	sudo chmod 644 /usr/lib/systemd/system/*if3.service
	sudo chmod 644 /usr/lib/systemd/system/*inlight.service
	sudo chmod 644 /usr/lib/systemd/system/*chart.service
	sudo chmod 644 /usr/lib/systemd/system/*edge.service
	sudo chmod 644 /usr/lib/systemd/system/*obsidian.service
	sudo chmod 644 /usr/lib/systemd/system/*inems.service
	sudo chmod 644 /usr/lib/systemd/system/*statistic.service
	sudo chmod 644 /usr/lib/systemd/system/*statistic-cache.service
	sudo chmod 644 /usr/lib/systemd/system/*node.service
	LIST=`crontab -l`
	SOURCE="/opt/prometheus/cron.sh > /dev/null"
	SOURCE1="(/usr/sbin/ntpdate pool.ntp.org;/usr/sbin/hwclock -w)"
	if echo "$LIST" | grep -q "$SOURCE"; then
	echo "The back job had been added.";
	else
	sudo crontab -l | { cat; echo "*/59 * * * * $SOURCE"; } | crontab -
	fi
	if echo "$LIST" | grep -q "$SOURCE1"; then
	echo "The back job had been added.";
	else
	sudo crontab -l | { cat; echo "0 * * * * $SOURCE1"; } | crontab -
	fi
}

function httpdinstall {
	sudo yum -y install httpd php
	sudo yum -y install nc
	sudo systemctl enable httpd
	sudo yum -y install mod_ssl openssl 
	cd /home/"$user"/systembuild/
	sudo unzip /home/"$user"/systembuild/ssl_key.zip
	sudo mv /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd_bk.conf
	sudo mv /home/"$user"/systembuild/ssl_key/httpd.conf /etc/httpd/conf/
	sudo mv /home/"$user"/systembuild/ssl_key/Des_Private_InSnergy_License.pem /etc/httpd/conf/
	sudo mv /home/"$user"/systembuild/ssl_key/InSnergy_License.crt /etc/httpd/conf/
	sudo mv /home/"$user"/systembuild/ssl_key/Public_InSnergy_License.pem /etc/httpd/conf/
	sudo mv /home/"$user"/systembuild/ssl_key/mod_jk.so /etc/httpd/modules
	sudo chmod +x /etc/httpd/modules/mod_jk.so
	sudo systemctl start httpd
	echo "complete install"
}

function firewalld {
	sudo systemctl start firewalld
	sudo systemctl enable firewalld
	sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=443/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=8444/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=8446/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=8445/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=8447/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=8500/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=8085/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=9080/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=8307/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=9900/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=9901/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=9906/tcp --permanent
	sudo firewall-cmd --reload
	echo "complete install"
}

function removeall {
	sudo systemctl start stop-auth
	sudo systemctl start stop-isas
	sudo systemctl start stop-ec
	sudo systemctl start stop-ecbj
	sudo systemctl start stop-quartz
	sudo systemctl start stop-if3
	sudo systemctl start stop-inlight
	sudo systemctl start stop_gee
	sudo systemctl start stop_cserver
	sudo systemctl start stop_nserver
	sudo systemctl start stop_chart
	sudo systemctl start stop_edge
	sudo systemctl start stop-obsidian
	sudo systemctl start stop_inems
	sudo systemctl start stop_inpark	
	sudo systemctl start stop-statistic
	sudo systemctl start stop-statistic-cache
	sudo systemctl start stop_infactory-backend	
	sudo systemctl start stop_ica	
	sudo systemctl start stop_AuthCenter
	sudo systemctl start stop-infactory-frontend
	sudo systemctl disable start_chart.service
	sudo systemctl disable start_edge.service
	sudo systemctl disable start-auth.service
	sudo systemctl disable start_cserver.service
	sudo systemctl disable start-ecbj.service
	sudo systemctl disable start-ec.service
	sudo systemctl disable start_gee.service
	sudo systemctl disable start-isas.service
	sudo systemctl disable start-if3.service
	sudo systemctl disable start-inlight.service
	sudo systemctl disable start_nserver.service
	sudo systemctl disable start-quartz.service
	sudo systemctl disable start-obsidian.service
	sudo systemctl disable start_inems.service
	sudo systemctl disable start_inpark.service	
	sudo systemctl disable start-statistic.service
	sudo systemctl disable start-statistic-cache.service
	sudo systemctl disable start_infactory-backend.service	
	sudo systemctl disable start_ica.service	
    sudo systemctl disable start-infactory-frontend.service	
	sudo systemctl disable start_AuthCenter.service
	sudo systemctl disable stop-auth.service
	sudo systemctl disable stop_cserver.service
	sudo systemctl disable stop-ecbj.service
	sudo systemctl disable stop-ec.service
	sudo systemctl disable stop-isas.service
	sudo systemctl disable stop-quartz.service
	sudo systemctl disable stop-if3.service
	sudo systemctl disable stop-inlight.service
	sudo systemctl disable stop_gee.service
	sudo systemctl disable stop_nserver.service
	sudo systemctl disable stop_chart.service
	sudo systemctl disable stop_edge.service
	sudo systemctl disable stop-obsidian.service
	sudo systemctl disable stop_inems.service
	sudo systemctl disable stop_inpark.service	
	sudo systemctl disable stop-statistic.service
	sudo systemctl disable stop-statistic-cache.service
	sudo systemctl disable stop-infactory-backend.service	
	sudo systemctl disable stop-ica.service	
	sudo systemctl disable start_node.service
    sudo systemctl disable stop-infactory-frontend.service	
	sudo systemctl disable stop_AuthCenter.service	
	sudo rm -rf /usr/lib/systemd/system/start-auth.service
	sudo rm -rf /usr/lib/systemd/system/start_cserver.service
	sudo rm -rf /usr/lib/systemd/system/start-ecbj.service
	sudo rm -rf /usr/lib/systemd/system/start-ec.service
	sudo rm -rf /usr/lib/systemd/system/start_gee.service
	sudo rm -rf /usr/lib/systemd/system/start-if3.service
	sudo rm -rf /usr/lib/systemd/system/start-inlight.service
	sudo rm -rf /usr/lib/systemd/system/start-isas.service
	sudo rm -rf /usr/lib/systemd/system/start_nserver.service
	sudo rm -rf /usr/lib/systemd/system/start-quartz.service
	sudo rm -rf /usr/lib/systemd/system/start_chart.service
	sudo rm -rf /usr/lib/systemd/system/start_edge.service
	sudo rm -rf /usr/lib/systemd/system/start-obsidian.service
	sudo rm -rf /usr/lib/systemd/system/start_inems.service
	sudo rm -rf /usr/lib/systemd/system/start_inpark.service	
	sudo rm -rf /usr/lib/systemd/system/start-statistic.service
	sudo rm -rf /usr/lib/systemd/system/start-statistic-cache.service
	sudo rm -rf /usr/lib/systemd/system/start_infactory-backend.service	
	sudo rm -rf /usr/lib/systemd/system/start_ica.service	
	sudo rm -rf /usr/lib/systemd/system/start-infactory-frontend.service	
	sudo rm -rf /usr/lib/systemd/system/start_AuthCenter.service	
	sudo rm -rf /usr/lib/systemd/system/stop_nserver.service
	sudo rm -rf /usr/lib/systemd/system/stop_gee.service
	sudo rm -rf /usr/lib/systemd/system/stop-auth.service
	sudo rm -rf /usr/lib/systemd/system/stop_cserver.service
	sudo rm -rf /usr/lib/systemd/system/stop-ecbj.service
	sudo rm -rf /usr/lib/systemd/system/stop-ec.service
	sudo rm -rf /usr/lib/systemd/system/stop-if3.service
	sudo rm -rf /usr/lib/systemd/system/stop-isas.service
	sudo rm -rf /usr/lib/systemd/system/stop-quartz.service
	sudo rm -rf /usr/lib/systemd/system/stop-inlight.service
	sudo rm -rf /usr/lib/systemd/system/stop_chart.service
	sudo rm -rf /usr/lib/systemd/system/stop_edge.service
	sudo rm -rf /usr/lib/systemd/system/stop-obsidian.service
	sudo rm -rf /usr/lib/systemd/system/stop_inems.service
	sudo rm -rf /usr/lib/systemd/system/stop_inpark.service	
	sudo rm -rf /usr/lib/systemd/system/stop-statistic.service
	sudo rm -rf /usr/lib/systemd/system/stop-statistic-cache.service
	sudo rm -rf /usr/lib/systemd/system/stop_infactory-backend.service	
	sudo rm -rf /usr/lib/systemd/system/stop_ica.service	
	sudo rm -rf /usr/lib/systemd/system/stop-infactory-frontend.service	
	sudo rm -rf /usr/lib/systemd/system/stop_AuthCenter.service	
	sudo rm -rf /usr/lib/systemd/system/start_node.service
	sudo yum -y remove  httpd php
	sudo yum -y remove  mod_ssl
	sudo rm -rf /etc/httpd
	sudo rm -rf /opt/Tomcat
	sudo rm -rf /opt/server
	sudo rm -rf /opt/NS/
	sudo rm -rf /opt/GEE
	sudo rm -rf /opt/EC
	sudo rm -rf /opt/EDGE
	sudo rm -rf /opt/CHART
	sudo rm -rf /opt/INLIGHT
	sudo rm -rf /opt/CServer/
	sudo rm -rf /opt/CSfile/
	sudo rm -rf /opt/StatisticService/
	sudo rm -rf /opt/StatisticCacheService/
	sudo rm -rf /opt/INFACTORY-BACKEND/	
	sudo rm -rf /opt/INEMS/
	sudo rm -rf /opt/INPARK/	
	sudo rm -rf /opt/AUTHCENTER/
	sudo rm -rf /opt/ICA/	
	sudo rm -rf /opt/appdata/
	sudo rm -rf /opt/ssl_key/
	sudo rm -rf /home/"$user"/systembuild
	sudo rm -rf /opt/*zip
	sudo rm -rf /opt/*tar.gz
	sudo rm -rf /opt/prometheus
	sudo rm -rf /opt/BAK
sudo echo "delete all of server & Tomcat & appdata & httpd"
}



while getopts ':u:j:t:s:h:r:f:' option; 
do
  default=no
  case "$option" in
   u) user=$OPTARG
       echo "user" 
       removeall
       javainstall
       tomcatinstall
       serverinstall
       firewalld
       ;;
   j) jdk=$OPTARG
       if [ "$jdk" == "yes" ] && [ "$all" == NULL ]; then
          javainstall
       else 
         echo "Don't install jdk"
       fi
       ;;
    t) tomcat=$OPTARG
       if [ "$tomcat" == "yes" ]; then
          tomcatinstall
       else 
         echo "Don't install tomcat"
       fi       
       ;;
    s) server=$OPTARG
       if [ "$server" == "yes" ]; then
          serverinstall
       else 
         echo "Don't install server"
       fi       
       ;;
    h) httpd=$OPTARG
       if [ "$httpd" == "yes" ]; then
          httpdinstall
       else 
         echo "Don't install httpd"
       fi    
       ;;
    r) remove=$OPTARG
       user=$remove
       removeall
       ;;
    f) firewalld=$OPTARG
       if [ "$firewalld" == "yes" ]; then
          firewalld
       else 
         echo "Don't setting"
       fi    
       ;;       
    :) printf "missing argument for -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
   \?) echo "hihihihi"
       ;;
  esac
done
shift $((OPTIND - 1))



