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
  sudo rm -rf /opt/"$module"/"$module"_OLD
  sudo mv /opt/"$module"/"$module"* /opt/"$module"/"$module"_OLD
  sudo unzip /opt/"$module"/${service}.zip
  sudo  mv /opt/"$module"/"$module"-* /opt/"$module"/"$module"
  cd /opt/"$module"/"$module"/GeeServer
  sudo rm -rf /opt/"$module"/"$module"/GeeServer/config/application.yml
  sudo rm -rf /opt/"$module"/"$module"/GeeServer/RunGEE.sh
  if [ $env == "PROD" ]
  then
	sudo mv RunGEE-PROD.sh RunGEE.sh
  elif [ $env == "III88_7" ]
  then
    sudo mv RunGEE-PROD.sh RunGEE.sh
  else
    sudo rm -rf /opt/"$module"/"$module"/GeeServer/config/"$setting"
    sudo rm -rf /opt/"$module"/"$module"/GeeServer/config/application-EC.yml
    sudo yes | cp -f  /home/"$user"/"$module"/"$setting" /opt/"$module"/"$module"/GeeServer/config
    sudo  mv /opt/"$module"/"$module"/GeeServer/config/"$setting" /opt/"$module"/"$module"/GeeServer/config/application-EC.yml
    sudo  mv /opt/"$module"/"$module"/GeeServer/RunGEE-EC.sh /opt/"$module"/"$module"/GeeServer/RunGEE.sh   
  fi    
  sudo chmod +x RunGEE.sh
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



