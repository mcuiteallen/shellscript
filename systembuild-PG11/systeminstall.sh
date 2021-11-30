#!/bin/bash

while echo $1 | grep -q ^-; do
    eval $( echo $1 | sed 's/^-//' )=$2
    shift
    shift
done
echo user=$user
echo project=$project


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
	sudo yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel
	sudo java -version
}


function tomcatinstall {
	sudo mv /home/"$user"/systembuild/Tomcat.zip /opt
	cd /opt
	sudo rm -rf /opt/Tomcat
	sudo unzip /opt/Tomcat.zip
	chmodStartEnableShTomcatList=( "tomcatAUTH" "tomcatECBJ" "tomcatISAS" "tomcatIFAS" "tomcatINFACTORY-FRONTEND") 
    for i in "${chmodStartEnableShTomcatList[@]}"
    do
        sudo chmod +x /opt/Tomcat/$i/start-enable/*.sh
		sudo chmod +x /opt/Tomcat/$i/bin/*.sh
		sudo /opt/Tomcat/$i/start-enable/./install.sh
    done	
	sudo mv /home/"$user"/systembuild/appdata.zip /opt
	sudo unzip /opt/appdata.zip
}





function serverinstall {
	sudo crontab -r
	sudo mv /home/"$user"/systembuild/server.zip /opt
	sudo cp /home/"$user"/systembuild/prometheus.zip /opt
	cd /opt
	sudo unzip /opt/server.zip
	sudo chmod +x /opt/StatisticService/tomcat/bin/*.sh
	mvModule=( "CServer" "CSfile" "GEE" "INLIGHT" "CHART"  "EDGE" "EC" "NS" "INEMS" "INPARK" "ICA"
	"StatisticService" "INFACTORY-BACKEND" "StatisticCacheService" "AUTHCENTER" "SIMPLERULE") 
    for i in "${mvModule[@]}"
    do
        sudo mv /opt/server/$i /opt  
    done
	chmodStartEnableShModuleList=( "GEE/start-enable" "INLIGHT/start-enable" "CHART/start-enable" 
	"EDGE/start-enable" "INEMS/start-enable" "ICA/start-enable" "AUTHCENTER/start-enable" "StatisticService/start-enable"
	"StatisticCacheService/start-enable" "INFACTORY-BACKEND/start-enable" "INPARK/start-enable" "CServer/CServer/cserver_service"
	"NS/start-enable" "SIMPLERULE/start-enable") 
	chmodRunShModuleList=("GEE/GEE/GeeServer" "INLIGHT" "CHART" "EDGE/EDGE" "INEMS/INEMS" "ICA/ICA" "AUTHCENTER/AUTHCENTER"
	"StatisticService/StatisticService" "StatisticCacheService/StatisticCacheService" "INFACTORY-BACKEND/INFACTORY-BACKEND"
	"INPARK/INPARK" "CServer/CServer" "NS/NS_current" "SIMPLERULE/SIMPLERULE")
    for j in "${chmodRunShModuleList[@]}"
    do
        sudo chmod +x /opt/$j/*.sh
    done
	for k in "${chmodStartEnableShModuleList[@]}"
    do
        sudo chmod +x /opt/$k/*.sh
		sudo /opt/$k/./install.sh
    done
	sudo unzip /opt/prometheus.zip
	sudo chmod +x /opt/prometheus/*.sh
	sudo chmod +x /opt/prometheus/node_exporter-0.15.2.linux-amd64/start-enable/*.sh
	sudo chmod +x /opt/prometheus/node_exporter-0.15.2.linux-amd64/node_exporter
	sudo /opt/prometheus/node_exporter-0.15.2.linux-amd64/start-enable/./install.sh
	sudo yum -y install openvpn
	sudo cp -f /opt/prometheus/openvpn/* /etc/openvpn/client
	chmodServiceList=( "cserver" "gee" "nserver" "auth" "ec"  "ecbj" "quartz" "isas" "if3" "inlight" "chart" "edge" "obsidian"
	"inems" "inpark" "statistic" "statistic-cache" "infactory-backend" "node" "ica" "simplerule" "AuthCenter" "infactory-frontend" ) 
    for l in "${chmodServiceList[@]}"
    do
        sudo chmod 644 /usr/lib/systemd/system/*$l.service
    done	
	echo EDGEPROJECT $project
    if [ "$project" == "inpark" ]; then
       sudo mv /opt/EDGE/EDGE/config/application-INPARK.yml /opt/EDGE/EDGE/config/application.yml
    else 
       sudo mv /opt/EDGE/EDGE/config/application-INFACTORY.yml /opt/EDGE/EDGE/config/application.yml
    fi
	LIST=`crontab -l`
	SOURCE="/opt/prometheus/cron.sh -env $sta > /dev/null"
	SOURCE1="(/usr/sbin/ntpdate pool.ntp.org;/usr/sbin/hwclock -w)"
    if [ $sta == "sta" ]; then
       SOURCE2="/opt/prometheus/monitor.sh -category STANDALONE -env $env  > /dev/null"
    else
       SOURCE2="/opt/prometheus/monitor.sh -category PRIVATECLOUD -env $env  > /dev/null"
    fi
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
	if echo "$LIST" | grep -q "$SOURCE2"; then
	   echo "The back job had been added.";
	else
	   sudo crontab -l | { cat; echo "*/5 * * * * $SOURCE2"; } | crontab -
	fi
	sudo sed -i "s/AUTOTEST/$env/g"  /opt/prometheus/cron.sh
	sudo yum -y install  httpd php
	sudo systemctl enable httpd
	sudo systemctl start httpd
}

