#!/bin/bash
#AUTHOR:AN
#VERSION:1.1.0
#DATE:2019-06-04
#MODIFY:
#FUNCTION:批量创建虚拟机

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
#创建磁盘文件和配置文件
CREATE_VM(){
	if [ -f $Backend_Disk -a -f $Backend_Xml ];then
		qemu-img create -b $Backend_Disk -f qcow2 $Disk_Path/$1.img $Disk_Size &>/dev/null
		cp $Backend_Xml $Xml_Path/$1.xml
		sed -i "/node_base/ s/node_base/$1/" $Xml_Path/$1.xml		#修改名字和磁盘路径
		echo -en "create vm $1......\t\t"
		virsh define $Xml_Path/$1.xml &>/dev/null 					#创建虚拟机
		echo -e "\e[32;1m[OK]\e[0m"
	else
		cecho 31 "Backend_Disk|Backend_Xml is error" && exit $ISERROR
	fi
}

#############################主程序#############################
[ $# -eq 0 ] && cecho 31 "Invaid parameter! Usage:`basename $0` vm1 vm2......" && exit $ISERROR
for i in $@;do
	if [ ! -f $Disk_Path/$i.img -a ! -f $Xml_Path/$i.xml ];then
		CREATE_VM $i
	else
		cecho 31 "$i is exist!!!" && exit $ISERROR
	fi
done
