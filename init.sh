##!/bin/bash

# 获取本地IP地址
local_ip=`ip addr show | grep $1 | grep inet | awk -F' ' '{print $2}' | awk -F'/' '{print $1}'`

umount -f /mnt > /dev/null 2>&1

mount ./rhel-server-7.4-x86_64-dvd.iso /mnt > /dev/null

if [ `echo $?` -eq 0 ]
then
    echo -e "\e[32m"mount image Successd!" \e[0m"
else
    echo -e "\e[31m"mount image Error!" \e[0m"
fi

#rm -rf /var/ftp/rhel_7.4
mkdir /var/ftp/rhel_7.4
cp -rf /mnt/* /var/ftp/rhel_7.4/

cp /var/ftp/rhel_7.4/images/pxeboot/vmlinuz /var/lib/tftpboot/
cp /var/ftp/rhel_7.4/images/pxeboot/initrd.img /var/lib/tftpboot/

systemctl restart vsftpd

if [ `echo $?` -eq 0 ]
then
    echo -e "\e[32m"vsftpd service start!" \e[0m"
else
    echo -e "\e[31m"vsftpd start Error!" \e[0m"
fi

#rm -rf /var/lib/tftpboot/pxelinux.cfg
mkdir /var/lib/tftpboot/pxelinux.cfg
echo "# 指定默认入口名称
default auto
# "1"表示等待用户控制
prompt 0

# 图形安装引导入口
label auto
# kernel和append用来定义引导参数
kernel vmlinuz
append initrd=initrd.img method=ftp://$local_ip/rhel_7.4 ks=ftp://$local_ip/ks.cfg

# 文本安装引导入口
label linux text
kernel vmlinuz
append text initrd=initrd.img method=ftp://$local_ip/rhel_7.4

# 救援模式引导入口
label linux rescue
kernel vmlinuz 
append rescue initrd=initrd.img method=ftp://$local_ip/rhel_7.4
" > /var/lib/tftpboot/pxelinux.cfg/default
