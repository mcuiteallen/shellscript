#!/bin/bash
curl -i  https://dp-isas.insnergy.com/api  --connect-timeout 10
isasrespone=$(curl -s -w "%{http_code}" -o /dev/null https://dp-isas.insnergy.com/api  --connect-timeout 10)
authifrespone=$(curl -s -w "%{http_code}" -o /dev/null https://dp-auth.insnergy.com/if  --connect-timeout 10)
authecrespone=$(curl -s -w "%{http_code}" -o /dev/null https://dp-auth.insnergy.com/ec  --connect-timeout 10)
echo "isas respone = $isasrespone"
echo "auth if respone = $authifrespone"
echo "auth ec respone = $authecrespone"


if [ "$isasrespone" -ne "200" ] && [ "$isasrespone" -ne "302" ] ; then
  systemctl start stop-isas
  systemctl start start-isas
  mail -s "INAPI ISAS restart" az-rc-apache-alert@insnergy.com < /home/vmadmin/mail.txt
else
  echo "ISAS its work"
fi
if [ "$authifrespone" -ne "200" ] && [ "$authifrespone" -ne "302" ] ; then
  systemctl start stop-auth
  systemctl start start-auth
  mail -s "INAPI AUTH-IF restart" az-rc-apache-alert@insnergy.com < /home/vmadmin/mail.txt
else
  echo "AUTH-IF its work"
fi
if [ "$authecrespone" -ne "200" ] && [ "$authecrespone" -ne "302" ] ; then
  systemctl start stop-auth
  systemctl start start-auth
  mail -s "INAPI AUTH-EC restart" az-rc-apache-alert@insnergy.com < /home/vmadmin/mail.txt
else
  echo "AUTH-EC its work"
fi
