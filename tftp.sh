#!/bin/bash

echo "
service tftp
{
        socket_type             = dgram
        #TFTP默认使用UDP协议
        protocol                = udp
        #no表示客户机可以多台一起连接，yes表示客户机只能一台一台连接
        wait                    = no
        user                    = root
        server                  = /usr/sbin/in.tftpd
        #指定TFTP根目录（引导文件的存储路径）
        server_args             = -s /var/lib/tftpboot
        #no表示开启TFTP服务
        disable                 = no
        per_source              = 11
        cps                     = 100 2
        flags                   = IPv4
}
" > /etc/xinetd.d/tftp

systemctl restart xinetd
if [ `echo $?` -eq 0 ]
then
    echo -e "\e[32m"xinetd service start!" \e[0m"
else
    echo -e "\e[31m"xinetd start Error!" \e[0m"
fi

systemctl restart tftp
if [ `echo $?` -eq 0 ]
then
    echo -e "\e[32m"tftp service start!" \e[0m"
else
    echo -e "\e[31m"tftp start Error!" \e[0m"
fi

# 解决tftp服务自己停止
sh ./tftp_service.sh