function httpdinstallwithmodjk {
	sudo rm -rf /opt/ssl_key/
	sudo yum -y remove  httpd php
	sudo yum -y remove  mod_ssl
	sudo rm -rf /etc/httpd	
	sudo yum -y install httpd php
	sudo yum -y install nc
	sudo systemctl enable httpd
	sudo yum -y install mod_ssl openssl 
	cd /home/"$user"/systembuild/
	sudo unzip /home/"$user"/systembuild/ssl_key.zip
	sudo mv /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd_bk.conf
	sudo mv /home/"$user"/systembuild/ssl_key/httpd.conf /etc/httpd/conf/
	sudo mv /home/"$user"/systembuild/ssl_key/Insynerger.key /etc/httpd/conf/
	sudo mv /home/"$user"/systembuild/ssl_key/74b55e8e141f69b7.crt /etc/httpd/conf/
	sudo mv /home/"$user"/systembuild/ssl_key/gd_bundle-g2-g1.crt /etc/httpd/conf/
	sudo mv /home/"$user"/systembuild/ssl_key/mod_jk.so /etc/httpd/modules
	sudo chmod +x /etc/httpd/modules/mod_jk.so
	sudo systemctl start httpd
	echo "complete install HTTPD"
}

function httpdinstall {
	sudo yum -y remove  httpd
	sudo rm -rf /etc/httpd	
	sudo yum -y install httpd
	sudo systemctl enable httpd
	sudo systemctl start httpd
	echo "complete install HTTPD"
}

function firewalld {
	sudo systemctl start firewalld
	sudo systemctl enable firewalld
	firewallPortList=( "80" "443" "8444" "8080" "8446" "8445" "8447" "8500" "8085" "9080" "8307" "9900" "9901" "9906" "5050" "6060" "9999") 
    for i in "${firewallPortList[@]}"
    do
        sudo firewall-cmd --zone=public --add-port=$i/tcp --permanent
    done	
	sudo firewall-cmd --reload
	echo "complete install"
}

function removeall {
    while ps ax | grep java | grep -v "grep"
    do
        ps ax | grep java | grep -v "grep" | awk '{print $1}' | xargs kill -9
    done
	serviceStopNameList=( "stop-auth" "stop-isas" "stop-ec" "stop-ecbj" "stop-quartz" "stop-if3" "stop-inlight" "stop_gee" "stop_cserver" "stop_nserver"
	"stop_chart" "stop_edge" "stop-obsidian" "stop_inems" "stop_inpark" "stop-statistic" "stop-statistic-cache" "stop_infactory-backend" "stop_ica" 
	"stop_AuthCenter" "stop-infactory-frontend" "stop_simplerule") 
	serviceStartNameList=( "start-auth" "start-isas" "start-ec" "start-ecbj" "start-quartz" "start-if3" "start-inlight" "start_gee" "start_cserver" "start_nserver"
	"start_chart" "start_edge" "start-obsidian" "start_inems" "start_inpark" "start-statistic" "start-statistic-cache" "start_infactory-backend" "start_ica" 
	"start_AuthCenter" "start-infactory-frontend" "start_simplerule" "start_node") 	
    for i in "${serviceStopNameList[@]}"
    do
        sudo systemctl start $i
		sudo systemctl disable $i.service
		sudo rm -rf /usr/lib/systemd/system/$i.service
    done
    for j in "${serviceStartNameList[@]}"
    do
		sudo systemctl disable $j.service
		sudo rm -rf /usr/lib/systemd/system/$i.service
    done
	sudo yum -y remove  httpd php
	sudo yum -y remove  mod_ssl
	optFolderList=( "Tomcat" "server" "NS" "GEE" "EC" "EDGE" "CHART" "INLIGHT" "CServer" "CSfile"
	"StatisticService" "StatisticCacheService" "INFACTORY-BACKEND" "INEMS" "INPARK" "AUTHCENTER" "ICA" "SIMPLERULE" "appdata" 
	"ssl_key" "prometheus" "BAK") 	
    for k in "${optFolderList[@]}"
    do
        sudo rm -rf /opt/$k
    done		
	sudo rm -rf /etc/httpd
	sudo rm -rf /home/"$user"/systembuild
	sudo rm -rf /opt/*zip
	sudo rm -rf /opt/*tar.gz
sudo echo "delete all of server & Tomcat & appdata & httpd"
}

removeall
javainstall
tomcatinstall
serverinstall
firewalld
httpdinstall





