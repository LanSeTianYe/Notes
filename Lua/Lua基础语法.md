## 全局变量和局部变量

	print ("空的变量",b)
	b = 10 	------全局变量
	print ("全局变量",b)
	
	local c = 11
	print ("局部变量",c)

## 从控制太读取数据

		print("请输入一个数字")
		a = io.read("*number")
		print (a)

## 保留字

![保留字](http://7xle4i.com1.z0.glb.clouddn.com/mackdownLua保留字.jpg)

* 注意
 1. Lua是大小写敏感的
 2. 单行注释  `--`
 3. 多行注释 `--[[  --]]`

## 命令行参数
* 在脚本中可以通过 arg[n] 来获取
![命令行参数](http://7xle4i.com1.z0.glb.clouddn.com/mackdownLua参数.jpg)

## 8中变量类型
* `nil` `boolean` `string` `table` `function` `number` `userdata` 和 `thread`

	![变量类型](http://7xle4i.com1.z0.glb.clouddn.com/mackdownLua变量.jpg)
 * boolean 除了false和nil都为真
 * string [[...]] 表示字符串，中间的内容不会被转义
 * 连接符 `..`	`print (20 .. 15)`  `输出:2015`
 * tonumber()转换为数字，如果要转换的内容不是数字，则转换结果为nil
 * tostring() 转换为字符串
 
## 表达式
* 一元运算符  `-` 负值
* 二元运算符 `+` `-` `*` `/` `^` (加减乘除幂)	
* 关系运算符 `>` `<` `==` `~=` `>=` `<=`
* Lua通过引用比较tables、userdata、functions。也就是说当且仅当两者表示同一个对象时相等。
* 逻辑运算符 `and` `or` `not` (false和nil为假，其余全为真)
* and or not 


![and or not](http://7xle4i.com1.z0.glb.clouddn.com/mackdownand或者not.jpg)

* table 强大的结构

		table1 = {color = "red", name = "sunfeilong", {x = 10, y = 11}, {x = 20 , y = 21},["name1"] = "longlongxiao"}
	
		print (table1.color)
		print (table1[1].x)
		print (table1.name1)
输出结果：

		red
		10
		longlongxiao

## 基本语法
* 赋值语句 `a = Hello .. Lua` 
* 多变量赋值 `a, b = 10 , 11 <==> a = 10 b = 11`
* 交换 `x,y = y,x` 交换x，y的值
* 使用do  end 限制局部变量的作用范围
* if 语句

		if conditions then
			then-part 
		end; 

		if conditions then
			then-part 
		else 
			else-part 
		end; 

		if conditions then
			then-part 
		elseif conditions then
			elseif-part 
		..  --->多个elseif 
		else 
			else-part 
		end; 
* while 语句
	
		while condition do
			statements; 
		end;
* repeat-until

		repeat 
			statements; 
		until conditions;
* for（exp1起始值，exp2终止值，exp3递增值可以省略，默认为1）
  * 如果exp2是一个函数调用，，则这个函数调用只会在循环开始前调用一次
  * var 是局部变量
  * break 退出循环  

			for var=exp1,exp2,exp3 do
				loop-part 
			end 

* 泛型for循环
* 
		revDays = { ["Sunday"] = 1,		 ["Monday"] = 2,
					["Tuesday"] = 3, 	 ["Wednesday"] = 4,
					["Thursday"] = 5, 	 ["Friday"] = 6,
					["Saturday"] = 7					   }
		local days = {}
		for k,v in pairs (revDays) do
			days[v] = k
		end
		
		for i,v in ipairs (days) do
			print (i .. v)
		end
输出结果：

		1Sunday
		2Monday
		3Tuesday
		4Wednesday
		5Thursday
		6Friday
		7Saturday


## 函数 
* 函数调用，当函数只有一个参数，并且这个参数是字符串或者表构造的时候，（）可以省略
* 返回多个值,`s, e = string.find("hello Lua users", "Lua")` s开始下标7，结束下标9


## 基础类库
1、 String

		local name =  'sunfeilong'
		--获取字符串的长度
		print (string.len(name))
		print (#name)
		--转换为小写
		print (string.lower(name))
		--转换为大写
		print (string.upper(name))
		--第n个开始截取m个
		print (string.sub(name,1,2))
2、Table库

		--table
		local nameTables = {1,2,3}
		--将数组转换为字符串
		print (table.concat(nameTables))
		--将数组转换为字符串，并指定开始位置和链接的个数
		print (table.concat(nameTables,'o',1,3))
		--向数组中添加元素，默认添加在数组的结尾
		table.insert(nameTables, 5)
		table.insert(nameTables,4,4)
		print (table.concat(nameTables, ',' ,1 ,5))
		--从数组中删除一个元素，默认删除最后一个
		table.remove(nameTables,4)
		print (table.concat(nameTables, ',' ,1 ,4))
		table.remove(nameTables)
		print (table.concat(nameTables, ',' ,1 ,3))
3 Math数学函数库

		
		print (math.abs(-1))
		print (math.sin(0.1))
		print (math.cos(0.1))
		print (math.tan(0.1))
		--进一取整
		print (math.ceil(0.1))
		print (math.floor(0.1))
		print (math.max(1,2,3,4,56,132))
		print (math.min(1,213,213,31,23,123,123,12))
		--2的3次方
		print (math.pow(2,3))
		--平方根
		print (math.sqrt(4))
		--随机数
		print (math.random(4,5))
		math.randomseed(10)
		print (math.random(4,5))