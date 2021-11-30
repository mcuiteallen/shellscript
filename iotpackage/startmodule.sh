#!/bin/bash

while echo $1 | grep -q ^-; do
    eval $( echo $1 | sed 's/^-//' )=$2
    shift
    shift
done

sudo rm -rf /opt/BAK
sudo mkdir -p /opt/BAK

function startinfactory() {
	sudo systemctl start start_gee
	sleep 3
	sudo systemctl start start_cserver
	sleep 3
	sudo systemctl start start_nserver
	sleep 3
	sudo systemctl start start_edge
	sleep 3
	sudo systemctl start start_inems
	sleep 3
	sudo systemctl disable start_inpark
	sudo mv /opt/INPARK /opt/BAK
	sleep 3	
	sudo systemctl start start-ecbj
	sleep 3
	sudo systemctl disable start-isas
	sleep 3
	sudo systemctl disable start-auth
	sleep 3
	sudo systemctl disable start_chart
	sleep 3
	sudo mv /opt/CHART /opt/BAK
	sudo systemctl start start-obsidian
	sleep 3
	sudo systemctl start start-statistic
	sleep 3
	sudo systemctl start start-statistic-cache
	sleep 3
	sudo systemctl start start_node
	sleep 3
	sudo systemctl start start_ica
	sleep 3	
	sudo systemctl start start_infactory-backend
}

function startinpark() {
	sudo systemctl start start_gee
	sleep 3
	sudo systemctl start start_cserver
	sleep 3
	sudo systemctl start start_nserver
	sleep 3
	sudo systemctl start start_edge
	sleep 3
	sudo systemctl disable start_inems
	sleep 3
	sudo mv /opt/INEMS /opt/BAK
	sudo systemctl disable start-ecbj
	sleep 3
	sudo mv /opt/Tomcat/tomcatECBJ /opt/BAK
	sudo systemctl disable start-isas
	sleep 3
	sudo mv /opt/Tomcat/tomcatISAS /opt/BAK
	sudo systemctl disable start-auth
	sleep 3
	sudo mv /opt/Tomcat/tomcatAUTH /opt/BAK
	sudo systemctl start start_chart
	sleep 3
	sudo systemctl start start-obsidian
	sleep 3
	sudo systemctl start start-statistic
	sleep 3
	sudo systemctl start start-statistic-cache
	sleep 3
	sudo systemctl start start_node
	sleep 3
	sudo systemctl start start_ica
	sleep 3	
	sudo systemctl disable start_infactory-backend
	sleep 3
	sudo mv /opt/INFACTORY-BACKEND /opt/BAK	
}

function startat() {
	sudo systemctl start start_gee
	sleep 3
	sudo systemctl start start_cserver
	sleep 3
	sudo systemctl start start-ec
	sleep 3
}


case $product in
   "at") startat 
   ;;
   "inpark") startinpark
   ;;      
   "infactory") startinfactory
   ;;     
   * ) echo "project input error." 
   ;;
esac


