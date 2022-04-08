#!/bin/bash
dir=/etc/yum.repos.d
base=CentOS-Base.repo
green="\033[32m"
red="\033[31m"
none="\033[0m"

cd $dir
if [ ! -f $base ] ;then
	basedir=$(find /etc -name "$base"|xargs -n1 dirname)
	[ -z "$basedir" ] && echo -e "${red}Error: $base: File not exist${none}" && exit
	echo "There is not file $base in $dir/..."
	read -p "Found it in $basedir/, move to $dir/? (y/n): " move_file
	[[ ! $move_file =~ ^([y|Y]|[yY][eE][sS])$ ]] && echo -e "${red}Canceled${none}" && exit
	cp $basedir/$base{,.bak}
	mv $basedir/$base $dir
fi

sed -i 's/^mirror/#&/' $base
sed -ri 's/^#(baseurl)/\1/' $base
sed -i 's#http://mirror.centos.org#https://mirrors.aliyun.com#' $base
echo -e "${green}Install CentOS repository successfull${none}"

read -p "Install EPEL repository? (y/n): " epel
[[ ! $epel =~ ^([y|Y]|[yY][eE][sS])$ ]] && echo -e "${red}Canceled${none}" && exit
cat > epel.repo <<- eof
[epel]
name=Extra Packages for Enterprise Linux 7 - \$basearch
#baseurl=https://mirrors.tuna.tsinghua.edu.cn/epel/7/x86_64/
baseurl=https://mirrors.aliyun.com/epel/7/\$basearch/
failovermethod=priority
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
eof
yum install -y wget &> /dev/null
wget https://mirrors.aliyun.com/epel/RPM-GPG-KEY-EPEL-7 -P /etc/pki/rpm-gpg/ -P /etc/pki/rpm-gpg/ &> /dev/null
echo -e "${green}Install EPEL repository successfull${none}"

[ -f "/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7" ] && exit

echo -e "${green}Configure EPEL repository successfull${none}"
echo -e "${red}But gpgkey download failed, execute 'wget https://mirrors.aliyun.com/epel/RPM-GPG-KEY-EPEL-7 -P /etc/pki/rpm-gpg/' when you can connect to internet${none}"
