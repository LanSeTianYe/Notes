时间：2019/4/11 22:59:21 

参考：

1. [Python 内置函数](http://www.runoob.com/python3/python3-built-in-functions.html)

版本：

* python3

## Python 内置函数   

1. `abs()`: 绝对值。
2. `dict()`:字典。
3. `all()`：可迭代参数的值都为 `True` 返回 `True`， 否则返回 `False`。
4. `any`: 有一个为真返回会 `True`。
5. `ascii()`: 返回 `ascii` 编码表示的值，超出范围的使用 `\x \u \U` 表示。

		ascii("1a联通")
		# 输出
		1a`\u8054\u901a
6. `bin()`：返回 `int` 或 `long int` 的二进制表示。
7. `bool()`：转换 `boolean` 类型。
8. `chr()`：整数转换为编码表对应的字符。
9. `oct()`：数字(十进制、二进制、十六进制)转换为八进制。
9. `hex()`：数字（二进制、八进制、十进制）转换为十六进制。
10. `str()`：对象转换为字符串。
10. `int()`：字符串转换为整形。
11. `float()`：数字和字符串转换为浮点型。
11. `len()`：元素的长度。
12. `max()`：最大值。
13. `sum()`：求和。
12. `id()`：获取对象的内存地址。
12. `range(0，n)`：生成 `[0，n)` 的迭代列表。
13. `sorted()`：根据原数组生成新的有序数组。
14. `list()`：将字符串和元组转换为列表。
14. `tuple()`：数组转换为元组。
15. `slice()`：切片，作为参数传递。
	* `slice(stop)`: 截取 `[0,stop)`
	* `slice(start, stop, [step])`：从 `start` 开始到 `stop` 结束每隔 `step` 个取一个。类似于 `start, strat + step, strat + step + step`

14. `zip()`:将可迭代列表的数据打包成元组，根据参数个数确定元组的个数。

		for t in zip("123", "abc"):
		    print(t)
		# 输出结果
		('1', 'a')
		('2', 'b')
		('3', 'c')