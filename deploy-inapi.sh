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

function deployroot {
  sudo mkdir /opt/Tomcat/tomcatINAPI/war
  sudo rm -rf /opt/Tomcat/tomcatINAPI/work/Catalina
  sudo rm -rf /opt/Tomcat/tomcatINAPI/webapps/ROOT  
  sudo mv /home/"$user"/"$module"/"$file".zip /opt/Tomcat/tomcatINAPI/webapps
  cd /opt/Tomcat/tomcatINAPI/webapps
  sudo unzip /opt/Tomcat/tomcatINAPI/webapps/"$file".zip -d ROOT
  sleep 2
  sudo rm -rf /opt/Tomcat/tomcatINAPI/webapps/"$file".zip
  sudo systemctl start start-${service}
  echo "SUCCESS"
}


while getopts ':u:f:m:e:r:' option; 
do
  default=no
  case "$option" in 
   u) user=$OPTARG
    echo "user" 
    ;;
   f) file=$OPTARG
   echo "file" 
   ;; 
   m) module=$OPTARG
   echo "module" 
   ;; 
   e) service=$OPTARG
   echo "service" 
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
deployroot



