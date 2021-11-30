#!/bin/bash

while echo $1 | grep -q ^-; do
    eval $( echo $1 | sed 's/^-//' )=$2
    shift
    shift
done

function deployroot {

  if [ -d "/opt/$module" ]; then
  	# 目錄 /path/to/dir 存在
  	echo "Directory /path/to/dir exists."
    deploy
  else
  	# 目錄 /path/to/dir 不存在
	sudo rm -rf /opt/"$module".zip
	sudo rm -rf /opt/"$module"
	sudo mv /home/"$user"/"$module"/"$module".zip /opt
	cd /opt
	sudo unzip "$module".zip
	sudo chmod +x /opt/"$module"/start-enable/*
	sudo /opt/"$module"/start-enable/./install.sh
	sudo chmod +x /opt/"$module"/"$module"/*.sh
	deploy
  	echo "Directory /path/to/dir does not exists."
  fi
  echo "SUCCESS"
}

function deploy {
	sudo rm -rf /opt/"$module"/"$module"/*.jar
	sudo rm -rf /opt/"$module"/"$module"/config/*
	sudo mv /home/"$user"/"$module"/"$file".jar /opt/"$module"/"$module"
	sudo mv /home/"$user"/"$module"/"$setting" /opt/"$module"/"$module"/config
	sudo mv /home/"$user"/"$module"/"$log4j" /opt/"$module"/"$module"/config
	cd /opt/"$module"/"$module"/config
	sudo mv "$setting" application.yml
	sudo mv "$log4j" log4j2.properties
	sudo systemctl start start_${service}
    echo "SUCCESS"
}

deployroot



