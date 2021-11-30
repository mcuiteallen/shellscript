#!/bin/bash

while echo $1 | grep -q ^-; do
    eval $( echo $1 | sed 's/^-//' )=$2
    shift
    shift
done

function deployroot {
  sudo systemctl start stop-${service}
  sudo mkdir /opt/Tomcat/tomcat"$module"/war
  sudo rm -rf /opt/Tomcat/tomcat"$module"/work/Catalina
  sudo rm -rf /opt/Tomcat/tomcat"$module"/webapps/ROOT  
  sudo mv /home/"$user"/"$module"/"$file".zip /opt/Tomcat/tomcat"$module"/webapps
  cd /opt/Tomcat/tomcat"$module"/webapps
  sudo unzip /opt/Tomcat/tomcat"$module"/webapps/"$file".zip
  sleep 2
  sudo mv InFactoryFrontEnd ROOT
  sudo rm -rf /opt/Tomcat/tomcat"$module"/webapps/"$file".zip
  sudo systemctl start start-${service}
  echo "SUCCESS"
}

deployroot


