#!/bin/bash

while echo $1 | grep -q ^-; do
    eval $( echo $1 | sed 's/^-//' )=$2
    shift
    shift
done
echo ip = $ip

function allcheck {
moduleList=( "GEE" "CServer" "NS" "inlight" "ILEdge" "inems" "chart" "EC" "ISAS" "IFAS" "AUTH" "ECBJ" "QUARTZ" "obsidian" "StatisticService" "StatisticCacheService" "DB")
for i in "${moduleList[@]}"
do
    findmodule  $i
done
}

function findmodule() {
if [ -d "/opt/Tomcat/tomcat$1" ]; then
    retval=$( moduleNameDeside $1 )
    echo "$retval"
elif [ -d "/opt/$1" ]; then
    retval=$( moduleNameDeside $1 )
    echo "$retval"
elif [ $1 == "inlight" ] && [ -d "/opt/INLIGHT" ]; then
    retval=$( moduleNameDeside $1 )
    echo "$retval" 
elif [ $1 == "ILEdge" ] && [ -d "/opt/EDGE" ]; then
    retval=$( moduleNameDeside $1 )
    echo "$retval"
elif [ $1 == "chart" ] && [ -d "/opt/CHART" ]; then
    retval=$( moduleNameDeside $1 )
    echo "$retval"
elif [ $1 == "inems" ] && [ -d "/opt/INEMS" ]; then
    retval=$( moduleNameDeside $1 )
    echo "$retval"
elif [ $1 == "obsidian" ] && [ -d "/opt/StatisticService/tomcat" ]; then
    retval=$( moduleNameDeside $1 )
    echo "$retval"
elif [ $1 == "DB" ]; then
    retval=$( moduleNameDeside $1 )
    echo "$retval"
fi
}

function moduleNameDeside() {
if [ $1 == "GEE" ];
then
    moduleName="gee-server"
    PsCheck $moduleName
elif [ $1 == "NS" ];
then
    moduleName="n-server"  
    PsCheck $moduleName
elif [ $1 == "obsidian" ];
then
    moduleName="StatisticService/tomcat"
    PsCheck $moduleName
elif [ $1 == "DB" ];
then
    portRetval=$(DBportCheck $ip)
    echo $portRetval
else 
    moduleName=$1
    PsCheck $moduleName
fi


}

function PsCheck() {
psax=$(ps -ax | grep $1 | grep -v "grep" | grep -v "stop-service" | awk '{print $2}')
if [ -z "$psax" ]; then
    echo "$1                   process is not exist ，Please check again"     
else
    port=$(findModulePort $1)
    portRetval=$( portCheck $port )
    echo "$1                   process is existed  & $portRetval"
fi
}

function portCheck() {
nport=`echo ""|telnet localhost $1 2>/dev/null|grep "\^]"|wc -l`
if [ $nport -eq 1 ];then
    echo " Port is active"
else 
    echo " Port is not active"
fi
}

function DBportCheck() {
mysqlnport=`echo ""|telnet $ip 3306 2>/dev/null|grep "\^]"|wc -l`
pgnport=`echo ""|telnet $ip 5432 2>/dev/null|grep "\^]"|wc -l`
echo "project=$project"
if [ $project == "AT" ]
then
    mysql $mysqlnport
else
    postgresql  $pgnport
fi
}

function mysql() {
if [ $1 -eq 1 ];then
    echo " MYSQLDBPort is active"
else
    echo " MYSQLDBPort is not active"
fi
}


function postgresql() {
if [ $1 -eq 1 ];then
    echo " POSTGRESDBPort is active"
else
    echo " POSTGRESDBPort is not active"
fi
}




function findModulePort() {
if [ $1 == "gee-server" ];then
    echo "8100"
fi
if [ $1 == "CServer" ];then
    echo "8500"
fi
if [ $1 == "n-server" ];then
    echo "9000"
fi
if [ $1 == "QUARTZ" ];then
    echo "8094"
fi
if [ $1 == "ILEdge" ];then
    echo "80"
fi
if [ $1 == "inems" ];then
    echo "80"
fi
if [ $1 == "inlight" ];then
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
if [ $1 == "chart" ];then
    echo "9180"
fi
if [ $1 == "StatisticService/tomcat" ];then
    echo "9900"
fi
if [ $1 == "StatisticService" ];then
    echo "9901"
fi
if [ $1 == "StatisticCacheService" ];then
    echo "9906"
fi
}
allcheck




