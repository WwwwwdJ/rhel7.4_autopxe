#!/bin/bash

# 网卡名
echo -n "Enter Network Name:"
read network_name

ip_range=`ip addr show | grep $network_name | grep inet | awk -F' ' '{print $2}' | awk -F'/' '{print $1}' | awk -F'.' '{print $1"."$2"."$3"."}'`

# 地址池范围开始IP
echo -n "Enter Begin of Network range:$ip_range"
read network_range_begin

# 地址池范围结束IP
echo -n "Enter End of Network range:$ip_range"
read network_range_end

# 设置客户机root密码
echo -n "Set passwd:"
read passwd

echo -n "check enter and continue(y/n):"
read enter

# 判断是否继续
if [ $enter = "y" ] || [ $enter = "Y" ]
then
    echo
    echo "-------------Start!-------------"

    sh selinux.sh
    sh tftp.sh
    sh init.sh $network_name
    sh dhcp.sh $network_name $network_range_begin $network_range_end
    sh ks.sh $network_name $passwd

    echo "--------------End!--------------"
fi


    
