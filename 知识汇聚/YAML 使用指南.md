时间：2018/8/14 11:53:41 

参考：

1. [YAML 语言教程](http://www.ruanyifeng.com/blog/2016/07/yaml.html) 


## YAML 语法简介

YAML 语言（发音 /ˈjæməl/ ）的设计目标，就是方便人类读写。它实质上是一种通用的数据串行化格式。

YAML 是专门用来写配置文件的语言，非常简洁和强大，远比 JSON 格式方便。

**简单示例如：**

	# person对象包含属性 name是一个字段 friends 是一个数组
	person: &xiaotian
	  name: xiaotian
	  age: 25
	  friends:
	    - xiaoming
	    - xiaohui
	  status: true
	  money: 99.99
	  company: ~
	
	persons:
	  # 小田引用自 &xiaotian
	  - xiaotian: <<: *xiaotian
	
	additional:
	  province:
	  - provinceCode: 71
	    provinceName: 香港
	    countryCode: 156
	    countryName: 中国
	  - provinceCode: 72
	    provinceName: 澳门
	    countryCode: 156
	    countryName: 中国
	  - provinceCode: 73
	    provinceName: 台湾
	    countryCode: 156
	    countryName: 中国

**基本语法规:**

* 大小写敏感
* 使用缩进表示层级关系
* 缩进时不允许使用Tab键，只允许使用空格。
* 缩进的空格数目不重要，只要相同层级的元素左侧对齐即可。
* `#` 表示注释，从这个字符一直到行尾，都会被解析器忽略。
* 引用，`&` 定义引用的内容， `*` 引用定义的内容。

**支持的数据结构：**

* 对象：键值对的集合，又称为映射（mapping）/ 哈希（hashes） / 字典（dictionary）。
* 数组：一组按次序排列的值，又称为序列（sequence） / 列表（list）。
* 纯量（scalars）：单个的、不可再分的值。
	* 字符串: `xiaotian`
		* 默认可以不加引号。
		* 单引号和双引号都可以使用，双引号不会对特殊字符转义。
		* 字符串可以写成多行，从第二行开始，必须有一个单空格缩进。
		* 多行字符串可以使用|保留换行符，也可以使用>折叠换行。
		* `+` 表示保留文字块末尾的换行，`-` 表示删除字符串末尾的换行。
		* 字符串之中可以插入 HTML 标记。
	* 布尔值：`true/false`
	* 整数: `1`
	* 浮点数: `1.2`
	* Null: `~`
	* 时间: 
	* 日期:

注：特殊字符串转义使用 `!!类型 要转义的内容`， 比如： `!!str true`