## 配置环境变量

* 永久修改 ，以JDK环境变量为例
 
	1. 打开配置文件 `vim /etc/profile`
	
	2. 添加如下内容: 

			export JAVA_HOME="/usr/java/jdk1.8.0_77"`
			export CLASSPATH=".:$JAVA_HOME/lib:$JAVA_HOME/jre/lib"
			export PATH=":JAVA_HOME/bin:$PATH"

	3. 刷新配置文件。
	
		 	source /etc/profile
 
## 遇到的问题
1. 重新登录之后设置的 jdk  不起作用。

    * 问题原因：Linux 会先读取 `/etc/proflie` 再读取 `~/.bashrc` 文件的配置。 `~/.bashrc` 代表当前用户的配置，`~/bashrc` 的配置覆盖了 `/etc/profile` 里面的配置。

    * 解决办法： 删除 `~/.bashrc` 里面的配置即可。
