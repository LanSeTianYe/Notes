时间：2019/4/1 21:13:46  

## Git 配置    

1. 查看配置信息。
	
		# 产看当前项目
		git config --list
		# 查看全局配置
		git config --list --global

2. 编辑配置信息。

		git config -e [--global]

3. 配置局部或全局用户名。

		git config [--global] user.name "sunfeilong1993"
		git config [--global] user.email "1498282352@qq.com"

4. 配置支持长路径文件。  

		git config --global core.longpaths true

6. Linux 命令行显示颜色。 

		git config --global color.ui auto

7. 配置别名，类似于Linux的别名。

		git config --global alias.co checkout