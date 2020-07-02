时间：2019/1/29 20:45:25  

## Linux 用户切换

Linux 的用户分为root用户和其它用户，root用户拥有系统的一切权限，其它用户则拥有被配置的权限。为了系统安全一般情况下使用普通用户登陆到系统，等需要超级用户权限的时候再切换到超级用户，这样普通用户运行的程序如果攻破，攻击者拿不到超级用户权限，可以减少损失。

### 切换用户命令  

* `su` : 切换用户身份

		su               # 非login方式登陆，用户对应的初始化文件不会执行, 如 `.bashrc`等。（谨慎使用） 
		su -             # login 方式登陆
		su - user_name     # 切换到指定用户
		su - -c 指令     # 仅执行一次指令  
* `sudo`：切换用户，仅需要输入用户自己的密码。只有配置在  `/etc/sudoers` 中的用户才可以执行 sudo 指令。

	*  `visudo`: 编辑 `/etc/sudoers` 文件。

			# 可执行的用户 用户来源=可切换的用户 可执行的指令
			root    ALL=（ALL）       ALL
			# 使用 sudo 切换到 root 用户的配置，使用 `sudo su -` 进行切换
			User_Alias ADMINS = xiaotian
			ADMINS ALL=(root) /bin/su -
	*  `sudo -u xiaotian command` 以xiaotian的身份执行命令。

### 查看用户  

* `w`：查看当前登陆的用户，并查看正在做什么。	
* `last`: 查看用户登陆历史。
* `lastlog`: 查看每个用户最近登陆的历史。
* `id`:输出用户ID和用户组ID。		

### 用户间通信   
* `write`：给其它用户发送消息，直接写消息到其它用户的终端窗口，可能会打断其它用户的操作。

		# 使用者 [使用者所在终端接口]
		write vbird1 pts/2
* `mesg`：设置是否允许其它用户向自己的终端中写数据。

		mesg n
		mesg y
* `wall`：广播发送信息给所有用户。
* `mail`：发送邮件。

		mail -s "nice to meet you" xiaotian
		mail -s "nice to meet you" xiaotian < file_name
		输入信件内容，最后行输入.结束

#### Linux PAM 模块 

PAM 全称 Pluggable Authentication Modules 嵌入式认证模块，提供认证相关的接口，需要使用的地方根据相应的语法调用即可。

	# /etc/pam.d/passwd 的内容
	auth       include      system-auth
	account    include      system-auth
	password   substack     system-auth
	-password   optional    pam_gnome_keyring.so use_authtok
	password   substack     postlogin

分别是：

* 验证类别：
	* `auth`: 认证，检验用户身份。
	* `account`: 账号，验证是否有对应权限。
	* `session`: 登陆期间的认证。
	* `password`：密码相关，密码验证。
* 控制标准：
	* `required`: 成功返回 success 标识，失败返回 fail 标识，无论成功与失败都会执行后续的流程。
	* `requisite`：成功返回 success 标识，失败返回 fail 标识，如果验证失败，后续的历程不会继续执行。
	* `sufficient`:成功返回 success 终止验证，失败返回 fail 继续后续流程。
	* `optional`: 显示信息，不执行之际的认证。
* PAM模块和相应的参数： 
	* `pam_securetty.so`
	* `pam_limits.so`	
	* `pam_env.so` 