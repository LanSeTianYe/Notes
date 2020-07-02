时间：2019/2/4 17:36:31 

## shell 变量  

### 一般变量声明和取消声明  

变量声明使用 `名字=变量存储的内容` 格式，主已等号左右不可以有空格。 `unset` 指令可以把变量的内容设置为空。

	name=123
	echo ${name}       # print 123
	unset name 
	echo ${name}       # 输出空

指定变量类型：

	declare -i var_name   # 整形
	declare -a var_name   # 数组
	user[i]=value
	declare -x var_name   # 环境变量
	declare +x var_name   # 取消设置为环境变量
	declare -r var_name   # 只读类型
	declare -p var_name   # 查看变量类型 
### 环境变量  

环境变量类似于全局变量，在 `shell` 中使用 `declare -x` 或 `export` 声明，在当前登陆的 `shell` 以及子程序中有效。

	name=123
	# 定义环境变量
	declare -x name
	# 环境变量转换为普通变量
	decalre +x name
	# 声明环境变量
	export name
	# 查看环境变量
	env
	export
	
常用环境变量：

* `$`：当前bash的PID。
* `?`：上一个程序的返回值，执行成功返回0，失败返回错误信息。

### 读取输入信息到变量

	# 读取信息到变量，显示提示消息并指定等待时间
	read -p "message" -t wait_time var_name

