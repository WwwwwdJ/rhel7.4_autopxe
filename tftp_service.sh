#!/bin/bash

active=`systemctl status tftp | grep Active: | awk -F' ' '{print $2}'`
script_pwd="/root/tftp_service.sh"
script_now_pwd=`find / -name 'tftp_service.sh' 2> /dev/null`
cat_crontab=`cat /var/spool/cron/root 2> /dev/null | sed -n '/tftp_service/p'` 
cron="*/1 * * * * sh ~/tftp_service.sh >> /var/log/tftp_service.log 2>&1"

# 检查服务状态
function check_service_status() {
    echo
    date
    if [ $active != "active" ]
    then
        systemctl restart tftp
        active_now=`systemctl status tftp | grep Active: | awk -F' ' '{print $2}'`
        echo "+------------------------------+"
        echo -e "|服务状态异常 状态为: \e[31m"$active" \e[0m|"
        if [ $active_now == "active" ]
        then
            echo -e "|服务进行重启 状态为: \e[32m$active_now \e[0m  |" 
        else    
            echo -e "|服务进行重启 状态为: \e[31m$active_now \e[0m |"
        fi
        echo "+------------------------------+" 
    else
        echo "+------------------------------+"
        echo -e "|服务状态正常 状态为: \e[32m"$active" \e[0m  |"
        echo "+------------------------------+" 
    fi
    
}

# 检查脚本位置
function check_pwd() {    
    while [ $script_now_pwd != $script_pwd ]
    do
        mv $script_now_pwd $script_pwd
        script_new_pwd=`find / -name 'tftp_service.sh' 2> /dev/null` 
        echo -e "tftp_service.sh现在位置: $script_new_pwd" 
        break
    done
}

# 添加定时任务
function add_cron() {
    while [ "$cat_crontab" != "$cron" ]
    do
        echo "$cron" >> /var/spool/cron/root
        echo -e "\e[32m"定时已添加 每1分钟执行一次" \e[0m"
        break
    done   
}

function main() {
    check_service_status
    check_pwd
    add_cron
}

main
