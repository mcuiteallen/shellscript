#!/bin/bash

list=$(echo  /dev/[sh]d*)
arr=(${list// / });
length=${#arr[@]}
for(( j=0; j<$length; j++ ))
do
    sdx=${arr[$j]}
#   echo "sdx=$sdx"
    devicenamelist=$(udevadm info --query=all -n $sdx)
#    echo "devicenamelist=$devicenamelist"
    devicename=$(echo $devicenamelist | grep INSUSB1)
#    echo "devicename=$devicename"
    if [ -z  "$devicename"  ];
    then
    echo "........."
#    echo "Can not found USB's devicelable"
    else
#    echo "sdx=$sdx"
    sudo mkdir -p /mnt/usb
    sudo umount /mnt/usb
    usbmount=$(sudo mount -v -t auto $sdx  /mnt/usb | grep "mounted on" | awk '{print $3}')
    fi 
done

function mountcheck {
if [ -z "$usbmount" ];
then
echo "[fail]Can found USB's deviceLable but  mount fail"
else
if [ -f "/mnt/usb/systembuild.zip" ]; 
then
echo "usb mount compelete"
else
echo "[fail] It's nothing in USB"
echo "[fail] system package is not exist"
fi
fi
}
mountcheck

