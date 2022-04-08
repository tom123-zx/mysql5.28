#!/bin/bash
# chkconfig: 2345 99 99
host() {
ip=$(ifconfig ens33|awk -F '[ :]+' 'NR==2 {print $3}')
name=$HOSTNAME
head=$(hostname | awk -F. '{print $1}')
sed -r '$d' /etc/hosts
echo $ip         $name       $head >> /etc/hosts
}
host &> /dev/null
if [ $?  -eq 0 ];then
echo "change successful!!!"
else
echo "change failed!!!"
fi
