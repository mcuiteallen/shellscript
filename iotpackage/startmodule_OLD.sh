#!/bin/bash
function allcheck {
moduleList=( "GEE" "CServer" "NS" "INLIGHT" "EDGE" "CHART" "EC" "ISAS" "IFAS" "AUTH" "ECBJ" "QUARTZ" "OBSIDIAN" "STATISTIC" "STATISTICCACHE")
for i in "${moduleList[@]}"
do
    findmodule  $i
done
}

function findmodule() {
if [ -d "/opt/Tomcat/tomcat$1" ]; then
    retval=$( findModuleService $1 )
    sudo systemctl start $retval
else
if [ -d "/opt/$1" ]; then
    retval=$( findModuleService $1 )
    sudo systemctl start $retval
fi
fi
}
function findModuleService() {
if [ $1 == "GEE" ];then
    echo "start_gee"
fi
if [ $1 == "CServer" ];then
    echo "start_cserver"
fi
if [ $1 == "NS" ];then
    echo "start_nserver"
fi
if [ $1 == "QUARTZ" ];then
    echo "start-quartz"
fi
if [ $1 == "EDGE" ];then
    echo "start_edge"
fi
if [ $1 == "INLIGHT" ];then
    echo "start_inlight"
fi
if [ $1 == "EC" ];then
    echo "start-ec"
fi
if [ $1 == "ECBJ" ];then
    echo "start-ecbj"
fi
if [ $1 == "ISAS" ];then
    echo "start-isas"
fi
if [ $1 == "IFAS" ];then
    echo "start-if3"
fi
if [ $1 == "AUTH" ];then
    echo "start-auth"
fi
if [ $1 == "CHART" ];then
    echo "start_chart"
fi

if [ $1 == "OBSIDIAN" ];then
    echo "start-obsidian"
fi

if [ $1 == "STATISTIC" ];then
    echo "start-statistic"
fi

if [ $1 == "STATISTICCACHE" ];then
    echo "start-statistic-cache"
fi
}
allcheck