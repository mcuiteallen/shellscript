#!/bin/bash

function obsidianModule {
	sudo rm -rf /opt/systembuild/server/StatisticService/tomcat/webapps/ROOT*
	cd /opt/systemfile/obsidian
	sudo cp -f xmltesting/project_generator.xml .
	sudo sed -i $dbip  project_generator.xml
	sudo ./run.sh
	sudo cp -f ROOT.war  /opt/systemfile/systembuild/server/StatisticService/tomcat/webapps
	if [ $dbip == "s/127.0.0.1/127.0.0.1/g" ]
    then
       sudo mv ROOT.war ROOT-local.war
	   sudo /bin/curl -T ROOT-local.war   -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/OBSIDIAN/release/4.5.0/
    else
	   sudo mv ROOT.war ROOT-$env.war
	   sudo /bin/curl -T ROOT-$env.war   -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/OBSIDIAN/release/4.5.0/
    fi
	
}

while echo $1 | grep -q ^-; do
    eval $( echo $1 | sed 's/^-//' )=$2
    shift
    shift
done


echo dbip = $dbip
echo env = $env

obsidianModule


