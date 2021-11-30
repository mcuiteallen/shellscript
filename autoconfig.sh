#!/bin/bash

while echo $1 | grep -q ^-; do
    eval $( echo $1 | sed 's/^-//' )=$2
    shift
    shift
done

echo module = $module
echo env = $env
echo version = $version
echo dbip = $dbip

if [ -d "/opt/systemfile/config/$module/$env" ]
then
   rm -rf  /opt/systemfile/config/$module/$env/temp
   mkdir -p /opt/systemfile/config/$module/$env/temp
   cd /opt/systemfile/config/$module/$env/temp  
else
   mkdir -p /opt/systemfile/config/$module/$env/temp
   cd /opt/systemfile/config/$module/$env
   sudo cp -f /opt/systemfile/config/$module/default/*.txt .
   cd /opt/systemfile/config/$module/$env/temp
fi

function default {
	sudo cp -f /opt/systemfile/config/sample/* .	 
	if [ $dbip == "update" ]
	then
		echo "dbip = update"
	else
		sudo rm -rf ../dbip.txt
		sudo echo $dbip > ../dbip.txt		
	fi
	hyec=$(echo $env | grep "HYEC")
	if [[ "$hyec" != "" ]]
	then
		echo "use HYEC common"
		rm -rf common.yml
		mv common-HYEC.yml common.yml
	else
		echo "default"	
	fi	
	sudo sed -i "s/dbip/$(<../dbip.txt)/g"  datasource.yml
	sudo sed -i "s/dbname/$(<../dbname.txt)/g"  datasource.yml
	sudo sed -i "s/dbusername/$(<../dbusername.txt)/g"  datasource.yml
	sudo sed -i "s/dbpasswd/$(<../dbpasswd.txt)/g"  datasource.yml     
	sudo sed -i "s/dbport/$(<../dbport.txt)/g"  datasource.yml   
	sudo cat datasource.yml >>  application-spring1.yml
	sudo sed -i "s/serverport/$(<../serverport.txt)/g"  server.yml
	sudo sed -i "s/ajpport/$(<../ajpport.txt)/g"  server.yml
	sudo sed -i "s/log4j2.properties/$(<../logfilename.txt)/g"  server.yml
	sudo sed -i "s/innerip/$(<../innerip.txt)/g"  common.yml
	sudo sed -i "s/geeip/$(<../geeip.txt)/g"  common.yml
	sudo sed -i "s/obsidianip/$(<../innerip.txt)/g"  common.yml
	sudo sed -i "s/statisticip/$(<../innerip.txt)/g"  common.yml	
	sudo sed -i "s/outterip/$(<../outterip.txt)/g"  common.yml
	sudo cat server.yml >>  application-spring1.yml
	sudo cat common.yml >>  application-spring1.yml
	sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/$module/release/$version/setting/customize.yml
	if [ -f "/opt/systemfile/config/$module/$env/temp/customize.yml" ]
	then
	sudo cat customize.yml >>  application-spring1.yml
	else
	echo "--------------------------------File not found------------------------------------"
	echo "-----ftp://$module/release/$version/setting/customize.yml-----"
	exit 1    
	fi
	sudo mv application-spring1.yml application-$env.yml
	echo "202"
	sudo /bin/curl -T application-$env.yml   -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/$module/release/$version/setting/
}

function spring2 {
	sudo cp -f /opt/systemfile/config/sample/* .	 
	if [ $dbip == "update" ]
	then
		echo "dbip = update"
	else
		sudo rm -rf ../dbip.txt
		sudo echo $dbip > ../dbip.txt		
	fi
	hyec=$(echo $env | grep "HYEC")
	if [[ "$hyec" != "" ]]
	then
		echo "use HYEC common"
		rm -rf common.yml
		mv common-HYEC.yml common.yml
	else
		echo "default"	
	fi
	sudo sed -i "s/dbip/$(<../dbip.txt)/g"  datasource.yml
	sudo sed -i "s/dbname/$(<../dbname.txt)/g"  datasource.yml
	sudo sed -i "s/dbusername/$(<../dbusername.txt)/g"  datasource.yml
	sudo sed -i "s/dbpasswd/$(<../dbpasswd.txt)/g"  datasource.yml     
	sudo sed -i "s/dbport/$(<../dbport.txt)/g"  datasource.yml   
	sudo cat datasource.yml >>  application-spring2.yml
	sudo sed -i "s/serverport/$(<../serverport.txt)/g"  server.yml
	sudo sed -i "s/ajpport/$(<../ajpport.txt)/g"  server.yml
	sudo sed -i "s/log4j2.properties/$(<../logfilename.txt)/g"  server.yml
	sudo sed -i "s/innerip/$(<../innerip.txt)/g"  common.yml
	sudo sed -i "s/geeip/$(<../geeip.txt)/g"  common.yml
	sudo sed -i "s/obsidianip/$(<../innerip.txt)/g"  common.yml
	sudo sed -i "s/statisticip/$(<../innerip.txt)/g"  common.yml	
	sudo sed -i "s/outterip/$(<../outterip.txt)/g"  common.yml
	sudo cat server.yml >>  application-spring2.yml
	sudo cat common.yml >>  application-spring2.yml
	sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/$module/release/$version/setting/customize.yml
	if [ -f "/opt/systemfile/config/$module/$env/temp/customize.yml" ]
	then
	sudo cat customize.yml >>  application-spring2.yml
	else
	echo "--------------------------------File not found------------------------------------"
	echo "-----ftp://$module/release/$version/setting/customize.yml-----"
	exit 1    
	fi
	sudo mv application-spring2.yml application-$env.yml
	echo "202"
	sudo /bin/curl -T application-$env.yml   -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/$module/release/$version/setting/
}

function statistic {
	sudo cp -f /opt/systemfile/config/sample/* .	 
	if [ $dbip == "update" ]
	then
		echo "dbip = update"
	else
		sudo rm -rf ../dbip.txt
		sudo echo $dbip > ../dbip.txt		
	fi
	hyec=$(echo $env | grep "HYEC")
	if [[ "$hyec" != "" ]]
	then
		echo "use HYEC common"
		rm -rf common.yml
		mv common-HYEC.yml common.yml
	else
		echo "default"	
	fi	
	sudo sed -i "s/dbip/$(<../dbip.txt)/g"  datasource-STATISTIC.yml
	sudo sed -i "s/dbname/$(<../dbname.txt)/g"  datasource-STATISTIC.yml
	sudo sed -i "s/dbusername/$(<../dbusername.txt)/g"  datasource-STATISTIC.yml
	sudo sed -i "s/dbpasswd/$(<../dbpasswd.txt)/g"  datasource-STATISTIC.yml     
	sudo sed -i "s/dbport/$(<../dbport.txt)/g"  datasource-STATISTIC.yml   
	sudo cat datasource-STATISTIC.yml >>  application-spring2.yml
	sudo sed -i "s/serverport/$(<../serverport.txt)/g"  server.yml
	sudo sed -i "s/ajpport/$(<../ajpport.txt)/g"  server.yml
	sudo sed -i "s/innerip/$(<../innerip.txt)/g"  common.yml
	sudo sed -i "s/geeip/$(<../geeip.txt)/g"  common.yml
	sudo sed -i "s/obsidianip/$(<../obsidianip.txt)/g"  common.yml
	sudo sed -i "s/statisticip/$(<../statisticip.txt)/g"  common.yml
	sudo sed -i "s/outterip/$(<../outterip.txt)/g"  common.yml
	sudo cat server.yml >>  application-spring2.yml
	sudo cat common.yml >>  application-spring2.yml
	sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/$module/release/$version/setting/customize.yml
	if [ -f "/opt/systemfile/config/$module/$env/temp/customize.yml" ]
	then
		sudo rm -rf ../env.txt
		sudo echo $env | tr '[:upper:]' '[:lower:]' > ../env.txt			
		sudo sed -i "s/replaceme/$(<../env.txt)/g"  customize.yml
		sudo cat customize.yml >>  application-spring2.yml
	else
		echo "--------------------------------File not found------------------------------------"
		echo "-----ftp://$module/release/$version/setting/customize.yml-----"
		exit 1    
	fi
	sudo mv application-spring2.yml application-$env.yml
	echo "202"
	sudo /bin/curl -T application-$env.yml   -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/$module/release/$version/setting/
}

function statisticcache { 	
	sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/$module/release/$version/setting/application.yml
	if [ -f "/opt/systemfile/config/$module/$env/temp/application.yml" ]
	then
		sudo sed -i "s/statisticip/$(<../statisticip.txt)/g"  application.yml
	else
		echo "--------------------------------File not found------------------------------------"
		echo "-----ftp://$module/release/$version/setting/application.yml-----"
		exit 1    
	fi	
	sudo mv application.yml application-$env.yml
	echo "202"
	sudo /bin/curl -T application-$env.yml   -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/$module/release/$version/setting/
}

function geeconfig {
	sudo cp -f ../../config/application.yml .
	if [ $dbip == "update" ]
	then
		echo "dbip = update"
	else
		sudo rm -rf ../dbip.txt
		sudo echo $dbip > ../dbip.txt		
	fi
	sudo sed -i "s/dbip/$(<../dbip.txt)/g"  application.yml
	sudo sed -i "s/dbname/$(<../dbname.txt)/g"  application.yml
	sudo sed -i "s/dbusername/$(<../dbusername.txt)/g"  application.yml
	sudo sed -i "s/dbpasswd/$(<../dbpasswd.txt)/g"  application.yml     
	sudo sed -i "s/dbport/$(<../dbport.txt)/g"  application.yml   
	sudo sed -i "s/innerip/$(<../innerip.txt)/g"  application.yml 
	sudo sed -i "s/inemsip/$(<../inemsip.txt)/g"  application.yml 	
	sudo sed -i "s/inparkip/$(<../inparkip.txt)/g"  application.yml 	
	sudo mv application.yml application-$env.yml
	sudo /bin/curl -T application-$env.yml   -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/$module/release/$version/setting/
}

function nsconfig {
	sudo cp -f ../../config/application.yml .
	if [ $dbip == "update" ]
	then
		echo "dbip = update"
	else
		sudo rm -rf ../dbip.txt
		sudo echo $dbip > ../dbip.txt		
	fi
	sudo sed -i "s/dbip/$(<../dbip.txt)/g"  application.yml
	sudo sed -i "s/dbname/$(<../dbname.txt)/g"  application.yml
	sudo sed -i "s/dbusername/$(<../dbusername.txt)/g"  application.yml
	sudo sed -i "s/dbpasswd/$(<../dbpasswd.txt)/g"  application.yml     
	sudo sed -i "s/dbport/$(<../dbport.txt)/g"  application.yml   
	sudo sed -i "s/innerip/$(<../innerip.txt)/g"  application.yml 
	sudo sed -i "s/inemsip/$(<../inemsip.txt)/g"  application.yml 	
	sudo sed -i "s/smtphost/$(<../smtphost.txt)/g"  application.yml
	sudo sed -i "s/smtpport/$(<../smtpport.txt)/g"  application.yml
	sudo sed -i "s/smtpusername/$(<../smtpusername.txt)/g"  application.yml
	sudo sed -i "s/smtppd/$(<../smtppd.txt)/g"  application.yml
	sudo mv application.yml application-$env.yml
	sudo /bin/curl -T application-$env.yml   -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/$module/release/$version/setting/
}

function ecbjconfig {
  	sudo cp -f ../../config/setting-ECBJ.properties .
	if [ $dbip == "update" ]
	then
		echo "dbip = update"
	else
		sudo rm -rf ../dbip.txt
		sudo echo $dbip > ../dbip.txt		
	fi
	sudo sed -i "s/dbip/$(<../dbip.txt)/g"  setting-ECBJ.properties
	sudo sed -i "s/dbname/$(<../dbname.txt)/g"  setting-ECBJ.properties
	sudo sed -i "s/dbusername/$(<../dbusername.txt)/g"  setting-ECBJ.properties
	sudo sed -i "s/dbpasswd/$(<../dbpasswd.txt)/g"  setting-ECBJ.properties     
	sudo sed -i "s/dbport/$(<../dbport.txt)/g"  setting-ECBJ.properties   
	sudo sed -i "s/innerip/$(<../innerip.txt)/g"  setting-ECBJ.properties
	sudo sed -i "s/geeip/$(<../geeip.txt)/g"  setting-ECBJ.properties
	sudo sed -i "s/webip/$(<../webip.txt)/g"  setting-ECBJ.properties
	sudo sed -i "s/prodornot/$(<../prodornot.txt)/g"  setting-ECBJ.properties 	
	sudo sed -i "s/smtphost/$(<../smtphost.txt)/g"  setting-ECBJ.properties
	sudo sed -i "s/smtpport/$(<../smtpport.txt)/g"  setting-ECBJ.properties
	sudo sed -i "s/smtpusername/$(<../smtpusername.txt)/g"  setting-ECBJ.properties
	sudo sed -i "s/smtppd/$(<../smtppd.txt)/g"  setting-ECBJ.properties	
	sudo sed -i "s/smtpfrom/$(<../smtpfrom.txt)/g"  setting-ECBJ.properties
	sudo mv setting-ECBJ.properties setting-$env.properties
	sudo /bin/curl -T setting-$env.properties   -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/$module/release/$version/setting/
}

function csconfig {
	sudo cp -f /opt/systemfile/config/sample/* .
	sudo sed -i "s/prod/CSE/g"  application-spring2.yml
	if [ $dbip == "update" ]
	then
		echo "dbip = update"
	else
		sudo rm -rf ../dbip.txt
		sudo rm -rf ../db2ip.txt
		sudo rm -rf ../db3ip.txt
		sudo echo $dbip > ../dbip.txt
        sudo echo $dbip > ../db2ip.txt
        sudo echo $dbip > ../db3ip.txt		
	fi	
	hyec=$(echo $env | grep "HYEC")
	if [[ "$hyec" != "" ]]
	then
		echo "use HYEC common"
		rm -rf common.yml
		mv common-HYEC.yml common.yml
	else
		echo "default"	
	fi	
    sudo sed -i "s/dbip/$(<../dbip.txt)/g"  datasource-CS.yml
    sudo sed -i "s/db2ip/$(<../db2ip.txt)/g"  datasource-CS.yml
    sudo sed -i "s/db3ip/$(<../db3ip.txt)/g"  datasource-CS.yml
    sudo sed -i "s/dbname/$(<../dbname.txt)/g"  datasource-CS.yml
    sudo sed -i "s/dbusername/$(<../dbusername.txt)/g"  datasource-CS.yml
    sudo sed -i "s/dbpasswd/$(<../dbpasswd.txt)/g"  datasource-CS.yml
    sudo sed -i "s/db2name/$(<../db2name.txt)/g"  datasource-CS.yml
    sudo sed -i "s/db2username/$(<../db2username.txt)/g"  datasource-CS.yml
    sudo sed -i "s/db2passwd/$(<../db2passwd.txt)/g"  datasource-CS.yml
    sudo sed -i "s/db3name/$(<../db3name.txt)/g"  datasource-CS.yml
    sudo sed -i "s/db3username/$(<../db3username.txt)/g"  datasource-CS.yml
    sudo sed -i "s/db3passwd/$(<../db3passwd.txt)/g"  datasource-CS.yml   
	sudo sed -i "s/dbport/$(<../dbport.txt)/g"  datasource-CS.yml   
	sudo cat datasource-CS.yml >>  application-spring2.yml
	sudo sed -i "s/serverport/$(<../serverport.txt)/g"  server.yml
	sudo sed -i "s/ajpport/$(<../ajpport.txt)/g"  server.yml
	sudo sed -i "s/log4j2.properties/$(<../logfilename.txt)/g"  server.yml
	sudo sed -i "s/innerip/$(<../innerip.txt)/g"  common.yml
	sudo sed -i "s/geeip/$(<../geeip.txt)/g"  common.yml
	sudo sed -i "s/outterip/$(<../outterip.txt)/g"  common.yml
	sudo cat server.yml >>  application-spring2.yml
	sudo cat common.yml >>  application-spring2.yml
	sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/$module/release/$version/setting/customize.yml
	if [ -f "/opt/systemfile/config/$module/$env/temp/customize.yml" ]
	then
		sudo sed -i "s/replaceme/$env/g"  customize.yml
		sudo sed -i "s/replacelogflag/$(<../logflag.txt)/g"  customize.yml
		sudo cat customize.yml >>  application-spring2.yml
	else
		echo "--------------------------------File not found------------------------------------"
		echo "-----ftp://$module/release/$version/setting/customize.yml-----"
		exit 1    
	fi
	sudo mv application-spring2.yml application-$env.yml
	echo "202"
	sudo /bin/curl -T application-$env.yml   -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/$module/release/$version/setting/
}

function ica {
	sudo cp -f /opt/systemfile/config/sample/* .	 
	if [ $dbip == "update" ]
	then
		echo "dbip = update"
	else
		sudo rm -rf ../dbip.txt
		sudo echo $dbip > ../dbip.txt		
	fi
	hyec=$(echo $env | grep "HYEC")
	if [[ "$hyec" != "" ]]
	then
		echo "use HYEC common"
		rm -rf common.yml
		mv common-HYEC.yml common.yml
	else
		echo "default"	
	fi	
	sudo sed -i "s/dbip/$(<../dbip.txt)/g"  datasource-ICA.yml
	sudo sed -i "s/dbname/$(<../dbname.txt)/g"  datasource-ICA.yml
	sudo sed -i "s/dbusername/$(<../dbusername.txt)/g"  datasource-ICA.yml
	sudo sed -i "s/dbpasswd/$(<../dbpasswd.txt)/g"  datasource-ICA.yml     
	sudo sed -i "s/dbport/$(<../dbport.txt)/g"  datasource-ICA.yml   
	sudo cat datasource-ICA.yml >>  application-ICA.yml
	sudo sed -i "s/serverport/$(<../serverport.txt)/g"  server-ICA.yml
	sudo sed -i "s/innerip/$(<../innerip.txt)/g"  common.yml
	sudo sed -i "s/geeip/$(<../geeip.txt)/g"  common.yml
	sudo sed -i "s/obsidianip/$(<../innerip.txt)/g"  common.yml
	sudo sed -i "s/statisticip/$(<../innerip.txt)/g"  common.yml	
	sudo sed -i "s/outterip/$(<../outterip.txt)/g"  common.yml
	sudo cat server-ICA.yml >>  application-ICA.yml
	sudo cat common.yml >>  application-ICA.yml
	sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/$module/release/$version/setting/customize.yml
	if [ -f "/opt/systemfile/config/$module/$env/temp/customize.yml" ]
	then
	    sudo sed -i "s/outterip/$(<../outterip.txt)/g"  customize.yml
		sudo cat customize.yml >>  application-ICA.yml
	else
		echo "--------------------------------File not found------------------------------------"
		echo "-----ftp://$module/release/$version/setting/customize.yml-----"
		exit 1    
	fi
	sudo mv application-ICA.yml application-$env.yml
	echo "202"
	sudo /bin/curl -T application-$env.yml   -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/$module/release/$version/setting/
}

function chart {
	sudo cp -f /opt/systemfile/config/sample/* .	 
	if [ $dbip == "update" ]
	then
		echo "dbip = update"
	else
		sudo rm -rf ../dbip.txt
		sudo echo $dbip > ../dbip.txt		
	fi
	sudo sed -i "s/dbip/$(<../dbip.txt)/g"  datasource.yml 
	sudo sed -i "s/dbname/$(<../dbname.txt)/g"  datasource.yml 
	sudo sed -i "s/dbusername/$(<../dbusername.txt)/g"  datasource.yml 
	sudo sed -i "s/dbpasswd/$(<../dbpasswd.txt)/g"  datasource.yml      
	sudo sed -i "s/dbport/$(<../dbport.txt)/g"  datasource.yml    
	sudo cat datasource.yml  >>  application-spring1.yml
	sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/$module/release/$version/setting/customize.yml
	if [ -f "/opt/systemfile/config/$module/$env/temp/customize.yml" ]
	then
		sudo cat customize.yml >>  application-spring1.yml
	else
		echo "--------------------------------File not found------------------------------------"
		echo "-----ftp://$module/release/$version/setting/customize.yml-----"
		exit 1    
	fi
	sudo mv application-spring1.yml application-$env.yml
	echo "202"
	sudo /bin/curl -T application-$env.yml   -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/$module/release/$version/setting/
}

function authcenter {
	sudo cp -f /opt/systemfile/config/sample/* .	 
	if [ $dbip == "update" ]
	then
		echo "dbip = update"
	else
		sudo rm -rf ../dbip.txt
		sudo echo $dbip > ../dbip.txt		
	fi
	sudo sed -i "s/dbip/$(<../dbip.txt)/g"  application-AUTHCENTER.yml 
	sudo sed -i "s/dbname/$(<../dbname.txt)/g"  application-AUTHCENTER.yml 
	sudo sed -i "s/dbusername/$(<../dbusername.txt)/g"  application-AUTHCENTER.yml 
	sudo sed -i "s/dbpasswd/$(<../dbpasswd.txt)/g"  application-AUTHCENTER.yml      
	sudo sed -i "s/dbport/$(<../dbport.txt)/g"  application-AUTHCENTER.yml    
	sudo mv application-AUTHCENTER.yml application-$env.yml
	echo "202"
	sudo /bin/curl -T application-$env.yml   -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/$module/release/$version/setting/
}

function linetokenconfig {
	sudo cp -f ../../config/application.yml .
	sudo sed -i "s/serverport/$(<../serverport.txt)/g"  application.yml 
	sudo sed -i "s/innerip/$(<../innerip.txt)/g"  application.yml 
	sudo sed -i "s/outterip/$(<../outterip.txt)/g"  application.yml   	
	sudo mv application.yml application-$env.yml
	sudo /bin/curl -T application-$env.yml   -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/$module/release/$version/setting/
}

function devicevaluation {
	sudo cp -f ../../config/application.yml .
	if [ $dbip == "update" ]
	then
		echo "dbip = update"
	else
		sudo rm -rf ../dbip.txt
		sudo echo $dbip > ../dbip.txt		
	fi
	sudo sed -i "s/serverport/$(<../serverport.txt)/g"  application.yml 	
	sudo sed -i "s/dbip/$(<../dbip.txt)/g"  application.yml
	sudo sed -i "s/dbname/$(<../dbname.txt)/g"  application.yml
	sudo sed -i "s/dbusername/$(<../dbusername.txt)/g"  application.yml
	sudo sed -i "s/dbpasswd/$(<../dbpasswd.txt)/g"  application.yml     
	sudo sed -i "s/dbport/$(<../dbport.txt)/g"  application.yml
	sudo mv application.yml application-$env.yml
	sudo /bin/curl -T application-$env.yml   -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/$module/release/$version/setting/
}

case $module in
   "CS") csconfig 
   ;;
   "GEE") geeconfig
   ;;
   "NS") nsconfig
   ;;
   "ECBJ") ecbjconfig
   ;;   
   "STATISTIC") statistic
   ;;  
   "STATISTICCACHE") statisticcache
   ;;     
   "CommonAPI") ica
   ;;    
   "CHART") chart
   ;;     
   "AUTHCENTER") authcenter
   ;;   
   "INFACTORY-BACKEND") spring2
   ;;
   "SIMPLERULE") spring2   
   ;;   
   "LINETOKEN") linetokenconfig  
   ;;    
   "DEVICEVALUATION") devicevaluation  
   ;;   
   *) default 
   ;;
esac