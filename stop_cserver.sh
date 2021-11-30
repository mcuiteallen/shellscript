#!/bin/sh
now=$(date +"d901be639e4a4f159f646466ce16b04e%Y%m%d%H%M%S")
echo "{'sc_cmd':'SET.IND','sc_sn':'$now','sc_property':'cs_shutdown'}\n" | nc 127.0.0.1 8900

counter=0
while netstat -aon | grep :8500
do
    (( counter++ ))
    if [ $counter -gt 15 ]; then
        break
    fi
    sleep 5
done

while ps ax | grep CServerEms.jar | grep -v "grep"
do
    echo "force to kill CServerEms.jar"
    ps ax | grep CServerEms.jar | grep -v "grep" | awk '{print $1}' | xargs kill -9
done

