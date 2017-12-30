时间：2017/12/30 15:18:04 

参考：  

1. [CentOS7中systemctl的使用](http://blog.csdn.net/u012486840/article/details/53161574)

## 系统服务启动管理 `systemctl`
### 服务管理  
1.  运行服务：`systemctl start service_name`
2.  重启服务：`systemctl restart service_name`
3.  重载服务：`systemctl reload service_name`
3.  停止服务：`systemctl stop service_name`
4.  开机启动：`systemctl enable service_name`
4.  开机不启：`systemctl disable service_name` 
5.  注销服务：`systemctl mask  service_name`
5.  取消注销：`systemctl unmask service_name`
6.  查看状态：`systemctl status service_name`
### 服务查看 
1. 查看所有系统服务： `systemctl`
2. 查看所有启动 unit: `systemctl list-units`
3. 查看所有启动文件：`systemctl list-unit-files`
4. 列出所有service类型的util: `systemctl list-units –type=service –all`
5. 列出 cpu相关 : `systemctl list-units –type=service –all grep cpu`
6. 查看服务是否运行 : `systemctl is-active service_name`
7. 查看服务是否开机启动: `systemctl is-enable service_name`
8. 查看服务之间的依赖关系：`systemctl list-dependencies [unit] [–reverse]`

		systemctl list-dependencies
		systemctl list-dependencies boot.mount

## 防火墙操作 `firewall `

* 打开防火墙 ：`systemctl start firewalld`
* 停止防火墙 ：`systemctl stop firewalld`
* 重启防火墙 ：`systemctl restart firewalld`
* 查看防火墙版本 ：`firewall-cmd --version`
* 查看状态： `firewall-cmd --state`
* 显示所有打开的窗口: `firewall-cmd --zone=public --list-ports`
* 更新防火墙规则: `firewall-cmd --reload`
* 拒绝所有包：`firewall-cmd --panic-on`
* 取消拒绝状态： ` firewall-cmd --panic-off`
* 查看是否拒绝：`firewall-cmd --query-panic`
* 打开一个端口的步骤 : 
	
		//1. 添加 --permanent永久生效，没有此参数重启后失效
 		firewall-cmd --zone=public --add-port=80/tcp --permanent
		//2. 重新加载
		firewall-cmd --reload
		//3. 查看
		firewall-cmd --zone=public --query-port=80/tcp
		//4. 删除
		firewall-cmd --zone=public --remove-port=80/tcp --permanent
