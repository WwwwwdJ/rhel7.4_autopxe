#!/bin/bash

# 关闭防火墙
systemctl disable firewalld 
systemctl stop firewalld

if [ `echo $?` -eq 0 ]
then
    echo -e "\e[32m"The firewall is turned off!" \e[0m"
else
    echo -e "\e[31m"firewall stop Error!" \e[0m"
fi

setenforce 0 
echo -e "\e[32m"selinux status is `getenforce`!" \e[0m"

sed -i 's/enforcing/disabled/' /etc/selinux/config
