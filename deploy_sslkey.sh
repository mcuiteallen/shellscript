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
default=yes
function deploysslkey {
  sudo systemctl stop httpd
  sudo rm -rf /etc/httpd/conf/"$file"
  sudo yes | cp -f /home/"$user"/"$file" /etc/httpd/conf/
  sudo rm -rf /etc/httpd/conf/*.pem
  sudo rm -rf /etc/httpd/conf/*.crt
  sudo rm -rf /etc/httpd/conf/*_bk.conf
  sudo rm -rf /etc/httpd/conf/InSnergy_License
  sudo mv /etc/httpd/conf/*.conf /etc/httpd/conf/httpd_bk.conf
  cd /etc/httpd/conf/
  sudo unzip /etc/httpd/conf/"$file" 
  sudo sleep 3 
  sudo rm -rf /etc/httpd/conf/"$file"
  sudo systemctl start httpd
  echo "SUCCESS"
}


while getopts ':u:f:r:' option; 
do
  default=no
  case "$option" in 
   u) user=$OPTARG
    echo "user" 
    ;;
   f) file=$OPTARG
   echo "file" 
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
deploysslkey

