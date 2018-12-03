时间：2018/10/18 10:55:52   

参考：  

##  Lua 高级语法  
### 元表 (meattable)

类似于其他语言的重载操作，重载运算操作 如 `+` 等。  

Lua 提供了两个用来处理元表的方法：

* `setmetatable(table, metatable)`：此方法用于为一个表设置元表。
* `getmetatable(table)`：此方法用于获取表的元表对象。

**可以重载的方法：** 

|元方法	|含义|
|::|::|
|"__add"	|+ 操作|
|"__sub"	|- 操作 其行为类似于 "add" 操作|
|"__mul"	|* 操作 其行为类似于 "add" 操作|
|"__div"	|/ 操作 其行为类似于 "add" 操作|
|"__mod"	|% 操作 其行为类似于 "add" 操作|
|"__pow"	|^ （幂）操作 其行为类似于 "add" 操作|
|"__unm"	|一元 - 操作|
|"__concat"	|.. （字符串连接）操作|
|"__len"	|# 操作|
|"__eq"	|== 操作 函数 getcomphandler 定义了 Lua 怎样选择一个处理器来作比较操作 仅在两个对象类型相同且有对应操作相同的元方法时才起效|
|"__lt"	|< 操作|
|"__le"	|<= 操作|
|"__index"	|取下标操作用于访问 table[key]，根据下标访问元素，当表中不存在对应元素的时候，通过重载的函数返回对应的值|
|"__newindex"	|赋值给指定下标 table[key] = value|
|"__tostring"	|转换成字符串|
|"__call"	|当 Lua 调用一个值时调用|
|"__mode"	|用于弱表(week table)|
|"__metatable"	|用于保护metatable不被访问|


**重载 `+` 操作:** 

	local set1 = { 1, 2, 3 }
	local set2 = { 3, 4, 100 }
	
	-- 定义合并函数
	local union = function(self, other)
	    local indexSet = {}
	    local result = {}
	
	    for i, v in pairs(self) do
	        indexSet[v] = true
	    end
	    for i, v in pairs(other) do
	        indexSet[v] = true
	    end
	
	    -- 遍历value不为空的元素
	    for k, v in pairs(indexSet) do
	        table.insert(result, k)
	    end
	
	    return result
	
	end
	
	-- 重载元方法
	setmetatable(set1, { __add = union })
	
	local set3 = set1 + set2
	
	for k, v in pairs(set3) do
	    print(string.format("%s : %s", k, v))
	end

### 面向对象 

#### 对象定义和使用  
注：通过 `:` 定义和调用函数，`self` 参数省略。通过 `.` 不能省略。

通过 `__index` 元表实现对象，表中找不到对应元素则会从 `__index` 指定的表中查找。

**定义对象 `person.lua` :** 

	local _Person = {}
	
	function _Person:getName()
	    return self.name
	end
	
	function _Person:sayHello()
	    print("Hello Lua!")
	end
	
	function _Person:new(name)
	    name = name or "default name"
	    return setmetatable({ name = name }, { __index = _Person })
	end
	
	return _Person
 
**初始化和使用对象：**   

	local person = require("person")
	
	-- 初始化对象
	local xiaoTian = person:new("XiaoTian")
	
	-- 调用对象的方法
	xiaoTian:sayHello()
	print(xiaoTian.name)
	print(xiaoTian:getName())

#### 继承 

继承可以用元表实现，它提供了在父类中查找存在的方法和变量的机制。在 Lua 中是不推荐使用继承方式完成构造的，这样做引入的问题可能比解决的问题要多。

#### 成员私有性  
在 Lua 中，成员的私有性，使用类似于[函数闭包](https://blog.csdn.net/qibin0506/article/details/73395115)的形式来实现。代码如下：  

	function newAccount (initialBalance)
	    local self = {balance = initialBalance}
	    local withdraw = function (v)
	        self.balance = self.balance - v
	    end
	    local deposit = function (v)
	        self.balance = self.balance + v
	    end
	    local getBalance = function () return self.balance end
	    return {
	        withdraw = withdraw,
	        deposit = deposit,
	        getBalance = getBalance
	    }
	end
	
	a = newAccount(100)
	a.deposit(100)
	print(a.getBalance()) --> 200
	print(a.balance)      --> nil

### 虚变量  

`_` 表示虚变量，可以用来接收并丢弃多余的返回值，或者迭代器结果。
 
