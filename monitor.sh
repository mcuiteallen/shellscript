#!/bin/bash

while echo $1 | grep -q ^-; do
    eval $( echo $1 | sed 's/^-//' )=$2
    shift
    shift
done
echo category=$category
echo env=$env

function killopenvpn {
   psax=$(ps -ax | grep openvpn | grep -v "grep" | awk '{print $1}')
   if [ -z "$psax" ] ; then
      echo "NOTHING TO KILL"
   else
      anw=$(echo $psax | awk '{print $1}')
      echo $anw
      sudo su -c "kill -9 $anw"
   fi
}

function portCheck() {
   nport=`echo ""|telnet 10.6.255.253 7789 2>/dev/null|grep "\^]"|wc -l`
   if [ $nport -eq 1 ];then
      echo "VPN OK"
      curl -X GET http://10.6.255.253:7789/api/monitor/vpn/collect/$category/$env/$1/$2/
   else 
      echo "VPN FAIL"
   fi
}

function checkvpn {
   rm -rf /opt/prometheus/restartopenvpn
   mac=$(cat /sys/class/net/en*/address | awk 'NR==1{print}')
   ip=$(/sbin/ifconfig -a | grep -w "10.6" | awk '{print $2}')
   if [ -z "$mac" -o -z "$ip" ] ; then
      echo "ERROR"
      killopenvpn
      touch /opt/prometheus/restartopenvpn
      echo category=$category  >> restartopenvpn
      echo env=$env  >> restartopenvpn
      echo ip=$ip  >> restartopenvpn
      echo mac=$mac  >> restartopenvpn
      NOW=$(date +"%c")
      echo $NOW  >> restartopenvpn
      echo "start openvpn"  >> restartopenvpn
      /sbin/openvpn --config /etc/openvpn/client/insynerger-openvpn.ovpn &
      echo "end"  >> restartopenvpn
   else
      echo "PSAX EXIST"
      portCheck $mac $ip
   fi
}

checkvpn
