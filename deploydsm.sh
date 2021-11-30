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
containerid=$(docker ps | grep dsmanalysis_web_1  | awk '{print $1}')
imageid=$(docker images  | grep dsmanalysis_web_1  | awk '{print $3}')
if [ -z "$containerid" ]; then
    echo "NOTTHING TO KILLED"
    sudo rm -rf /opt/DSM/dsm_analysis*
    sudo yes | cp -f /home/"$user"/${module}/dsm_analysis.zip /opt/DSM/   
    cd /opt/DSM
	sudo unzip dsm_analysis.zip
	cd /opt/DSM/dsm_analysis
    sudo su -c "docker-compose up -d"
	sudo su -c "docker-compose exec web python3 manage.py migrate"
else
    echo "${containerid}"
    echo "${imageid}" 
    sudo rm -rf /opt/DSM/dsm_analysis*
    sudo yes | cp -f /home/"$user"/${module}/dsm_analysis.zip /opt/DSM/
    sudo su -c "docker stop $containerid"
    sudo su -c "docker rm $containerid"
    sudo su -c "docker rmi -f $imageid"
    cd /opt/DSM
	sudo unzip dsm_analysis.zip
	cd /opt/DSM/dsm_analysis
    sudo su -c "docker-compose up -d"
	sudo su -c "docker-compose exec web python3 manage.py migrate"
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





