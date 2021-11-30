#!/bin/bash
curl -i  https://t-inlight.insnergy.com/sc03.do  --connect-timeout 10
respone=$(curl -s -w "%{http_code}" -o /dev/null  https://t-inlight.insnergy.com/sc03.do --connect-timeout 10) 
if [ "$respone" == 000 ]; then  
  systemctl restart httpd
  mail -s "Apache restart" az-rc-apache-alert@insnergy.com < /home/vmadmin/mail.txt
  mail -s "Apache restart" mcuiteallen@insnergy.com < /home/vmadmin/mail.txt
  echo $respone
else
  echo $respone	 
  echo "httpd its work"
fi       

