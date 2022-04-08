#!/bin/bash
# chkconfig: 2345 99 99
internet()
{
setenforce 0
sed -r -i.bak 's/(SELINUX=)(.*)/\1disabled/' /etc/selinux/config
systemctl stop firewalld
systemctl disable firewalld
route -n add default gw 192.168.10.2
echo "nameserver 114.114.114.114" > /etc/resolv.conf
}
internet
if [ $?  -eq 0 ];then
echo "change successful!!!"
else
echo "change failed!!!"
fi
