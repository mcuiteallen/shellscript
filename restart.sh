#!/bin/bash
while echo $1 | grep -q ^-; do
    eval $( echo $1 | sed 's/^-//' )=$2
    shift
    shift
done
echo ${servicename}
echo $module
function restart {
systemctl start ${servicename}
}
restart





