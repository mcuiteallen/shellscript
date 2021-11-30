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
function deploydocker {
containerid=$(docker ps | grep mark1002/ia_ivs  | awk '{print $1}')
imageid=$(docker images  | grep mark1002/ia_ivs  | awk '{print $3}')
if [ -z "$containerid" ]; then
    echo "NOTTHING TO KILLED"
    sudo rm -rf /opt/IA_IVS/docker-compose.yml
    sudo rm -rf /opt/IA_IVS/config/config.ini
    sudo yes | cp -f /home/"$user"/${module}/docker-compose.yml /opt/IA_IVS/    
    sudo yes | cp -f /home/"$user"/${module}/config.ini /opt/IA_IVS/config  
    cd /opt/IA_IVS
    sudo su -c "docker-compose up -d"
else
    echo "${containerid}"
    echo "${imageid}" 
    sudo rm -rf /opt/IA_IVS/docker-compose.yml
    sudo rm -rf /opt/IA_IVS/config/config.ini
    sudo yes | cp -f /home/"$user"/${module}/docker-compose.yml /opt/IA_IVS/    
    sudo yes | cp -f /home/"$user"/${module}/config.ini /opt/IA_IVS/config  
    sudo su -c "docker stop $containerid"
    sudo su -c "docker rm $containerid"
    sudo su -c "docker rmi -f $imageid"
    cd /opt/IA_IVS
    sudo su -c "docker-compose up -d"
fi
}


while getopts 'm:u:' option;
do
  default=no
  case "$option" in
   m) module=$OPTARG
   echo "module"
   ;;
   u) user=$OPTARG
   echo $user
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
deploydocker





