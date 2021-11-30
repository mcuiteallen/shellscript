#!/bin/bash

while echo $1 | grep -q ^-; do
    eval $( echo $1 | sed 's/^-//' )=$2
    shift
    shift
done

function infactory {
   moduleList=( "gee" "CServer" "n-server" "EdgeServer.jar" "inems.war"  "/opt/StatisticService/tomcat" "StatisticService" "StatisticCacheService" "InsynergerCommonAPI" "infactory-backend" "AuthCenter" "tomcatINFACTORY-FRONTEND") 
   for i in "${moduleList[@]}"
   do
       PsCheck  $i
   done
}

function inpark {
   moduleList=( "gee" "CServer" "n-server" "EdgeServer.jar" "inpark.war" "ChartService.jar" "/opt/StatisticService/tomcat" "StatisticService" "StatisticCacheService" "InsynergerCommonAPI" ) 
   for i in "${moduleList[@]}"
   do
       PsCheck  $i
   done
}

function at {
   moduleList=( "gee" "CServer" "tomcatEC" )
   for i in "${moduleList[@]}"
   do
       PsCheck  $i
   done
}


function PsCheck() {
   psax=$(ps -ax | grep $1 | grep -v "grep" | grep -v "stop-service" | awk '{print $2}')
   if [ -z "$psax" ]; then
       echo "$1                                         Dead"     
   else
       port=$(findModulePort $1)
       portRetval=$( portCheck $port )
       echo "$1                                         $portRetval"
   fi
}

function portCheck() {
   nport=`echo ""|telnet localhost $1 2>/dev/null|grep "\^]"|wc -l`
   if [ $nport -eq 1 ];then
       echo "Alive"
   else 
       echo "Dead"
   fi
}

function postgresql() {
   postgresqlnport=`echo ""|telnet localhost 5432 2>/dev/null|grep "\^]"|wc -l`
   if [ $postgresqlnport -eq 1 ];then
       echo " POSTGRESDB                                 Alive"
   else 
       echo " POSTGRESDB                                 Dead"
   fi
}

function mysql {
   mysqlnport=`echo ""|telnet localhost 3306 2>/dev/null|grep "\^]"|wc -l`
   if [ $mysqlnport -eq 1 ];then
       echo " MYSQLDB                                    Alive"
   else
       echo " MYSQLDB                                    Dead"
   fi
}

function findModulePort() {
   case $1 in
      "gee") echo "8100" 
      ;;
      "CServer") echo "8500"
      ;;
      "n-server") echo "9000"
      ;;
      "inpark.war") echo "8085"
      ;;
      "inems.war") echo "8888"
      ;;   
      "tomcatECBJ") echo "8089"
      ;;      
      "/opt/StatisticService/tomcat") echo "9900"
      ;;     
      "StatisticService") echo "9901"
      ;;     
      "StatisticCacheService") echo "9906"
      ;;     
      "InsynergerCommonAPI") echo "6060"
      ;;     
      "AuthCenter") echo "9999"
      ;;     
      "tomcatINFACTORY-FRONTEND") echo "8091"
      ;;     
      "infactory-backend") echo "5050"
      ;;     	  
      "EdgeServer.jar") echo "443"
      ;;     	  
      "ChartService.jar") echo "9180"
      ;;     	  	  
      "tomcatEC") echo "80"
      ;;
	  "SimpleRuleService") echo "4040"
      ;;
      *) echo "error input" 
      ;;
   esac
}

case $type in
   "at") at 
   ;;
   "infactory") infactory
   ;;
   "inpark") inpark
   ;;
   "mysql") mysql
   ;;   
   "postgresql") postgresql
   ;;      
   *) echo "error input" 
   ;;
esac



