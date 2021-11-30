#!/bin/bash
function csModule {
if [ $cs == "uninstall" ]
then
   echo "I don't need to install cserver"
else
   sudo mkdir -p  /opt/systembuild/server/CServer/CServer
   sudo cp -R  /opt/systemfile/systembuild/server/CServer/CServer/*  /opt/systembuild/server/CServer/CServer  
   sudo rm -rf /opt/systembuild/server/CServer/CServer/CServerEms.jar   
   sudo rm -rf /opt/systembuild/server/CServer/CServer/config/*.yml
   sudo rm -rf /opt/systembuild/server/CServer/CServer/config/log4j2.properties   
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/CS/release/$cs/CServerEms.jar
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/CS/release/$cs/setting/application-${env}.yml
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/CS/release/$cs/log4j2/log4j2.properties   
   sudo mv CServerEms.jar /opt/systembuild/server/CServer/CServer
   sudo mv application-${env}.yml /opt/systembuild/server/CServer/CServer/config/application.yml
   sudo mv log4j2.properties /opt/systembuild/server/CServer/CServer/config/
fi
}

function csModuleFileCheck {
if [ $cs == "uninstall" ]
then
   echo "I don't need to install cs"
else
   sudo /opt/systemfile/config/./autoconfig.sh -module "CS" -env ${env} -version ${cs} -dbip ${dbip}
   sleep 5
   csServiceUrl=CS/release/$cs/CServerEms.jar
   csSettingUrl=CS/release/$cs/setting/application-${env}.yml
   csLog4j2Url=CS/release/$cs/log4j2/log4j2.properties
   csServiceUrlCheck=$( checkNewFtpUrl $csServiceUrl )
   csSettingUrlCheck=$( checkNewFtpUrl $csSettingUrl )
   csLog4j2UrlCheck=$( checkNewFtpUrl $csLog4j2Url )
   if [ $csSettingUrlCheck == "exist" ]
   then
	  array[0]=ok
   else
	  array[0]=$csSettingUrl
   fi
   if [ $csServiceUrlCheck == "exist" ]
   then
	  array[1]=ok
   else
      array[1]=$csServiceUrl
   fi
   if [ $csLog4j2UrlCheck == "exist" ]
   then
	  array[2]=ok
   else
      array[2]=$csLog4j2Url
   fi
fi
}

function geeModule {
if [ $gee == "uninstall" ]
then
   echo "I don't need to install gee"
else
   sudo mkdir -p  /opt/systembuild/server/GEE
   sudo cp -R  /opt/systemfile/systembuild/server/GEE/*  /opt/systembuild/server/GEE
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/GEE/release/$gee/gee.zip
   sudo mv gee.zip /opt/systembuild/server/GEE
   cd /opt/systembuild/server/GEE
   sudo unzip gee.zip
   sudo rm -rf GEE/GeeServer
   sudo mv GEE-*/GeeServer GEE
   sudo rm -rf GEE-*
   sudo rm -rf gee.zip
   sudo rm -rf GEE/GeeServer/*.bat
   geeSettingDeside
fi
}

function geeSettingDeside {
cd /opt/systembuild/server/GEE
if [ $env == "MYSQL" ]
then
   sudo rm -rf GEE/GeeServer/RunGEE.sh
   sudo mv GEE/GeeServer/RunGEE-${project}.sh GEE/GeeServer/RunGEE.sh
else   
   sudo rm -rf GEE/GeeServer/config/application-${env}.yml
   sudo rm -rf GEE/GeeServer/config/application.yml
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/GEE/release/$gee/setting/application-${env}.yml
   sudo cp -f application-${env}.yml GEE/GeeServer/config/application.yml
fi
}

function geeModuleFileCheck {
if [ $gee == "uninstall" ]
then
   echo "I don't need to install gee"
else
   geeServiceUrl=GEE/release/$gee/gee.zip
if [ $env == "MYSQL" ]
   then
	  geeSettingUrl=GEE/release/$gee/gee.zip
   else
      sudo /opt/systemfile/config/./autoconfig.sh -module "GEE" -env ${env} -version ${gee} -dbip ${dbip}
      sleep 5
      geeSettingUrl=GEE/release/$gee/setting/application-${env}.yml
   fi
   geeServiceUrlCheck=$( checkNewFtpUrl $geeServiceUrl )
   geeSettingUrlCheck=$( checkNewFtpUrl $geeSettingUrl )
   if [ $geeSettingUrlCheck == "exist" ]
   then
	  array[3]=ok
   else
      array[3]=$geeSettingUrl
   fi
   if [ $geeServiceUrlCheck == "exist" ]
   then
	  array[4]=ok
   else
      array[4]=$geeServiceUrl
   fi
   fi
}


function nsModule {
if [ $ns == "uninstall" ]
then
   echo "I don't need to install ns"
else
   sudo mkdir -p  /opt/systembuild/server/NS
   sudo cp -R  /opt/systemfile/systembuild/server/NS/*  /opt/systembuild/server/NS
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/NS/release/$ns/nserver.zip
   sudo mv nserver.zip /opt/systembuild/server/NS
   cd /opt/systembuild/server/NS
   sudo unzip nserver.zip
   sudo rm -rf NS_current
   sudo mv NS-* NS_current
   sudo rm -rf NS_current/*.bat
   sudo rm -rf *.zip
   cd /opt/systembuild/server/NS/NS_current
   sudo rm -rf application-${env}.yml
   sudo rm -rf application.yml
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/NS/release/$ns/setting/application-${env}.yml
   sudo mv application-${env}.yml application-linux.yml
fi

}

function nsModuleFileCheck {
if [ $ns == "uninstall" ]
then
   echo "I don't need to install ns"
else
   sudo /opt/systemfile/config/./autoconfig.sh -module "NS" -env ${env} -version ${ns} -dbip ${dbip}
   sleep 5
   nsServiceUrl=NS/release/$ns/nserver.zip
   nsSettingUrl=NS/release/$ns/setting/application-${env}.yml
   nsServiceUrlCheck=$( checkNewFtpUrl $nsServiceUrl )
   nsSettingUrlCheck=$( checkNewFtpUrl $nsSettingUrl )
   if [ $nsSettingUrlCheck == "exist" ]
   then
	  array[5]=ok
   else
      array[5]=$nsSettingUrl
   fi
   if [ $nsServiceUrlCheck == "exist" ]
   then
	  array[6]=ok
   else
      array[6]=$nsServiceUrl
   fi
   fi
}


function inparkModule {
if [ $inpark == "uninstall" ]
then
   echo "I don't need to install inpark"
else
   sudo mkdir -p  /opt/systembuild/server/INPARK
   sudo cp -R  /opt/systemfile/systembuild/server/INPARK/*  /opt/systembuild/server/INPARK
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/INPARK/release/$inpark/inpark.war
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/INPARK/release/$inpark/setting/application-${env}.yml
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/INPARK/release/$inpark/log4j2/logback-spring-${env}.xml
   sudo rm -rf /opt/systembuild/server/INPARK/config/*.yml
   sudo rm -rf /opt/systembuild/server/INPARK/config/*.xml
   sudo rm -rf /opt/systembuild/server/INPARK/inpark.war
   sudo mv inpark.war /opt/systembuild/server/INPARK/INPARK
   sudo mv application-${env}.yml /opt/systembuild/server/INPARK/INPARK/config/
   sudo mv logback-spring-${env}.xml /opt/systembuild/server/INPARK/INPARK/config/
   sudo mv /opt/systembuild/server/INPARK/INPARK/config/application-${env}.yml /opt/systembuild/server/INPARK/INPARK/config/application.yml
   sudo mv /opt/systembuild/server/INPARK/INPARK/config/logback-spring-${env}.xml /opt/systembuild/server/INPARK/INPARK/config/logback-spring.xml
fi

}

function inparkModuleFileCheck {
if [ $inpark == "uninstall" ]
then
   echo "I don't need to install inpark"
else
   sudo /opt/systemfile/config/./autoconfig.sh -module "INPARK" -env ${env} -version ${inpark} -dbip ${dbip}
   sleep 5
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/INPARK/release/${inpark}/log4j2/logback-spring.xml
   sudo mv  logback-spring.xml logback-spring-${env}.xml
   sudo /bin/curl -T logback-spring-${env}.xml   -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/INPARK/release/$inpark/log4j2/
   inparkServiceUrl=INPARK/release/$inpark/inpark.war
   inparkSettingUrl=INPARK/release/$inpark/setting/application-${env}.yml
   inparkLog4j2Url=INPARK/release/$inpark/log4j2/logback-spring-${env}.xml
   inparkLog4j2UrlCheck=$( checkNewFtpUrl $inparkLog4j2Url )
   inparkServiceUrlCheck=$( checkNewFtpUrl $inparkServiceUrl )
   inparkSettingUrlCheck=$( checkNewFtpUrl $inparkSettingUrl )
   if [ $inparkSettingUrlCheck == "exist" ]
   then
	  array[7]=ok
   else
      array[7]=$inparkSettingUrl
   fi
   if [ $inparkServiceUrlCheck == "exist" ]
   then
	  array[8]=ok
   else
      array[8]=$inparkServiceUrl
   fi
   if [ $inparkLog4j2UrlCheck == "exist" ]
   then
	  array[40]=ok
   else
      array[40]=$inparkLog4j2Url
   fi      
   fi
}


function edgeModule {
if [ $edge == "uninstall" ]
then
   echo "I don't need to install edge"
else
   sudo mkdir -p  /opt/systembuild/server/EDGE
   sudo cp -R  /opt/systemfile/systembuild/server/EDGE/*  /opt/systembuild/server/EDGE
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/EDGE/release/$edge/EdgeServer.jar
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/EDGE/release/$edge/setting/application-INPARK.yml
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/EDGE/release/$edge/setting/application-INFACTORY.yml
   sudo rm -rf /opt/systembuild/server/EDGE/EDGE/config/*.yml
   sudo rm -rf /opt/systembuild/server/EDGE/EDGE/EdgeServer.jar
   sudo mv EdgeServer.jar /opt/systembuild/server/EDGE/EDGE
   sudo mv application-INPARK.yml application-INFACTORY.yml /opt/systembuild/server/EDGE/EDGE/config/
fi
}

function edgeModuleFileCheck {
if [ $edge == "uninstall" ]
then
   echo "I don't need to install edge"
else
   edgeServiceUrl=EDGE/release/$edge/EdgeServer.jar
   edgeSetting1Url=EDGE/release/$edge/setting/application-INPARK.yml
   edgeSetting2Url=EDGE/release/$edge/setting/application-INFACTORY.yml
   edgeServiceUrlCheck=$( checkNewFtpUrl $edgeServiceUrl )
   edgeSetting1UrlCheck=$( checkNewFtpUrl $edgeSetting1Url )
   edgeSetting2UrlCheck=$( checkNewFtpUrl $edgeSetting2Url )
   if [ $edgeSetting1UrlCheck == "exist" ]
   then
	  array[9]=ok
   else
      array[9]=$edgeSetting1Url
   fi
   if [ $edgeSetting2UrlCheck == "exist" ]
   then
	  array[39]=ok
   else
      array[39]=$edgeSetting2Url
   fi
   if [ $edgeServiceUrlCheck == "exist" ]
   then
	  array[10]=ok
   else
      array[10]=$edgeServiceUrl
   fi
   fi
}


function chartModule {
if [ $chart == "uninstall" ]
then
   echo "I don't need to install chart"
else
   sudo mkdir -p  /opt/systembuild/server/CHART
   sudo cp -R  /opt/systemfile/systembuild/server/CHART/*  /opt/systembuild/server/CHART
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/CHART/release/$chart/ChartService.jar
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/CHART/release/$chart/setting/application-${env}.yml
   sudo rm -rf /opt/systembuild/server/CHART/config/*.yml
   sudo rm -rf /opt/systembuild/server/CHART/ChartService.jar
   sudo mv ChartService.jar /opt/systembuild/server/CHART
   sudo mv application-${env}.yml /opt/systembuild/server/CHART/config/
   sudo mv /opt/systembuild/server/CHART/config/application-${env}.yml /opt/systembuild/server/CHART/config/application.yml
fi
}

function chartModuleFileCheck {
if [ $chart == "uninstall" ]
then
   echo "I don't need to install chart"
else
   sudo /opt/systemfile/config/./autoconfig.sh -module "CHART" -env ${env} -version ${chart} -dbip ${dbip}
   sleep 5
   chartServiceUrl=CHART/release/$chart/ChartService.jar
   chartSettingUrl=CHART/release/$chart/setting/application-${env}.yml
   chartServiceUrlCheck=$( checkNewFtpUrl $chartServiceUrl )
   chartSettingUrlCheck=$( checkNewFtpUrl $chartSettingUrl )
   if [ $chartSettingUrlCheck == "exist" ]
   then
	  array[11]=ok
   else
      array[11]=$chartSettingUrl
   fi
   if [ $chartServiceUrlCheck == "exist" ]
   then
	  array[12]=ok
   else
      array[12]=$chartServiceUrl
   fi
fi
}


function inemsModule {
if [ $inems == "uninstall" ]
then
   echo "I don't need to install inems"
else
   sudo mkdir -p  /opt/systembuild/server/INEMS
   sudo cp -R  /opt/systemfile/systembuild/server/INEMS/*  /opt/systembuild/server/INEMS
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/INEMS/release/$inems/inems.war
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/INEMS/release/$inems/setting/application-${env}.yml
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/INEMS/release/$inems/log4j2/logback-spring-${env}.xml
   sudo rm -rf /opt/systembuild/server/INEMS/INEMS/config/*.yml
   sudo rm -rf /opt/systembuild/server/INEMS/INEMS/config/*.xml
   sudo rm -rf /opt/systembuild/server/INEMS/INEMS/inems.war
   sudo mv inems.war /opt/systembuild/server/INEMS/INEMS
   sudo mv application-${env}.yml /opt/systembuild/server/INEMS/INEMS/config/
   sudo mv logback-spring-${env}.xml /opt/systembuild/server/INEMS/INEMS/config/
   sudo mv /opt/systembuild/server/INEMS/INEMS/config/application-${env}.yml /opt/systembuild/server/INEMS/INEMS/config/application.yml
   sudo mv /opt/systembuild/server/INEMS/INEMS/config/logback-spring-${env}.xml /opt/systembuild/server/INEMS/INEMS/config/logback-spring.xml
fi

}

function inemsModuleFileCheck {
if [ $inems == "uninstall" ]
then
   echo "I don't need to install inems"
else
   sudo /opt/systemfile/config/./autoconfig.sh -module "INEMS" -env ${env} -version ${inems} -dbip ${dbip}
   sleep 5
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/INEMS/release/${inems}/log4j2/logback-spring.xml
   sudo mv  logback-spring.xml logback-spring-${env}.xml
   sudo /bin/curl -T logback-spring-${env}.xml   -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/INEMS/release/$inems/log4j2/
   inemsServiceUrl=INEMS/release/$inems/inems.war
   inemsSettingUrl=INEMS/release/$inems/setting/application-${env}.yml
   inemsLog4j2Url=INEMS/release/$inems/log4j2/logback-spring-${env}.xml
   inemsServiceUrlCheck=$( checkNewFtpUrl $inemsServiceUrl )
   inemsSettingUrlCheck=$( checkNewFtpUrl $inemsSettingUrl )
   inemsLog4j2UrlCheck=$( checkNewFtpUrl $inemsLog4j2Url )
   if [ $inemsSettingUrlCheck == "exist" ]
   then
	  array[13]=ok
   else
      array[13]=$inemsSettingUrl
   fi
   if [ $inemsServiceUrlCheck == "exist" ]
   then
	  array[14]=ok
   else
      array[14]=$inemsServiceUrl
   fi
   if [ $inemsLog4j2UrlCheck == "exist" ]
   then
	  array[15]=ok
   else
      array[15]=$inemsLog4j2Url
   fi   
   fi
}


function statisticModule {
if [ $statistic == "uninstall" ]
then
   echo "I don't need to install statistic"
else
   sudo mkdir -p  /opt/systembuild/server/StatisticService
   sudo cp -R  /opt/systemfile/systembuild/server/StatisticService/*  /opt/systembuild/server/StatisticService
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/STATISTIC/release/$statistic/StatisticService.jar
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/STATISTIC/release/$statistic/setting/application-${env}.yml
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/STATISTIC/release/$statistic/log4j2/log4j2.properties
   sudo rm -rf /opt/systembuild/server/StatisticService/StatisticService/config/*.yml
   sudo rm -rf /opt/systembuild/server/StatisticService/StatisticService/config/log4j2.properties
   sudo rm -rf /opt/systembuild/server/StatisticService/StatisticService/StatisticService.jar
   sudo mv StatisticService.jar /opt/systembuild/server/StatisticService/StatisticService
   sudo mv application-${env}.yml /opt/systembuild/server/StatisticService/StatisticService/config/
   sudo mv log4j2.properties /opt/systembuild/server/StatisticService/StatisticService/config/
   sudo mv /opt/systembuild/server/StatisticService/StatisticService/config/application-${env}.yml /opt/systembuild/server/StatisticService/StatisticService/config/application.yml
   if [ ${dbip} != "127.0.0.1" ]
   then
		sudo rm -rf /opt/systembuild/server/StatisticService/tomcat/webapps/ROOT*
		cd /opt/systemfile/obsidian
		sudo cp -f xmltesting/project_generator.xml .
		sudo sed -i "s/127.0.0.1/${dbip}/g"  project_generator.xml
		sudo ./run.sh
		sudo cp -f ROOT.war  /opt/systembuild/server/StatisticService/tomcat/webapps
   fi
fi

}

function statisticModuleFileCheck {
if [ $statistic == "uninstall" ]
then
   echo "I don't need to install statistic"
else
   sudo /opt/systemfile/config/./autoconfig.sh -module "STATISTIC" -env ${env} -version ${statistic} -dbip ${dbip}
   sleep 5
   statisticServiceUrl=STATISTIC/release/$statistic/StatisticService.jar
   statisticSettingUrl=STATISTIC/release/$statistic/setting/application-${env}.yml
   statisticLog4j2Url=STATISTIC/release/$statistic/log4j2/log4j2.properties
   statisticServiceUrlCheck=$( checkNewFtpUrl $statisticServiceUrl )
   statisticSettingUrlCheck=$( checkNewFtpUrl $statisticSettingUrl )
   statisticLog4j2UrlCheck=$( checkNewFtpUrl $statisticLog4j2Url )
   if [ $statisticSettingUrlCheck == "exist" ]
   then
	  array[16]=ok
   else
      array[16]=$statisticSettingUrl
   fi
   if [ $statisticServiceUrlCheck == "exist" ]
   then
	  array[17]=ok
   else
      array[17]=$statisticServiceUrl
   fi
   if [ $statisticLog4j2UrlCheck == "exist" ]
   then
	  array[18]=ok
   else
      array[18]=$statisticLog4j2Url
   fi   
fi
}


function statisticCacheModule {
if [ $statisticcache == "uninstall" ]
then
   echo "I don't need to install statisticcache"
else
   sudo mkdir -p  /opt/systembuild/server/StatisticCacheService
   sudo cp -R  /opt/systemfile/systembuild/server/StatisticCacheService/*  /opt/systembuild/server/StatisticCacheService
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/STATISTICCACHE/release/$statisticcache/StatisticCacheService.jar
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/STATISTICCACHE/release/$statisticcache/setting/application-${env}.yml
   sudo rm -rf /opt/systembuild/server/StatisticCacheService/StatisticCacheService/config/*.yml
   sudo rm -rf /opt/systembuild/server/StatisticCacheService/StatisticCacheService/StatisticCacheService.jar
   sudo mv StatisticCacheService.jar /opt/systembuild/server/StatisticCacheService/StatisticCacheService
   sudo mv application-${env}.yml /opt/systembuild/server/StatisticCacheService/StatisticCacheService/config/
   sudo mv /opt/systembuild/server/StatisticCacheService/StatisticCacheService/config/application-${env}.yml /opt/systembuild/server/StatisticCacheService/StatisticCacheService/config/application.yml
fi

}

function statisticCacheModuleFileCheck {
if [ $statisticcache == "uninstall" ]
then
   echo "I don't need to install statisticcache"
else
   sudo /opt/systemfile/config/./autoconfig.sh -module "STATISTICCACHE" -env ${env} -version ${statisticcache} -dbip ${dbip}
   sleep 5
   statisticcacheServiceUrl=STATISTICCACHE/release/$statisticcache/StatisticCacheService.jar
   statisticcacheSettingUrl=STATISTICCACHE/release/$statisticcache/setting/application-${env}.yml
   statisticcacheServiceUrlCheck=$( checkNewFtpUrl $statisticcacheServiceUrl )
   statisticcacheSettingUrlCheck=$( checkNewFtpUrl $statisticcacheSettingUrl )
   if [ $statisticcacheSettingUrlCheck == "exist" ]
   then
	  array[19]=ok
   else
      array[19]=$statisticcacheSettingUrl
   fi
   if [ $statisticcacheServiceUrlCheck == "exist" ]
   then
	  array[20]=ok
   else
      array[20]=$statisticcacheServiceUrl
   fi
   fi
}

function infactoryBackendModule {
if [ $infactorybackend == "uninstall" ]
then
   echo "I don't need to install infactoryBackend"
else
   sudo mkdir -p  /opt/systembuild/server/INFACTORY-BACKEND
   sudo cp -R  /opt/systemfile/systembuild/server/INFACTORY-BACKEND/*  /opt/systembuild/server/INFACTORY-BACKEND
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/INFACTORY-BACKEND/release/$infactorybackend/infactory-backend.jar
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/INFACTORY-BACKEND/release/$infactorybackend/setting/application-${env}.yml
   sudo rm -rf /opt/systembuild/server/INFACTORY-BACKEND/INFACTORY-BACKEND/config/*.yml
   sudo rm -rf /opt/systembuild/server/INFACTORY-BACKEND/INFACTORY-BACKEND/infactory-backend.jar
   sudo mv infactory-backend.jar /opt/systembuild/server/INFACTORY-BACKEND/INFACTORY-BACKEND
   sudo mv application-${env}.yml /opt/systembuild/server/INFACTORY-BACKEND/INFACTORY-BACKEND/config/
   sudo mv /opt/systembuild/server/INFACTORY-BACKEND/INFACTORY-BACKEND/config/application-${env}.yml /opt/systembuild/server/INFACTORY-BACKEND/INFACTORY-BACKEND/config/application.yml   
fi

}

function infactoryBackendModuleFileCheck {
if [ $infactorybackend == "uninstall" ]
then
   echo "I don't need to install infactoryBackend"
else
   sudo /opt/systemfile/config/./autoconfig.sh -module "INFACTORY-BACKEND" -env ${env} -version ${infactorybackend} -dbip ${dbip}
   sleep 5
   infactorybackendServiceUrl=INFACTORY-BACKEND/release/$infactorybackend/infactory-backend.jar
   infactorybackendSettingUrl=INFACTORY-BACKEND/release/$infactorybackend/setting/application-${env}.yml
   infactorybackendServiceUrlCheck=$( checkNewFtpUrl $infactorybackendServiceUrl )
   infactorybackendSettingUrlCheck=$( checkNewFtpUrl $infactorybackendSettingUrl )
   if [ $infactorybackendSettingUrlCheck == "exist" ]
   then
	  array[21]=ok
   else
      array[21]=$infactorybackendSettingUrl
   fi
   if [ $infactorybackendServiceUrlCheck == "exist" ]
   then
	  array[22]=ok
   else
      array[22]=$infactorybackendServiceUrl
   fi
fi
}

function simpleruleModule {
if [ $simplerule == "uninstall" ]
then
   echo "I don't need to install simplerule"
else
   sudo mkdir -p  /opt/systembuild/server/SIMPLERULE
   sudo cp -R  /opt/systemfile/systembuild/server/SIMPLERULE/*  /opt/systembuild/server/SIMPLERULE
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/SIMPLERULE/release/$simplerule/SimpleRuleService.jar
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/SIMPLERULE/release/$simplerule/setting/application-${env}.yml
   sudo rm -rf /opt/systembuild/server/SIMPLERULE/SIMPLERULE/config/*.yml
   sudo rm -rf /opt/systembuild/server/SIMPLERULE/SIMPLERULE/SimpleRuleService.jar
   sudo mv infactory-backend.jar /opt/systembuild/server/SIMPLERULE/SIMPLERULE
   sudo mv application-${env}.yml /opt/systembuild/server/SIMPLERULE/SIMPLERULE/config/
   sudo mv /opt/systembuild/server/SIMPLERULE/SIMPLERULE/config/application-${env}.yml /opt/systembuild/server/SIMPLERULE/SIMPLERULE/config/application.yml   
fi

}

function simpleruleModuleFileCheck {
if [ $simplerule == "uninstall" ]
then
   echo "I don't need to install simplerule"
else
   sudo /opt/systemfile/config/./autoconfig.sh -module "SIMPLERULE" -env ${env} -version ${simplerule} -dbip ${dbip}
   sleep 5
   simpleruleServiceUrl=SIMPLERULE/release/$simplerule/SimpleRuleService.jar
   simpleruleSettingUrl=SIMPLERULE/release/$simplerule/setting/application-${env}.yml
   simpleruleServiceUrlCheck=$( checkNewFtpUrl $simpleruleServiceUrl )
   simpleruleSettingUrlCheck=$( checkNewFtpUrl $simpleruleSettingUrl )
   if [ $simpleruleSettingUrlCheck == "exist" ]
   then
	  array[37]=ok
   else
      array[37]=$simpleruleSettingUrl
   fi
   if [ $simpleruleServiceUrlCheck == "exist" ]
   then
	  array[38]=ok
   else
      array[38]=$simpleruleServiceUrl
   fi
fi
}

function ecbjModule {

if [ $ecbj == "uninstall" ]
then
   echo "I don't need to install ectuarybj"
else
   sudo mkdir -p  /opt/systembuild/Tomcat/tomcatECBJ
   sudo cp -f -R  /opt/systemfile/systembuild/Tomcat/tomcatECBJ/*  /opt/systembuild/Tomcat/tomcatECBJ
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/ECBJ/release/$ecbj/ecbj.war
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/ECBJ/release/$ecbj/setting/setting-${env}.properties
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/ECBJ/release/$ecbj/log4j2/log4j2-${env}.properties
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/ECBJ/release/$ecbj/schedule-config/schedule-config-${env}.xml
   sudo rm -rf /opt/systembuild/Tomcat/tomcatECBJ/webapps/ROOT
   sudo rm -rf /opt/systembuild/Tomcat/tomcatECBJ/webapps/setting-${env}.properties
   sudo rm -rf /opt/systembuild/Tomcat/tomcatECBJ/webapps/log4j2-${env}.properties
   sudo rm -rf /opt/systembuild/Tomcat/tomcatECBJ/webapps/schedule-config-${env}.xml
   sudo mv ecbj.war /opt/systembuild/Tomcat/tomcatECBJ/webapps/
   sudo mv setting-${env}.properties /opt/systembuild/Tomcat/tomcatECBJ/webapps/
   sudo mv log4j2-${env}.properties /opt/systembuild/Tomcat/tomcatECBJ/webapps/
   sudo mv schedule-config-${env}.xml /opt/systembuild/Tomcat/tomcatECBJ/webapps/
   cd /opt/systembuild/Tomcat/tomcatECBJ/webapps
   sudo unzip ecbj.war -d ROOT
   sudo rm -rf /opt/systembuild/Tomcat/tomcatECBJ/webapps/ROOT/WEB-INF/classes/setting-${env}.properties
   sudo rm -rf /opt/systembuild/Tomcat/tomcatECBJ/webapps/ROOT/WEB-INF/classes/setting.properties
   sudo rm -rf /opt/systembuild/Tomcat/tomcatECBJ/webapps/ROOT/WEB-INF/classes/log4j2-${env}.properties
   sudo rm -rf /opt/systembuild/Tomcat/tomcatECBJ/webapps/ROOT/WEB-INF/classes/log4j2.properties
   sudo rm -rf /opt/systembuild/Tomcat/tomcatECBJ/webapps/ROOT/WEB-INF/classes/schedule-config-${env}.xml
   sudo rm -rf /opt/systembuild/Tomcat/tomcatECBJ/webapps/ROOT/WEB-INF/classes/schedule-config.xml
   sudo mv setting-${env}.properties /opt/systembuild/Tomcat/tomcatECBJ/webapps/ROOT/WEB-INF/classes/
   sudo mv log4j2-${env}.properties /opt/systembuild/Tomcat/tomcatECBJ/webapps/ROOT/WEB-INF/classes/
   sudo mv schedule-config-${env}.xml /opt/systembuild/Tomcat/tomcatECBJ/webapps/ROOT/WEB-INF/classes/
   sudo mv /opt/systembuild/Tomcat/tomcatECBJ/webapps/ROOT/WEB-INF/classes/setting-${env}.properties /opt/systembuild/Tomcat/tomcatECBJ/webapps/ROOT/WEB-INF/classes/setting.properties
   sudo mv /opt/systembuild/Tomcat/tomcatECBJ/webapps/ROOT/WEB-INF/classes/log4j2-${env}.properties /opt/systembuild/Tomcat/tomcatECBJ/webapps/ROOT/WEB-INF/classes/log4j2.properties
   sudo mv /opt/systembuild/Tomcat/tomcatECBJ/webapps/ROOT/WEB-INF/classes/schedule-config-${env}.xml /opt/systembuild/Tomcat/tomcatECBJ/webapps/ROOT/WEB-INF/classes/schedule-config.xml
   sudo rm -rf ecbj.war
fi

}

function ecbjModuleFileCheck {
if [ $ecbj == "uninstall" ]
then
   echo "I don't need to install ecbj"
else
   sudo /opt/systemfile/config/./autoconfig.sh -module "ECBJ" -env ${env} -version ${ecbj} -dbip ${dbip}
   sleep 5
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/ECBJ/release/$ecbj/log4j2/log4j2.properties
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/ECBJ/release/$ecbj/schedule-config/schedule-config.xml
   sudo mv log4j2.properties log4j2-${env}.properties
   sudo mv schedule-config.xml schedule-config-${env}.xml
   sudo /bin/curl -T log4j2-${env}.properties   -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/ECBJ/release/$ecbj/log4j2/
   sudo /bin/curl -T schedule-config-${env}.xml   -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/ECBJ/release/$ecbj/schedule-config/
   sudo rm -rf log4j2-${env}.properties  schedule-config-${env}.xml
   ecbjServiceUrl=ECBJ/release/$ecbj/ecbj.war
   ecbjSettingUrl=ECBJ/release/$ecbj/setting/setting-${env}.properties
   ecbjLog4j2Url=ECBJ/release/$ecbj/log4j2/log4j2-${env}.properties
   ecbjScheduleUrl=ECBJ/release/$ecbj/schedule-config/schedule-config-${env}.xml
   ecbjServiceUrlCheck=$( checkNewFtpUrl $ecbjServiceUrl )
   ecbjSettingUrlCheck=$( checkNewFtpUrl $ecbjSettingUrl )
   ecbjLog4j2UrlCheck=$( checkNewFtpUrl $ecbjLog4j2Url ) 
   ecbjScheduleUrlCheck=$( checkNewFtpUrl $ecbjScheduleUrl )    
   if [ $ecbjSettingUrlCheck == "exist" ]
   then
	  array[23]=ok
   else
      array[23]=$ecbjSettingUrl
   fi
   if [ $ecbjLog4j2UrlCheck == "exist" ]
   then
	  array[24]=ok
   else
      array[24]=$ecbjLog4j2Url
   fi
   if [ $ecbjScheduleUrlCheck == "exist" ]
   then
	  array[25]=ok
   else
      array[25]=$ecbjScheduleUrl
   fi   
   if [ $ecbjServiceUrlCheck == "exist" ]
   then
	  array[26]=ok
   else
      array[26]=$ecbjServiceUrl
   fi
fi
}

function authModule {
if [ $auth == "uninstall" ]
then
   echo "I don't need to install auth"
else
   sudo mkdir -p  /opt/systembuild/Tomcat/tomcatAUTH
   sudo cp -f -R  /opt/systemfile/systembuild/Tomcat/tomcatAUTH/*  /opt/systembuild/Tomcat/tomcatAUTH
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://140.92.88.146:2100/ftp/AUTH/release/$auth/ec.war
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://140.92.88.146:2100/ftp/AUTH/release/$auth/setting/setting-${env}.properties
   sudo rm -rf /opt/systembuild/Tomcat/tomcatAUTH/webapps/ec*
   sudo rm -rf /opt/systembuild/Tomcat/tomcatAUTH/webapps/setting-${env}.properties
   sudo mv ec.war /opt/systembuild/Tomcat/tomcatAUTH/webapps/
   sudo mv setting-${env}.properties /opt/systembuild/Tomcat/tomcatAUTH/webapps/
   cd /opt/systembuild/Tomcat/tomcatAUTH/webapps
   sudo unzip ec.war -d ec
   sudo rm -rf /opt/systembuild/Tomcat/tomcatAUTH/webapps/ec/WEB-INF/classes/deploy-setting.properties
   sudo mv setting-${env}.properties /opt/systembuild/Tomcat/tomcatAUTH/webapps/ec/WEB-INF/classes/
   sudo mv /opt/systembuild/Tomcat/tomcatAUTH/webapps/ec/WEB-INF/classes/setting-${env}.properties /opt/systembuild/Tomcat/tomcatAUTH/webapps/ec/WEB-INF/classes/deploy-setting.properties
fi

}

function authModuleFileCheck {
if [ $auth == "uninstall" ]
then
   echo "I don't need to install auth"
else
   authServiceUrl=AUTH/release/$auth/ec.war
   authSettingUrl=AUTH/release/$auth/setting/setting-${env}.properties
   authServiceUrlCheck=$( checkFtpUrl $authServiceUrl )
   authSettingUrlCheck=$( checkFtpUrl $authSettingUrl )
   if [ $authSettingUrlCheck == "exist" ]
   then
	  array[27]=ok
   else
      array[27]=$authSettingUrl
   fi
   if [ $authServiceUrlCheck == "exist" ]
   then
	  array[28]=ok
   else
      array[28]=$authServiceUrl
   fi
fi
}

function isasModule {
if [ $isas == "uninstall" ]
then
   echo "I don't need to install isas"
else
   sudo mkdir -p  /opt/systembuild/Tomcat/tomcatISAS
   sudo cp -f -R  /opt/systemfile/systembuild/Tomcat/tomcatISAS/*  /opt/systembuild/Tomcat/tomcatISAS
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://140.92.88.146:2100/ftp/ISAS/release/$isas/api.war
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://140.92.88.146:2100/ftp/ISAS/release/$isas/setting/setting-${env}.properties
   sudo rm -rf /opt/systembuild/Tomcat/tomcatISAS/webapps/api*
   sudo rm -rf /opt/systembuild/Tomcat/tomcatISAS/webapps/setting-${env}.properties
   sudo mv api.war /opt/systembuild/Tomcat/tomcatISAS/webapps/
   sudo mv setting-${env}.properties /opt/systembuild/Tomcat/tomcatISAS/webapps/
   cd /opt/systembuild/Tomcat/tomcatISAS/webapps
   sudo unzip api.war -d api
   sudo rm -rf /opt/systembuild/Tomcat/tomcatISAS/webapps/api/WEB-INF/classes/deploy-setting.properties
   sudo mv setting-${env}.properties /opt/systembuild/Tomcat/tomcatISAS/webapps/api/WEB-INF/classes/
   sudo mv /opt/systembuild/Tomcat/tomcatISAS/webapps/api/WEB-INF/classes/setting-${env}.properties /opt/systembuild/Tomcat/tomcatISAS/webapps/api/WEB-INF/classes/deploy-setting.properties
fi

}

function isasModuleFileCheck {
if [ $isas == "uninstall" ]
then
   echo "I don't need to install isas"
else
   isasServiceUrl=ISAS/release/$isas/api.war
   isasSettingUrl=ISAS/release/$isas/setting/setting-${env}.properties
   isasServiceUrlCheck=$( checkFtpUrl $isasServiceUrl )
   isasSettingUrlCheck=$( checkFtpUrl $isasSettingUrl )
   if [ $isasSettingUrlCheck == "exist" ]
   then
	  array[29]=ok
   else
      array[29]=$isasSettingUrl
   fi
   if [ $isasServiceUrlCheck == "exist" ]
   then
	  array[30]=ok
   else
      array[30]=$isasServiceUrl
   fi
fi
}

function icaModule {
if [ $ica == "uninstall" ]
then
   echo "I don't need to install ica"
else
   sudo mkdir -p  /opt/systembuild/server/ICA
   sudo cp -R  /opt/systemfile/systembuild/server/ICA/*  /opt/systembuild/server/ICA
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/CommonAPI/release/$ica/InsynergerCommonAPI.jar
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/CommonAPI/release/$ica/setting/application-${env}.yml
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/CommonAPI/release/$ica/log4j2/log4j2.properties
   sudo rm -rf /opt/systembuild/server/ICA/ICA/config/*.yml
   sudo rm -rf /opt/systembuild/server/ICA/ICA/config/*.properties
   sudo rm -rf /opt/systembuild/server/ICA/ICA/InsynergerCommonAPI.jar
   sudo mv InsynergerCommonAPI.jar /opt/systembuild/server/ICA/ICA
   sudo mv application-${env}.yml /opt/systembuild/server/ICA/ICA/config/
   sudo mv log4j2.properties /opt/systembuild/server/ICA/ICA/config/
   sudo mv /opt/systembuild/server/ICA/ICA/config/application-${env}.yml /opt/systembuild/server/ICA/ICA/config/application.yml
fi

}

function icaModuleFileCheck {
if [ $ica == "uninstall" ]
then
   echo "I don't need to install ica"
else
   sudo /opt/systemfile/config/./autoconfig.sh -module "CommonAPI" -env ${env} -version ${ica} -dbip ${dbip}
   sleep 5
   icaServiceUrl=CommonAPI/release/$ica/InsynergerCommonAPI.jar
   icaSettingUrl=CommonAPI/release/$ica/setting/application-${env}.yml
   icaLog4j2Url=CommonAPI/release/$ica/log4j2/log4j2.properties
   icaServiceUrlCheck=$( checkNewFtpUrl $icaServiceUrl )
   icaSettingUrlCheck=$( checkNewFtpUrl $icaSettingUrl )
   icaLog4j2UrlCheck=$( checkNewFtpUrl $icaLog4j2Url )   
   if [ $icaSettingUrlCheck == "exist" ]
   then
	  array[31]=ok
   else
      array[31]=$icaSettingUrl
   fi
   if [ $icaServiceUrlCheck == "exist" ]
   then
	  array[32]=ok
   else
      array[32]=$icaServiceUrl
   fi  
   if [ $icaLog4j2UrlCheck == "exist" ]
   then
	  array[33]=ok
   else
      array[33]=$icaLog4j2Url
   fi    
fi
}

function authcenterModule {
if [ $authcenter == "uninstall" ]
then
   echo "I don't need to install AUTHCENTER"
else
   sudo mkdir -p  /opt/systembuild/server/AUTHCENTER
   sudo cp -R  /opt/systemfile/systembuild/server/AUTHCENTER/*  /opt/systembuild/server/AUTHCENTER
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/AUTHCENTER/release/$authcenter/AuthCenter.jar
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/AUTHCENTER/release/$authcenter/setting/application-${env}.yml
   sudo rm -rf /opt/systembuild/server/AUTHCENTER/AUTHCENTER/config/*.yml
   sudo rm -rf /opt/systembuild/server/AUTHCENTER/AUTHCENTER/AuthCenter.jar
   sudo mv AuthCenter.jar /opt/systembuild/server/AUTHCENTER/AUTHCENTER
   sudo mv application-${env}.yml /opt/systembuild/server/AUTHCENTER/AUTHCENTER/config/
   sudo mv /opt/systembuild/server/AUTHCENTER/AUTHCENTER/config/application-${env}.yml /opt/systembuild/server/AUTHCENTER/AUTHCENTER/config/application.yml
fi

}

function authcenterModuleFileCheck {
if [ $authcenter == "uninstall" ]
then
   echo "I don't need to install authcenter"
else
   sudo /opt/systemfile/config/./autoconfig.sh -module "AUTHCENTER" -env ${env} -version ${authcenter} -dbip ${dbip}
   sleep 5
   authcenterServiceUrl=AUTHCENTER/release/$authcenter/AuthCenter.jar
   authcenterSettingUrl=AUTHCENTER/release/$authcenter/setting/application-${env}.yml
   authcenterServiceUrlCheck=$( checkNewFtpUrl $authcenterServiceUrl )
   authcenterSettingUrlCheck=$( checkNewFtpUrl $authcenterSettingUrl )
   if [ $authcenterSettingUrlCheck == "exist" ]
   then
	  array[34]=ok
   else
      array[34]=$authcenterSettingUrl
   fi
   if [ $authcenterServiceUrlCheck == "exist" ]
   then
	  array[35]=ok
   else
      array[35]=$authcenterServiceUrl
   fi      
fi
}

function infactory-frontendModule {
if [ $infactoryfrontend == "uninstall" ]
then
   echo "I don't need to install infactoryfrontend"
else
   sudo mkdir -p  /opt/systembuild/Tomcat/tomcatINFACTORY-FRONTEND
   sudo cp -R  /opt/systemfile/systembuild/Tomcat/tomcatINFACTORY-FRONTEND/*  /opt/systembuild/Tomcat/tomcatINFACTORY-FRONTEND
   sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/INFACTORY-FRONTEND/release/$infactoryfrontend/InFactoryFrontEnd.zip
   sudo rm -rf /opt/systembuild/Tomcat/tomcatINFACTORY-FRONTEND/webapps/ROOT*
   sudo mv InFactoryFrontEnd.zip /opt/systembuild/Tomcat/tomcatINFACTORY-FRONTEND/webapps/
   cd /opt/systembuild/Tomcat/tomcatINFACTORY-FRONTEND/webapps/
   sudo unzip InFactoryFrontEnd.zip
   sleep 2
   sudo mv InFactoryFrontEnd ROOT
   sudo rm -rf /opt/systembuild/Tomcat/tomcatINFACTORY-FRONTEND/webapps/InFactoryFrontEnd.zip
fi

}

function infactory-frontendModuleFileCheck {
if [ $infactoryfrontend == "uninstall" ]
then
   echo "I don't need to install infactoryfrontend"
else
#   sudo /opt/systemfile/config/./autoconfig.sh -module "INFACTORY-FRONTEND" -env ${env} -version ${infactoryfrontend} -dbip ${dbip}
#   sleep 5
   infactoryfrontendServiceUrl=INFACTORY-FRONTEND/release/$infactoryfrontend/InFactoryFrontEnd.zip
   infactoryfrontendServiceUrlCheck=$( checkNewFtpUrl $infactoryfrontendServiceUrl )
   if [ $infactoryfrontendServiceUrlCheck == "exist" ]
   then
	  array[36]=ok
   else
      array[36]=$infactoryfrontendServiceUrl
   fi      
fi
}


function checkFtpUrl() {
curl -I --silent -u upload:Hk4g4hk4g4123 ftp://140.92.88.146:2100/ftp/$1 >/dev/null
if [ $? -eq 0 ]
then
    echo "exist"
else
    echo "notexist"
fi
}

function checkNewFtpUrl() {
curl -I --silent -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/$1 >/dev/null
if [ $? -eq 0 ]
then
    echo "exist"
else
    echo "notexist"
fi
}

function PgCollectModule {
   sudo rm -rf /opt/systembuild*
   sudo mkdir -p /opt/systembuild
   sudo cp -f  /opt/systemfile/systembuild/*.zip /opt/systembuild
   sudo cp -f -R /opt/systemfile/systembuild/postgres /opt/systembuild
}

function collectschema {
   echo $project
   sudo cp -f schema/ems_ddl_postgresql_pg11.sql sql/ddl.sql
   sudo cp -f schema/ems_dml_postgresql.sql sql/dml.sql
   sudo cp -f schema/ems_dml_ATTRID_MAPPING.sql sql/attrid.sql
   sudo cp schema/ems_dml_table_partition_postgresql.sql  sql/partition.sql   
   sudo cp -f schema/ACL/ACL_for_postgres.sql sql/acl.sql
   sudo cp -f schema/quartz/table_postgresql.sql sql/quartz.sql
   sudo cp -f schema/oauth/postgresql_oauth_table_schema.sql sql/oauth.sql
   sudo cp -f schema/DCL/grant.sql sql
   sudo cp -f schema/DCL/create.sql sql
}

function errorCheck {
for i in "${array[@]}"
do
   if [ $i == "ok" ]
   then
       echo "File is prepare OK"
   else
       echo -e
	   echo -e
	   echo -e
	   echo -e
	   echo -e
	   echo -e
       echo "--------File not found : $i------------"
	   echo -e
	   echo -e
	   echo -e
	   echo -e
       echo -e
       exit 1	   
   fi
done

}

function execute {
   collectschema
   PgCollectModule
   csModuleFileCheck
   geeModuleFileCheck
   nsModuleFileCheck
   infactoryBackendModuleFileCheck
   inemsModuleFileCheck
   inparkModuleFileCheck
   ecbjModuleFileCheck
   statisticModuleFileCheck
   statisticCacheModuleFileCheck
   edgeModuleFileCheck   
   chartModuleFileCheck
   icaModuleFileCheck
   authcenterModuleFileCheck
   infactory-frontendModuleFileCheck
   simpleruleModuleFileCheck
   errorCheck
   csModule
   geeModule
   nsModule
   infactoryBackendModule
   inemsModule
   inparkModule
   edgeModule
   ecbjModule
   chartModule   
   statisticModule
   statisticCacheModule
   icaModule
   authcenterModule
   infactory-frontendModule
   simpleruleModule
}



function main {
sudo rm -rf sql*
sudo mkdir -p sql
sudo rm -rf systembuild*
cd /opt/systemfile/config
sudo rm -rf /opt/systemfile/config/autoconfig.sh
sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/auto-deploy/deploy-sh/autoconfig.sh
sudo chmod +x autoconfig.sh
cd /root/.jenkins/workspace/Auto-SystemDeploy
execute
cd /opt/systembuild/
sudo mkdir -p /opt/systembuild/Tomcat/API 
sudo mkdir -p /opt/systembuild/server
cd /opt/systembuild/Tomcat/API
sudo cp -R /opt/systemfile/systembuild/Tomcat/tomcatAUTH .
sudo cp -R /opt/systemfile/systembuild/Tomcat/tomcatISAS .
cd /opt/systembuild/server
sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/auto-deploy/file/ext4usb/authorized_keys
cd /opt/systembuild/
sudo cp -R /opt/systemfile/systembuild/prometheus .
sudo cp /opt/systemfile/systembuild/dbadmin-3.0.zip .
cd prometheus/
sudo sed -i "s/XXX/$env/g"  cron.sh
cd /opt/systembuild/
sudo zip -r server server/*
sudo zip -r prometheus prometheus/*
sudo zip -r Tomcat Tomcat/*
sudo rm -rf Tomcat
sudo rm -rf server
sudo rm -rf prometheus
cd ../
sudo zip -r systembuild systembuild/*
cd /root/.jenkins/workspace/Auto-SystemDeploy/
sudo rm -rf auto-deploy iotpackage ext4usb
sudo mkdir -p /root/.jenkins/workspace/Auto-SystemDeploy/iotpackage
sudo zip -r sql sql/*
sudo wget -nH -m --ftp-user=upload --ftp-password=Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/auto-deploy/file/ext4usb
sudo mv ftp/auto-deploy/file/ext4usb/* iotpackage
sudo mv /opt/systembuild.zip iotpackage
sudo mv sql.zip iotpackage
sudo zip -r iotpackage iotpackage/*
sudo /bin/curl -T iotpackage.zip -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/productfile/$version/  --ftp-create-dirs
sudo rm -rf *.zip
sudo rm -rf InsynergerRun*
sudo /bin/curl -O -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/ftp/productfile/file/InsynergerRun.sh
sudo sed -i "s/relpaceme/$version/g"  InsynergerRun.sh
sudo /bin/curl -T InsynergerRun.sh -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/productfile/$version/  --ftp-create-dirs
shc -f InsynergerRun.sh
sudo mv InsynergerRun.sh.x InsynergerRun
sudo /bin/curl -T InsynergerRun -u upload:Hk4g4hk4g4123 ftp://download.insynerger.com:2100/productfile/$version/  --ftp-create-dirs
}



while echo $1 | grep -q ^-; do
    eval $( echo $1 | sed 's/^-//' )=$2
    shift
    shift
done

echo user = $user
echo project=$project
echo env=$env
echo db=$db
echo cs=$cs
echo gee=$gee
echo ns=$ns
echo inpark=$inpark
echo inems=$inems
echo chart=$chart
echo edge=$edge
echo infactorybackend=$infactorybackend
echo ecbj=$ecbj
echo ica=$ica
echo statistic=$statistic
echo statisticcache=$statisticcache
echo infactory-frontend=$infactoryfrontend
echo authcenter=$authcenter
echo simplerule=$simplerule
echo env = $env
echo dbip = $dbip

main



