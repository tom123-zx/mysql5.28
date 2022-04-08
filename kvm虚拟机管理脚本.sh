#!/bin/bash
#kvm manager
#abel
work_dir=`pwd`
images_dir=/var/lib/libvirt/images
xml_dir=/etc/libvirt/qemu
red_col="\e[1;31m"
blue_col="\e[1;34m"
reset_col="\e[0m"
centos6_base_img=$work_dir/centos6/rhel6.qcow2
centos7_base_img=$work_dir/centos7/centos7.qcow2
menu() {
cat <<-EOF
+------------------------------------------------+
| |
| ======================|
|  虚拟机基本管理centos|
| ======================|
| 1. 安装虚拟机 | 
| 2. 删除所有虚拟机 | 
| 3. 创建虚拟机centos6|
| 4. 创建虚拟机centos7|
| q. 退出管理程序 | 
| |
+------------------------------------------------+ 
EOF
}
;;
3)
read -p "请输入创建虚拟机的名字: " centos6
read -p "请输入创建虚拟机的数量: " vm_num
for i in `seq $vm_num`
do
vm_name=$centos6-${i}
vm_uuid=$(uuidgen)
vm_mac="52:54:$(dd if=/dev/urandom count=1 2>/dev/null | md5sum \
| sed -r 's/^(..)(..)(..)(..).*$/\1:\2:\3:\4/')"
vm_img=$images_dir/${vm_name}.qcow2


        qemu-img create -f qcow2 -b ${centos6_base_img} $vm_img &>/dev/null
cp -rf $work_dir/centos6/rhel6.xml /$xml_dir/${vm_name}.xml

sed -ri "s/vm_name/$vm_name/" /$xml_dir/${vm_name}.xml 
sed -ri "s/vm_uuid/$vm_uuid/" /$xml_dir/${vm_name}.xml
sed -ri "s/vm_mac/$vm_mac/" /$xml_dir/${vm_name}.xml
  sed -ri "s#vm_img#$vm_img#" /$xml_dir/${vm_name}.xml


        virsh define /$xml_dir/${vm_name}.xml &>/dev/null
echo "虚拟机${vm_name}重置完成..."
done
;;


4)
read -p "请输入创建虚拟机的名字: " centos7
read -p "请输入创建虚拟机的数量: " vm_num
for i in `seq $vm_num`
do
vm_name=$centos7-${i}
vm_uuid=$(uuidgen)
vm_mac="52:54:$(dd if=/dev/urandom count=1 2>/dev/null | md5sum \
| sed -r 's/^(..)(..)(..)(..).*$/\1:\2:\3:\4/')"
vm_img=$images_dir/${vm_name}.qcow2


        qemu-img create -f qcow2 -b ${centos7_base_img} $vm_img &>/dev/null
cp -rf $work_dir/centos7/centos7.xml /$xml_dir/${vm_name}.xml

sed -ri "s/vm_name/$vm_name/" /$xml_dir/${vm_name}.xml 
sed -ri "s/vm_uuid/$vm_uuid/" /$xml_dir/${vm_name}.xml
sed -ri "s/vm_mac/$vm_mac/" /$xml_dir/${vm_name}.xml
  sed -ri "s#vm_img#$vm_img#" /$xml_dir/${vm_name}.xml


        virsh define /$xml_dir/${vm_name}.xml &>/dev/null
echo "虚拟机${vm_name}重置完成..."
done
;;
m)
clear
menu
;;
q)
exit
;;
'')
;;
*)
echo "输入错误！"
read -p "请选择相应的操作[1-4]: " choice

esac
done
