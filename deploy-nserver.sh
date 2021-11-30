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

function deployserver {
  sudo rm -rf /opt/"$module"/${service}.zip
  cd /opt/"$module"
  sudo mv /home/"$user"/"$module"/${service}.zip /opt/"$module"
  sudo rm -rf /opt/"$module"/NS_current_OLD
  sudo mv /opt/"$module"/NS_current /opt/"$module"/NS_current_OLD
  sudo unzip /opt/"$module"/${service}.zip
  sudo mv /opt/"$module"/"$module"-* /opt/"$module"/NS_current
  cd /opt/"$module"/NS_current
  sudo rm -rf "$setting"
  sudo rm -rf application-linux.yml
  if [ $env == "PROD" ]
  then
    sudo rm -rf nserver.sh
	sudo mv nserver-prod.sh nserver.sh 
  else
    sudo yes | cp -f  /home/"$user"/"$module"/"$setting" /opt/"$module"/NS_current
    sudo mv /opt/"$module"/NS_current/"$setting" /opt/"$module"/NS_current/application-linux.yml
  fi  
  sudo chmod +x nserver.sh
  sudo systemctl start start_${service}
  sudo rm -rf /home/"$user"/"$module"/${service}.zip
  echo "SUCCESS"
}


while getopts ':u:s:m:e:n:r:' option;
do
  default=no
  case "$option" in
   u) user=$OPTARG
    echo "user"
    ;;
   s) setting=$OPTARG
   echo "setting"
   ;;
   m) module=$OPTARG
   echo "module"
   ;;
   e) service=$OPTARG
   echo "service"
   ;;
   n) env=$OPTARG
   echo "env"
   ;;
   r) remove=$OPTARG
      if [ "$remove" == "yes" ]; then
         remove
      else
        echo "Don't remove"
      fi
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
deployserver



