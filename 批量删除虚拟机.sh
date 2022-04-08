#!/bin/bash
#AUTHOR:AN
#VERSION:1.1.0
#DATE:2019-06-04
#MODIFY:
#FUNCTION:批量删除虚拟机

#加载配置文件
source /cloud_nsd/conf/virsh.conf
#加载函数库
if [ -f "$Script_Path/myfunction.lib" ];then
 	source $Script_Path/myfunction.lib 
else
	echo -e "\033[31m函数库不存在\033[0m"
	exit $NOEXIST
fi

##############################################################
#删除磁盘文件和配置文件
DELETE_VM(){
	[ -f $Xml_Path/$1.xml ] && virsh undefine $1 &> /dev/null
	[ -f $Disk_Path/$1.img ] && rm -rf $Disk_Path/$1.img
	cecho 36 "Delete $1 is success!"
}

#############################主程序#############################
[ $# -eq 0 ] && cecho 31 "Invaid parameter! Usage:`basename $0` vm1 vm2......" && exit $ISERROR
for i in $@;do
	if [ ! -f $Disk_Path/$i.img -a ! -f $Xml_Path/$i.xml ];then
		cecho 31 "$i not exist!!!" && exit $ISERROR		
	else
		DELETE_VM $i
	fi
done
