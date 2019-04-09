时间：2019/4/8 15:59:21  

参考：

## Python 基础语法   

### 变量  

1. 变量定义和赋值。
   
		name = "xiaotian"
		age = 24

2. 数学运算： `+ - * / % **`。  

3. 类型转换：`int() float() str()`。  

4. 数组。

		days = ["1", 2, 3, 4, "5", 6]
		days[0]
		days[-1]
		days[0] = 1
		# [0,3)
		days[0:3]
		days[3:]
		# 数组末尾添加元素
		days.append(7)
		# 在索引前面插入元素，大于数组最大索引则在末尾插入
		days.insert(100, 101)
		# 删除元素
		del days[5]
		# 删除并取得最后一个元素
		days.pop()
		# 删除并取出索引为0的元素
		days.pop(0)
		# 删除指定元素，删除最靠前的一个
		days.remove("1")
		# 数组长度 
		len(days)
		# 排序
		# 原数组排序
		days.sort(key=int, reverse=True)
		# 排序后生成新数组，原数组不变
		sorted(days, key=int, reverse=True)
		# 复制
		days_two = days[:]
5. 元组，值不可以改变，但是变量可以重新指定为其它变量。
	
		dimensions = (3, 4, 5)
		dimensions[0]
		// error dimensions[0] = 100
		dimensions = (6, 8, 10)
6. 字典。

		person = {"name": "xiaotian", "age": 26}
		# 访问元素
		person["name"]
		# 变更/插入元素
		person["country"] = "China"
		# 删除
		del person["age"]
		# 遍历
		for key, value in person.items():
		# 遍历 key、value
		for key in person.keys():
		for key in person.values():
7. 集合。

		numbers = set(numbers)

### for 循环  

1. 遍历数组。

		for day in days:
		    print(day)

		for number in range(3):
    		print(number)

### if 语句 

常用运算符： `== > < >= <= !=`。  
多条件：`and or`。  
数组、元组包含：`in not in`。  
数组、元组、字典不为空：`if var_name:`。
 
1. if 语句使用。

		for day in days:
		    if int(day) % 2 == 0:
		        print(day)
2. 数组包含。

		days = ["1", 2, 3, 4, 5, 6]
		if 2 in days:
		    print("2 in days")
3. if-else 使用。

		if sex == "man":
		    print("you are man!")
		elif sex == "women":
		    print("you are woman!")
		else:
		    print("you are not man or woman!")

### while 语句

1. 简单使用。

		while True:
		    message = input("Please input you name: ")
		    if message.lower() == "quit":
		        print("exit")
		        break
		    print(message)

### 异常处理  

1. 异常处理模型。

		try:
		    print(5 / 1)
		except ZeroDivisionError as err:
		    print("You can't divide by zero!")
		except FileNotFoundError as err:
    		pass
		else:
		    print("other")
### 函数 

1. 一般函数。

		def print_list(arr: list = ["default"]):
		    if arr:
		        for a in arr:
		            print(a.title())
		    else:
		        print("arr is empty!")

		print_list(arr=["xiao tian", "xiao ming", "shao hui"])
		print_list()

2. 变长参数，参数类型，默认值，返回值类型。`users` 以元组的形式存在。

		def show_users(*users: str, age: int = 0) -> int:
		    print(age)
		    for user in users:
		        print(user.title())
		
		    return age
3. 接收字典。

		def build_user(name: str = "", age: int = 0, **user_info) -> dict:
		    user = {}
		    if name:
		        user["name"] = name
		    if age:
		        user["age"] = age
		    if user_info:
		        for k, v in user_info.items():
		            user[k] = v
		    return user

### 类 

1. 类、类继承、重写方法。

		class Car:
		    def __init__(self, name: str = "", year: int = 0):
		        self.name = name
		        self.year = year
		
		    def __str__(self) -> str:
		        return self.name + str(self.year)
		
		    def show_name(self):
		        print(self.name.title())
		
		class BMW(Car):
		    def __init__(self, year: int = 0):
		        super().__init__("BMW", year)
		
		    def __str__(self):
		        return super().__str__()
### 模块导入 

1. 导入整个模块。

		import util.printutil as pu
		from util import printutil

2. 导入模块中特定函数。
		
		# from 模块（目录） 导入文件 
		from util.printutil import print_key_value, print_key_value_1
		# 导入所有函数
		from util.printutil import *
3. 导入类。

		# from 模块.文件 导入类
		from demo.timerecord import TimeRecord
