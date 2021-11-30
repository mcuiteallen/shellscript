#!/bin/bash

while echo $1 | grep -q ^-; do
    eval $( echo $1 | sed 's/^-//' )=$2
    shift
    shift
done

function deployroot {
  sudo rm -rf /opt/"$module"/"$module"/*.jar
  sudo rm -rf /opt/"$module"/"$module"/config/application.yml
  sudo rm -rf /opt/"$module"/"$module"/config/log4j2.properties  
  sudo mv /home/"$user"/"$module"/"$file".jar /opt/"$module"/"$module"
  sudo mv /home/"$user"/"$module"/"$setting" /opt/"$module"/"$module"/config
  sudo mv /home/"$user"/"$module"/"$log4j2" /opt/"$module"/"$module"/config  
  cd /opt/"$module"/"$module"/config
  sudo mv "$setting" application.yml
  sudo mv "$log4j2" log4j2.properties 
  sudo systemctl start start-${service}
  echo "SUCCESS"
}
deployroot



