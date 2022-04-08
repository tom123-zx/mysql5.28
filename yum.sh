#!/bin/bash
cd /etc/yum.repos.d/
ls | egrep -vi "base|app" |xargs rm -rf
sed -i 's/^mirrorlist/#&/' *
sed -i 's/^#baseurl/baseurl/' *
sed -i 's#http://mirror.centos.org#https://mirrors.aliyun.com#' *
yum clean all
yum install -y wget
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
yum clean all && yum repolist

