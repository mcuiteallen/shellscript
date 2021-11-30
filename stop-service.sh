#!/bin/bash
usage="
$(basename "$0") [-h] -- this script will help to setup services.

ex.
"$0" -s quartz -u vmadmin -t tomcatQUARTZ -f QuartzServer.war -w root
"$0" -s isas -u vmadmin -t tomcatISAS -f ISASServer.war -w api

where:
    -h  show help text
    -s  set service name
    -u  set user name
    -t  set tomcat name
    -f  set file name
    -w  set web app name
"
function killps {
sleep 6
psax=$(ps -ax | grep $module | grep -v "grep" | grep -v "stop-service" | awk '{print $1}')
echo $psax
if [ -z "$psax" ]; then
    echo "NOTTHING TO KILLED"
else
    anw=$(echo $psax | awk '{print $1}')
    echo $anw
    sudo su -c "kill -9 $anw"
fi
}
if [ ${service} == "no" ]
then
    echo "do not use service"
else
   systemctl start ${service}
fi



while getopts ':u:s:m:e:n:r:' option;
do
  default=no
  case "$option" in
   m) module=$OPTARG
   echo "module"
   ;;
   e) service=$OPTARG
   echo "service"
   ;;
   :) printf "missing argument for -%s\n" "$OPTARG" >&2
      echo "$usage" >&2
      exit 1
      ;;
  \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
shift $((OPTIND - 1))
killps






