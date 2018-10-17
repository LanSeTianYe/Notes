时间：2018/10/17 17:53:52  

参考： 

1. [OpenResty最佳实践](https://www.gitbook.com/book/moonbingbing/openresty-best-practices)

## Lua 常用函数库  

### 字符串  

	local name = "XiaoTian"
	
* 转换为大写

		print(string.upper(name))
* 转换为小写

		print(string.lower(name))
* 字符串长度

		print(string.len(name))
* 查找字符

		print(string.find(name, "a"))
* 返回字符对应的 ASCII 码，(字符串，start，end)，start从1开始。

		print(string.byte(name, 1, string.len(name)))
* 返回数字对应的ASCII组成的字符串

		print(string.char(96, 97, 98))
* 格式化字符串 %d 十进制 %x十六进制 %o八进制 %f浮点数 %s字符串

		print(string.format(""))
* 匹配字符串，匹配成功返回匹配的字符串

		print(string.match("hello lua", "lua"))
* %a 匹配字母

		s = "hello world from Lua"
		for w in string.gmatch(s, "%a+") do
		    --匹配最长连续且只含字母的字符串
		    print(w)
		end
* 重复字符串

		print(string.rep(name, 3))
* 子字符串 ia， 下标从1开始

		print(string.sub(name, 2, 3))
* 查找并替换

		-- hello hello hello   3
		print(string.gsub("Lua Lua Lua", "Lua", "hello"))
		-- hello hello Lua     2
		print(string.gsub("Lua Lua Lua", "Lua", "hello", 2)) --指明第四个参数
* 反转字符串

		print(string.reverse(name))
### table

* 获取长度

		table.getn(s)
* 链接元素返回字符串
	
		print(table.concat(s, ",")) 
* 插入元素，在指定元素之前插入

		table.insert(s, 2, 3)
* 返回table的最大索引编号 

		table.maxn(s)
* 删除元素，删除指定索引位置的元素 

		table.remove(s, 2)
* 排序数组

		local compare = function(x,y)
		    return x > y
		end
		table.sort(s, compare)
### 文件操作函数

按指定的模式 mode，打开一个文件名为 filename 的文件，成功则返回文件句柄，失败则返回 nil 加错误信息。

语法：

	io.open (filename [, mode]) 

模式及其作用：

|模式|含义|文件不存在时|
|::|::|::|
|"r"|	读模式 (默认)|返回nil加错误信息|
|"w"|	写模式|	创建文件|
|"a"|	添加模式|	创建文件|
|"r+"|	更新模式，保存之前的数据	|返回nil加错误信息|
|"w+"|	更新模式，清除之前的数据	|创建文件|
|"a+"|	添加更新模式，保存之前的数据,在文件尾进行添加	|创建文件|

常用函数： 

* file:close ()：关闭文件。注意：当文件句柄被垃圾收集后，文件将自动关闭。句柄将变为一个不可预知的值。
* io.close ([file])：关闭文件，和 file:close() 的作用相同。没有参数 file 时，关闭默认输出文件。
* file:flush ()：把写入缓冲区的所有数据写入到文件 file 中。
* io.flush ()：相当于 file:flush()，把写入缓冲区的所有数据写入到默认输出文件。
* io.input ([file])：当使用一个文件名调用时，打开这个文件（以文本模式），并设置文件句柄为默认输入文件； 当使用一个文件句柄调用时，设置此文件句柄为默认输入文件； 当不使用参数调用时，返回默认输入文件句柄。
* file:lines ()：返回一个迭代函数, 每次调用将获得文件中的一行内容, 当到文件尾时，将返回 nil，但不关闭文件。
* io.lines ([filename])：打开指定的文件 filename 为读模式并返回一个迭代函数, 每次调用将获得文件中的一行内容, 当到文件尾时，将返回 nil，并自动关闭文件。若不带参数时 io.lines() 等价于 io.input():lines() 读取默认输入设备的内容，结束时不关闭文件。
* io.output ([file])：类似于 io.input，但操作在默认输出文件上。
* file:read (...)：按指定的格式读取一个文件。
* io.read (...)：类似于 file:read (...)。
* io.type (obj)：检测 obj 是否一个可用的文件句柄。如果 obj 是一个打开的文件句柄，则返回 "file" 如果 obj 是一个已关闭的文件句柄，则返回 "closed file" 如果 obj 不是一个文件句柄，则返回 nil。
* file:write (...)：把每一个参数的值写入文件。参数必须为字符串或数字，若要输出其它值，则需通过 tostring 或 string.format 进行转换。
* io.write (...)：相当于 io.output():write。
* file:seek ([whence] [, offset])：设置和获取当前文件位置，成功则返回最终的文件位置(按字节，相对于文件开头),失败则返回 nil 加错误信息。
* file:setvbuf (mode [, size])：设置输出文件的缓冲模式。

