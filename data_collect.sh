#!/bin/bash

while echo $1 | grep -q ^-; do
    eval $( echo $1 | sed 's/^-//' )=$2
    shift
    shift
done



function getdata {
    x=$(curl -s pushgateway.insynerger.com/metrics | grep ${env} | grep ${module} | grep ${item})
	y=$(echo $x|cut -d '}' -f2)
	echo $y
    if [ $y -lt 1 ]
    then
          echo ${item}小於1
    else
          echo ${item}=$y
    fi	
}



getdata



