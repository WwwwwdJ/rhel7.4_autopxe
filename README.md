**使用脚本前请先下载好镜像并将镜像放置与run.sh同一路径**

**使用完成后请将tftp_service.sh添加的定时任务删除，如需再次使用重新执行tftp_service.sh即可**

**脚本执行后会关闭防火墙、selinux并且卸载掉/mnt路径下挂载的文件**

### 启动脚本 
```
sh install.sh
sh run.sh

Enter Network Name: 输入服务器网卡名
Enter Begin of Network range: 地址池范围开始IP
Enter End of Network range: 地址池范围结束IP
Set Passwd: 设置客户机root密码
```

### 镜像下载链接

链接：https://pan.baidu.com/s/1B9w9QEctp4RoRnmCOxrkpQ 
提取码：rhel

