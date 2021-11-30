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

function deployapi {
  sudo systemctl start stop-${service}
  sudo rm -rf /opt/Tomcat/tomcat"$module"/work/Catalina
  sudo rm -rf /opt/Tomcat/tomcat"$module"/webapps/"$file"*
  sudo mv /home/"$user"/"$module"/"$file".war /opt/Tomcat/tomcat"$module"/webapps
  cd /opt/Tomcat/tomcat"$module"/webapps
  sudo unzip /opt/Tomcat/tomcat"$module"/webapps/"$file".war -d "$file"
  sleep 2
  string1="yes | cp -f /home/${user}/${module}/${setting} /opt/Tomcat/tomcat${module}/webapps/${file}/WEB-INF/classes/"
  sudo su -c "$string1"
  sudo yes | cp -f /home/"$user"/${module}/"$setting" /opt/Tomcat/tomcat"$module"/webapps/"$file"/WEB-INF/classes
  sudo rm -rf /opt/Tomcat/tomcat"$module"/webapps/"$file"/WEB-INF/classes/deploy-setting.properties
  sudo mv /opt/Tomcat/tomcat"$module"/webapps/"$file"/WEB-INF/classes/"$setting" /opt/Tomcat/tomcat"$module"/webapps/"$file"/WEB-INF/classes/deploy-setting.properties
  sudo systemctl start start-${service}
  echo "SUCCESS"
}


while getopts ':u:f:s:m:e:r:' option; 
do
  default=no
  case "$option" in 
   u) user=$OPTARG
    echo "user" 
    ;;
   f) file=$OPTARG
   echo "file" 
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
deployapi


