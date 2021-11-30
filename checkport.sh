#!/bin/bash

while echo $1 | grep -q ^-; do
    eval $( echo $1 | sed 's/^-//' )=$2
    shift
    shift
done


portcheck=$(netstat -nlp | grep ${moduleport} | awk '{print $5}')

if [ -z ${portcheck} ];
then
    echo "--------${moduleport} is Release-----------------------------------------------"
else
    echo "--------ERROR---------------------------------------------------------"
    echo "--------${moduleport} is not Release!!!!!--------------------------------------"
    exit 1
fi


