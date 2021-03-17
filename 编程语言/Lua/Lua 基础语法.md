参考：

1. [OpenResty最佳实践](https://www.gitbook.com/book/moonbingbing/openresty-best-practices)
1. [Lua在线编辑器](http://www.tutorialspoint.com/execute_lua_online.php)

## lua 基础语法  

### 变量类型

**基础变量类型：**

	print(type("hello world")) -->output:string
	print(type(print))         -->output:function
	print(type(true))          -->output:boolean
	print(type(360.0))         -->output:number
	print(type(nil))           -->output:nil

`nil` 被用来表示无效值，变量在第一次被赋值前默认值是 `nil`。 

Lua 默认变量都是全局变量，如果需要应用于本地 需要加 `lcoal name = "xiaotian"` 修饰。

Lua 中 nil 和 false 为假，其余全部为真。

**复杂变量类型：**

table 默认下表从一开始，而且长度函数取得的长度是第一个nil元素之前的长度。所以不要在 Lua 的 table 中使用 nil 值，如果一个元素要删除，直接 remove，不要用 nil 去代替。

	local corp = {
	    web = "www.google.com", --索引为字符串，key = "web",value = "www.google.com"
	    telephone = "12345678", --索引为字符串
	    staff = { "Jack", "Scott", "Gary" }, --索引为字符串，值也是一个表
	    100876, --相当于 [1] = 100876，此时索引为数字 key = 1, value = 100876
	    100191, --相当于 [2] = 100191，此时索引为数字
	    [10] = 360, --直接把数字索引给出
	    ["city"] = "Beijing" --索引为字符串
	} 
	
	print(corp.web)               -->output:www.google.com
	print(corp["telephone"])      -->output:12345678
	print(corp[2])                -->output:100191
	print(corp["city"])           -->output:"Beijing"
	print(corp.staff[1])          -->output:Jack
	print(corp[10])               -->output:360

**表达式：**

* 数学运算： `+ - * / & ^` 。
* 条件运算: `> >= < <= == ~=`
* 逻辑运算： `and or`。 

		a and b 如果 a 为 nil，则返回 a，否则返回 b。
		a or b 如果 a 为 nil，则返回 b，否则返回 a。
		
		local c = nil
		local d = 0
		local e = 100
		print(c and d)  -->打印 nil
		print(c and e)  -->打印 nil
		print(d and e)  -->打印 100
		print(c or d)   -->打印 0
		print(c or e)   -->打印 100
		print(not c)    -->打印 true
		print(not d)    -->打印 false

**字符串连接：**  

在 Lua 中连接两个字符串，可以使用操作符“..”（两个点）。如果其任意一个操作数是数字的话，Lua 会将这个数字转换成字符串。注意，连接操作符只会创建一个新字符串，而不会改变原操作数。也可以使用 string 库函数 string.format 连接字符串。

	print("Hello " .. "World")    -->打印 Hello World
	print(0 .. 1)                 -->打印 01
	
	str1 = string.format("%s-%s","hello","world")
	print(str1)              -->打印 hello-world
	
	str2 = string.format("%d-%s-%.2f",123,"world",1.21)
	print(str2)              -->打印 123-world-1.21

由于 Lua 字符串本质上是只读的，因此字符串连接运算符几乎总会创建一个新的（更大的）字符串。这意味着如果有很多这样的连接操作（比如在循环中使用 .. 来拼接最终结果），则性能损耗会非常大。在这种情况下，推荐使用 table 和 table.concat() 来进行很多字符串的拼接，例如：
### 控制语句 

* if：关键字`if...then\elseif...then\else\end`

		if true then
		    print("true")
		elseif true then
		    print("...")
		else
		    print("......")
		end
* while: 关键字 `while ...do \end\break`

		local count = 2
		while count > 0 do
		    print(count)
		    count = count - 1
		    if (count == 1) then
		        break
		    end
		end
* do while: 关键字: `repeat\until`

		count = 2
		repeat
		    print(count)
		until count == 2

* for: 循环

	常用的迭代器有： 迭代文件中每行的（io.lines）、 迭代 table 元素的（pairs）、迭代数组元素的（ipairs）、迭代字符串中单词的（string.gmatch）等。

		-- 数字遍历 [start,end,step]
		for i = 0, 4, 2 do
		    print(i)
		end
		-- 遍历数组
		local hobby = { "篮球", "听歌", "看书" }
		for index, value in ipairs(hobby) do
		    print(string.format("%s : %s", index, value))
		end
		-- 遍历文件行
		for line in io.lines("d:\\test.txt") do
		    print(line)
		end
* `do  return end` ：不执后面的语句。

###  定义函数 

	local printNewBlock = function(blockName)
	    print()
	    print("-----------------------------------")
	    print(blockName)
	end

* 如果传递参数个数小于实际参数个数，未传递的值为 `nil`。
* 如果传递参数个数大于实际参数个数多余的被忽略。
* 支持可变长度参数。

		local unFixedParam = function(...)
		    print(table.concat({ ... }))
		end
* 基本变量按值传递，table传递引用。
* 函数返回值，可以有多个返回值。
	* 返回值大于接收变量的数量多余的会被忽略，小于多余的接收变量为 `nil`。

			local multiReturnValue = function()
		    	return "name", "age"
			end
			local name, age = multiReturnValue()
			printNewBlock(string.format("%s : %s", name, age))
	* 当一个函数有一个以上返回值，且函数调用不是一个列表表达式的最后一个元素，那么函数调用只会产生一个返回值, 也就是第一个返回值。

			local function init()       -- init 函数 返回两个值 1 和 "lua"
			    return 1, "lua"
			end
			
			local x, y, z = init(), 2   -- init 函数的位置不在最后，此时只返回 1
			print(x, y, z)              -->output  1  2  nil
			
			local a, b, c = 2, init()   -- init 函数的位置在最后，此时返回 1 和 "lua"
			print(a, b, c)              -->output  2  1  lua
			
			local function init()
			    return 1, "lua"
			end
			
			print(init(), 2)   -->output  1  2
			print(2, init())   -->output  2  1  lua
	* 只取函数第一个返回值

			local function init()
			    return 1, "lua"
			end
			
			print((init()), 2)   -->output  1  2
			print(2, (init()))   -->output  2  1
	* 把函数作为参数

			local function run(x, y)
			    print('run', x, y)
			end
			
			local function attack(targetId)
			    print('targetId', targetId)
			end
			
			local function do_action(method, ...)
			    local args = { ... } or {}
				-- unpack 从参数table中解析出参数
			    method(unpack(args, 1, table.maxn(args)))
			end
			
			do_action(run, 1, 2)         -- output: run 1 2
			do_action(attack, 1111)      -- output: targetId    1111

### 模块定义    

定义模块，在当前目录下创建 `print_info.lua`，内容如下：

	local model = {}
	
	model.print_message = function(message)
	    print(message)
	end
	
	return model
引用模块儿：

	local pf = require("print_info")
	pf.print_message("use model")