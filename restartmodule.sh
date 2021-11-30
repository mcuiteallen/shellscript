#!/bin/bash

function allcheck {
moduleList=( "GEE" "CServer" "NS" "INLIGHT" "EDGE" "CHART" "EC" "ISAS" "IFAS" "AUTH" "ECBJ" "QUARTZ" )
for i in "${moduleList[@]}"
do
    findmodule  $i
done
}

function findmodule() {
if [ -d "/opt/Tomcat/tomcat$1" ]; then
    retval=$( PsCheck $1 )
else
if [ -d "/opt/$1" ]; then
    retval=$( PsCheck $1 )
fi
fi
}

function PsCheck() {
if [ $1 == "GEE" ];then
    moduleName="gee-server"
else
    moduleName=$1    
fi
psax=$(ps -ax | grep $moduleName | grep -v "grep" | grep -v "stop-service" | awk '{print $2}')
if [ -z "$psax" ]; then
    serviceRetval=$(findModuleService $1)
    sudo systemctl start stop$serviceRetval
    echo "stop $1 compelete"
    sudo systemctl start start$serviceRetval
    echo "start $1 compelete"   
echo "test1"
else
    port=$(findModulePort $1)
    portRetval=$( portCheck $port )
    echo "$1                   process is existed  & $portRetval"
fi
echo "compelete restart $1"
}

function portCheck() {
nport=`echo ""|telnet localhost $1 2>/dev/null|grep "\^]"|wc -l`
if [ $nport -eq 1 ];then
    echo " Port is active"
else
    echo " Port is not active"
fi
}

function findModulePort() {
if [ $1 == "GEE" ];then
    echo "8100"
fi
if [ $1 == "CServer" ];then
    echo "8500"
fi
if [ $1 == "NS" ];then
    echo "9000"
fi
if [ $1 == "QUARTZ" ];then
    echo "8094"
fi
if [ $1 == "EDGE" ];then
    echo "80"
fi
if [ $1 == "INLIGHT" ];then
    echo "8085"
fi
if [ $1 == "EC" ];then
    echo "8088"
fi
if [ $1 == "ECBJ" ];then
    echo "8089"
fi
if [ $1 == "ISAS" ];then
    echo "8446"
fi
if [ $1 == "IFAS" ];then
    echo "8444"
fi
if [ $1 == "AUTH" ];then
    echo "8447"
fi
if [ $1 == "CHART" ];then
    echo "9180"
fi
}

function findModuleService() {
if [ $1 == "GEE" ];then
    echo "_gee"
fi
if [ $1 == "CServer" ];then
    echo "_cserver"
fi
if [ $1 == "NS" ];then
    echo "_nserver"
fi
if [ $1 == "QUARTZ" ];then
    echo "-quartz"
fi
if [ $1 == "EDGE" ];then
    echo "_edge"
fi
if [ $1 == "INLIGHT" ];then
    echo "_inlight"
fi
if [ $1 == "EC" ];then
    echo "-ec"
fi
if [ $1 == "ECBJ" ];then
    echo "-ecbj"
fi
if [ $1 == "ISAS" ];then
    echo "-isas"
fi
if [ $1 == "IFAS" ];then
    echo "-if3"
fi
if [ $1 == "AUTH" ];then
    echo "-auth"
fi
if [ $1 == "CHART" ];then
    echo "_chart"
fi
}
allcheck




