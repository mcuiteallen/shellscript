#!/bin/bash

usage="
$(basename "$0") [-h] -- this script will help to setup services.

ex. 
"$0" -s quartz -u vmadmin -t tomcatQUARTZ -f QuartzServer.war -w root
"$0" -s isas -u vmadmin -t tomcatISAS -f ISASServer.war -w api

where:
    -u  set user name
"


function setsshkey {
mkdir -p /home/${username}/.ssh
chown ${username}:${username} /home/${username}/.ssh
chmod 755 /home/${username}/.ssh
sudo yes | cp -f /mnt/usb/authorized_keys /home/${username}/.ssh/
sudo chown ${username}:${username} /home/${username}/.ssh/authorized_keys
sudo chmod 644 /home/${username}/.ssh/authorized_keys
echo "Setup Complete"
}

while getopts ':u:' option; 
do
  case "$option" in 
   u) username=$OPTARG 
       setsshkey
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



