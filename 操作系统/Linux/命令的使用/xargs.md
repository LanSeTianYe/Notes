时间：2019/2/11 15:00:05   

## xargs   

把前面的输出当作参数传给当前命令  

### 选项  

* `d`：指定分割符。
* `p`：输出完整的要执行的命令。
* `n`：参数数量。
* `e`：指定参数结束符，指定的结束符和以后的数据不会再被指令接收。

### 用例  

1. 输出传递的参数。
	
	```shell
	echo "123:456:789" | xargs echo
	```

3. 指定分隔符，输出传递的参数。
	
	```shell
	echo "123:456:789" | xargs -d ":" echo
	```

4. 限制每次接收参数的个数，指定分隔符，输出传递的参数。
	
	```shell
	# 会输出三行
	echo "123:456:789" | xargs -n 1 -d ":" echo
	```

