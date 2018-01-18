时间：2018/1/18 13:47:33   

参考 ： 

1. [东北大学 网络威胁黑名单系统](http://antivirus.neu.edu.cn/scan/ssh.php)

环境：  

1. CentOS 7 

### IP登陆黑名单   

	# 确认sshd是否支持TCP Wrapper，输出类似:libwrap.so.0 => /lib/libwrap.so.0
	ldd `which sshd` | grep libwrap  (0x00bd1000)
	# 进入目录
	cd /usr/local/bin/
	# 下载文件
	wget antivirus.neu.edu.cn/ssh/soft/fetch_neusshbl.sh
	# 文件执行权限
	chmod +x fetch_neusshbl.sh
	# 每小时更新，文件目录
	cd /etc/cron.hourly/
	# 建立软连接 
	ln -s /usr/local/bin/fetch_neusshbl.sh .
	# 执行脚本，更新ip黑名单
	./fetch_neusshbl.sh
### 统计攻击次数 

	cat /var/log/secure | awk '/Failed/{print $(NF-3)}' | sort | uniq -c | awk '{print $2" = "$1;}'
