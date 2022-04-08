#!/bin/bash
systemctl stop firewalld
systemctl disable firewalld
setenforce 0
sed -r -i.bak 's/(SELINUX=)(.*)/\1disabled/' /etc/selinux/config
