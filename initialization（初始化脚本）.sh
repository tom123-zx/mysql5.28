#!/bin/bash
#注意当前操作的机器为主时间服务器
echo "注意当前操作的机器为主时间服务器！！！"
##################安装expect软件##########################
if ! [ -x /usr/bin/expect ];then
        yum install -y expect 
        ! [ -x /usr/bin/expect ] && echo "安装 expect 失败" && exit 1
fi
if ! [ -x /usr/bin/ansible ];then
        yum install -y ansible 
        ! [ -x /usr/bin/ansible ] && echo "安装 ansible 失败" && exit 1
fi
#################关闭防火墙、selinux#########################
internet()
{
setenforce 0
sed -i 's/enforcing/disabled/' /etc/selinux/config
systemctl stop firewalld
systemctl disable firewalld
route -n add default gw 192.168.10.2
echo "nameserver 114.114.114.114" > /etc/resolv.conf
}
internet
name=$HOSTNAME
head=$(hostname | awk -F. '{print $1}')
ip=$(ifconfig ens33|awk -F '[ :]+' 'NR==2 {print $3}')
############################传递主机公钥################################
read -p "请输入除当前IP外的IP及主机名及别名及密码(使用空格分隔，主机之间逗号分隔)："  -a hosts 
echo "${hosts[*]}" | tr "," "\n" > /opt/inventy.txt
sed -i '$d' /etc/hosts
echo "${hosts[*]}" | tr "," "\n" |sed -r "s/..$//g">> /etc/hosts
echo "$ip         $name       $head" >> /etc/hosts
expect <<-eof
        spawn ssh-keygen
        expect ".ssh/id_rsa):"
        send "\n"
        expect {
                "(empty for no passphrase):" {
                        send "\n"
                        expect "same passphrase again:" 
                        send "\n"
                }
                "Overwrite (y/n)?" { send "n\n" }
        }
        expect eof
eof
while read line;do
		host=$(awk '{print $1}' <<< $line)    # 如果资产文件格式不同,注意修改此处
		ping -c1 $host &> /dev/null || continue
		pass=$(awk '{print $4}' <<< $line)    # 如果资产文件格式不同,注意修改此处
        expect <<-eof
                spawn ssh-copy-id root@$host
                expect {
                        "continue connecting (yes/no)?" { send "yes\n"; exp_continue }
                        "password:" { send "$pass\n" }
                }
                expect eof
eof
	expect <<-eof
		spawn scp /etc/hosts root@$host:/etc/
		expect {
			{ send "\n" }
		}
		expect eof
eof
done < /opt/inventy.txt		
######################################配置时间同步########################################
sed -i '1i\[web]' /opt/inventy.txt 
awk '{print $1}' /opt/inventy.txt >> /etc/ansible/hosts
yum install -y chrony-3.4-1.el7.x86_64
ansible all -m package -a 'name=chrony-3.4-1.el7.x86_64 state=present' #安装时间同步服务器
######################################主机上配置时间同步###########################
sed -i 's/^#allow/allow/' /etc/chrony.conf
sed -i 's#allow 192.168.0.0/16#allow 192.168.10.0/24#' /etc/chrony.conf #如果资产文件格式不同,注意修改
systemctl start chronyd
systemctl enable chronyd
#####################################客户端上配置时间同步############################
ansible all -m shell -a "sed -i 's/^server/#&/' /etc/chrony.conf"
ansible all -m shell -a "sed -i 's#\#server 3.centos.pool.ntp.org iburst#server $ip iburst#' /etc/chrony.conf"
ansible all -m service -a 'name=chronyd state=started'
ansible all -m service -a 'name=chronyd enabled=yes'
systemctl restart chronyd
chronyc sources #查看服务器资源状态
