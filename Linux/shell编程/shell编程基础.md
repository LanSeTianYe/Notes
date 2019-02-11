时间：2017/12/16 10:19:01 

参考：  

1. 鸟哥的Linux私房菜：基础学习篇 第四版

## shell基础  

### 基础语法

#### 变量  
  
* `unset 变量名`：删除变量。
* ` result=${name:-"10"}`：不存在时使用默认值10。
* `数组`
		
		declare -a arr
		arr[1]=name;
		echo ${arr[1]}
		# 输出数组中的所有元素
		echo ${arr[@]}
		# 数组长度
		echo ${#arr}  

#### 参数接收      

* `$0`：脚本本身。  
* `$n`：第n个参数。
* `$#`：参数个数。
* `$@`：`"$1" "$2" "$3" ...` 所有参数。
* `$*`：`"$1 $2 $3 ..."`，用空格分割。
* `shift n`：移除前面 `n` 个参数， 默认是1。
#### 数值计算    

	result=$((1*2*3*4))
	# 浮点运算
	result=`echo "1.1*2.2*3.3"|bc`
 
#### 条件语句  

	read -p "Please input your choice:[Y/N]" yn
	if [ "${yn}" == "Y" -o "${yn}" == "y" ]; then
	  echo "your choice is yes."
	elif [ "${yn}" == "N" -o "${yn}" == "n" ]; then
	  echo "your choice is no."
	else
	  echo "unknow choice: ${yn}"
	fi
	exit 0
#### case 语句 

	input=$1
	case ${input} in
	  "h")
	    echo "Hello!"
	    ;;
	  "w")
	    echo "World!"
	    ;;
	  *)
	    echo ${input}
	    ;;
	esac
	exit 0

#### for 循环 

**for in：**

	users=$(cat /etc/passwd | cut -d ":" -f 1)
	for user in ${users}
	do
	  echo ${user}
	done
	exit 0
**for do done：** 

	for ((i=0; i<10; i++))
	do
	  echo ${i}
	done
	exit 0

#### while 循环

	times=1
	
	while [ "${times}" -ne "11" ]
	do
	  echo ${times}
	  times=$((${times} + 1))
	done
	
	times=10
	until [ "${times}" -eq "0" ]
	do
	  echo ${times}
	  times=$((${times} - 1))
	done
	
	exit 0
   
#### 函数
	
	function show_message() {
	  echo -n "you input is: "
	}
	
	read -p "Please enter you word:" input
	show_message; echo "${input}"
	read -p "Please enter you word:" input
	show_message; echo "${input}"