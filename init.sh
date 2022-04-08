#!/bin/bash
# chkconfig: 2345 99 99
[[ $# -eq 0 || "$1" == "-h" || "$1" == "--help" ]] && 
echo "Usage:$(basename $0) <hostname-without-domain> <ip-without-network>" && exit
! [[ $2 -ge 1 && $2 -le 254 ]] &> /dev/null && echo " Ipaddress out of range " && exit
iface=ens33
domain=zx.com
net_dir=/etc/sysconfig/network-scripts
cd $net_dir
sed -r -i "/IP/s/[0-9]+$/$2/" $net_dir/ifcfg-$iface
ifdown $iface;ifup $iface
echo $1.$domain > /etc/hostname

