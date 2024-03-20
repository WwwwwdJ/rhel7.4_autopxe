#!/bin/bash

local_ip=`ip addr show | grep $1 | grep inet | awk -F' ' '{print $2}' | awk -F'/' '{print $1}'`

cp ks.cfg /var/ftp/ks.cfg

sed -i "8c rootpw --plaintext $2"  /var/ftp/ks.cfg
sed -i "36c url --url=\"ftp://$local_ip/rhel_7.4\"" /var/ftp/ks.cfg

if [ `echo $?` -eq 0 ]
then
    echo -e "\e[32m"ks.cfg has been changed!" \e[0m"
fi
