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
  sudo systemctl start stop-${service}
  sudo mkdir /opt/Tomcat/tomcat"$module"/war
  sudo rm -rf /opt/Tomcat/tomcat"$module"/work/Catalina
  sudo rm -rf /opt/Tomcat/tomcat"$module"/webapps/ROOT  
  sudo mv /home/"$user"/"$module"/"$file".war /opt/Tomcat/tomcat"$module"/webapps
  cd /opt/Tomcat/tomcat"$module"/webapps
  sudo unzip /opt/Tomcat/tomcat"$module"/webapps/"$file".war -d ROOT
  sleep 2
  string1="yes | cp -f /home/${user}/${module}/${setting} /opt/Tomcat/tomcat${module}/webapps/ROOT/WEB-INF/classes/"
  sudo su -c "$string1"
  sudo yes | cp -f /home/"$user"/${module}/"$setting" /opt/Tomcat/tomcat"$module"/webapps/ROOT/WEB-INF/classes
  sudo rm -rf /opt/Tomcat/tomcat"$module"/webapps/ROOT/WEB-INF/classes/setting.properties
  sudo mv /opt/Tomcat/tomcat"$module"/webapps/ROOT/WEB-INF/classes/"$setting" /opt/Tomcat/tomcat"$module"/webapps/ROOT/WEB-INF/classes/setting.properties
  string2="yes | cp -f /home/${user}/${module}/${log4j2} /opt/Tomcat/tomcat${module}/webapps/ROOT/WEB-INF/classes/"
  sudo su -c "$string2"
  sudo yes | cp -f /home/"$user"/${module}/"$log4j2" /opt/Tomcat/tomcat"$module"/webapps/ROOT/WEB-INF/classes
  sudo rm -rf /opt/Tomcat/tomcat"$module"/webapps/ROOT/WEB-INF/classes/log4j2.properties
  sudo mv /opt/Tomcat/tomcat"$module"/webapps/ROOT/WEB-INF/classes/"$log4j2" /opt/Tomcat/tomcat"$module"/webapps/ROOT/WEB-INF/classes/log4j2.properties
  string3="yes | cp -f /home/${user}/${module}/${schedule} /opt/Tomcat/tomcat${module}/webapps/ROOT/WEB-INF/classes"
  sudo su -c "$string3"
  sudo yes | cp -f /home/"$user"/${module}/"$schedule" /opt/Tomcat/tomcat"$module"/webapps/ROOT/WEB-INF/classes
  sudo rm -rf /opt/Tomcat/tomcat"$module"/webapps/ROOT/WEB-INF/classes/schedule-config.xml
  sudo mv /opt/Tomcat/tomcat"$module"/webapps/ROOT/WEB-INF/classes/"$schedule" /opt/Tomcat/tomcat"$module"/webapps/ROOT/WEB-INF/classes/schedule-config.xml
  sudo rm -rf /opt/Tomcat/tomcat"$module"/webapps/"$file".war
  sudo systemctl start start-${service}
  echo "SUCCESS"
}


while getopts ':u:f:s:m:e:r:l:c:' option; 
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
   l) log4j2=$OPTARG
   echo "log4j" 
   ;; 
   c) schedule=$OPTARG
   echo "schedule" 
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


