#!/bin/bash

while echo $1 | grep -q ^-; do
    eval $( echo $1 | sed 's/^-//' )=$2
    shift
    shift
done

function deployroot {
  sudo rm -rf /opt/"$module"/"$module"/*.war
  sudo rm -rf /opt/"$module"/"$module"/config/application.yml
  sudo mv /home/"$user"/"$module"/"$file".war /opt/"$module"/"$module"
  sudo mv /home/"$user"/"$module"/"$setting" /opt/"$module"/"$module"/config
  sudo mv /home/"$user"/"$module"/"$log" /opt/"$module"/"$module"/config
  cd /opt/"$module"/"$module"/config
  sudo mv "$setting" application.yml
  sudo mv "$log" logback-spring.xml
  sudo systemctl start start_${service}
  echo "SUCCESS"
}

deployroot



