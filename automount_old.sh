#!/bin/bash

dev=$(ls  /dev/[sh]d* | awk '{print $1}' )
sdx=$(echo $dev | awk -F' ' '{print $NF}')
size=$(fdisk -s $sdx)
echo "size=$size"
echo $sdx
usbrange=$(echo  $size | awk '{
if($0 < 65000000 && $0 > 55000000) 
print "legal"; 
else if($0 < 8500000 && $0 > 6500000) 
print "legal"
else if($0 < 16500000 && $0 > 15000000)
print "legal"
else
print "illegal"
}')
if [ $usbrange=="legal" ];
then
sudo mkdir -p /mnt/usb
sudo umount /mnt/usb
usbmount=$(sudo mount -v -t auto $sdx  /mnt/usb | grep "mounted on" | awk '{print $3}')
else
echo "[fail] USB's range is illegal"
fi

function mountcheck {
if [ -z "$usbmount" ];
then
echo "[fail] USB mount fail"
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

