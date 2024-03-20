#!/bin/bash

# 获取网络段
network_segment=`route -n | grep $1 | grep "U\b" | awk -F' ' '{print $1}'`
# 获取子网掩码
netmask=`route -n | grep $1 | grep "U\b" | awk -F' ' '{print $3}'`
# 获取本地IP
local_ip=`ip addr show | grep $1 | grep inet | awk -F' ' '{print $2}' | awk -F'/' '{print $1}'`
# 获取IP范围
ip_range=`ip addr show | grep $1 | grep inet | awk -F' ' '{print $2}' | awk -F'/' '{print $1}' | awk -F'.' '{print $1"."$2"."$3"."}'`

rm -f /etc/dhcp/dhcpd.conf

cp /usr/share/doc/dhcp-4.2.5/dhcpd.conf.example /etc/dhcp/dhcpd.conf

cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/

# sed -i  "32,35c subnet `route -n | grep $1 | grep "U\b" | awk -F' ' '{print $1}'` netmask `route -n | grep $1 | grep "U\b" | awk -F' ' '{print $3}'` {\n  range 192.168.107.10 192.168.107.20;\n  option routers `ip addr show | grep ens33 | grep inet | awk -F' ' '{print $2}' | awk -F'/' '{print $1}'`;\n}" /etc/dhcp/dhcpd.conf

sed -i "12c ddns-update-style none;\nnext-server $local_ip;\n" /etc/dhcp/dhcpd.conf
sed -i '14c filename "pxelinux.0";\n' /etc/dhcp/dhcpd.conf
sed -i "35,38c subnet $network_segment netmask $netmask {\n  range $ip_range$2 $ip_range$3;\n  option routers $local_ip;\n}" /etc/dhcp/dhcpd.conf

if [ `echo $?` -eq 0 ]
then
    echo -e "\e[32m"dhcp.sh has been changed!" \e[0m"
fi

# 重启dhcpd服务
systemctl restart dhcpd

if [ `echo $?` -eq 0 ]
then
    echo -e "\e[32m"dhcp service start!" \e[0m"
else
    echo -e "\e[31m"dhcp start Error!" \e[0m"
fi
