时间：2019/11/27 10:09:01  

参考：

1. [Implicit conversion of a numeric in mysql](https://stackoverflow.com/questions/46235729/implicit-conversion-of-a-numeric-in-mysql#comment79469029_46238773)
2. [Type Conversion in Expression Evaluation](https://dev.mysql.com/doc/refman/5.7/en/type-conversion.html)
3. [MySQL中character set与collation的理解](https://www.cnblogs.com/EasonJim/p/8128196.html)  

## 数据类型转换  

进行比较时，如果数据类型不一致需要进行类型转换，如果不转换 `MYSQL` 会进行隐式数据类型转换使比较可以进行。

在 `MysSQL` 中 `Character Set` 表示字符集，即数据的字符编码。`Collation` 比较方式即校验，每种字符集都有多个对应的 `collation`，一般使用 `字符编码_bin` 的。   

查看字符集和对应校验 `show collation;`。 

### 数据类型转换 

* `BINARY`: 转换成二进制字符串。 
* `CAST`: 转换数据类型。
* `CONVERT`: 转换字符便编码。

#### BINARY 

1. 类型转换  
	
		# 1
		SELECT 'a' = 'A';
		# 0
		SELECT BINARY('a') = BINARY('A');

#### CAST
1.  转换编码  

		SELECT CAST('test' AS CHAR CHARACTER SET utf8);
		# 指定校验规则
		SELECT CAST('test' AS CHAR CHARACTER SET utf8) COLLATE utf8_bin
2.  转换数据类型  

		SELECT CAST(1 - 2 AS UNSIGNED);

	支持的数据类型如下：
	* BINARY：类似于 `CHAR`，使用字节存储数据。
	* CHAR：使用字符存储数据，默认情况下末尾的空格会被忽略。
	* DATE：日期。
	* DATETIME: 日期。
	* DECIMAL：定点数。
	* JSON: JSON 格式。
	* NCHAR: 类似于 CHAR，但是使用国际化的编码方式。
	* SIGNED: 有符号整数。
	* UNSIGNED: 无符号整数。
	* TIME: 时间。

#### CONVERT
  
1. 转换编码  
  
		SELECT CONVERT(_latin1'Müller' USING utf8);
		SELECT CONVERT(latin1_column USING utf8) FROM latin1_table;
		SELECT CONVERT('test', CHAR CHARACTER SET utf8);

### 隐式类型转换 

在实际项目中要避免隐式类型转换，隐式类型转换可能会出现索引用不上，以及数据精度导致比较不符合逾期等问题。

#### 数据转换规则：

>1. If one or both arguments are NULL, the result of the comparison is NULL, except for the NULL-safe <=> equality comparison operator. For NULL <=> NULL, the result is true. No conversion is needed.
>
>2. If both arguments in a comparison operation are strings, they are compared as strings.
>
>3. If both arguments are integers, they are compared as integers.
>
>4. Hexadecimal(十六进制) values are treated as binary strings if not compared to a number.
>
>5. If one of the arguments is a TIMESTAMP or DATETIME column and the other argument is a constant, the constant is converted to a timestamp before the comparison is performed. This is done to be more ODBC-friendly. This is not done for the arguments to IN(). To be safe, always use complete datetime, date, or time strings when doing comparisons. For example, to achieve best results when using BETWEEN with date or time values, use CAST() to explicitly convert the values to the desired data type.
>
>6. A single-row subquery from a table or tables is not considered a constant. For example, if a subquery returns an integer to be compared to a DATETIME value, the comparison is done as two integers. The integer is not converted to a temporal value. To compare the operands as DATETIME values, use CAST() to explicitly convert the subquery value to DATETIME.
>
> 7. If one of the arguments is a decimal value, comparison depends on the other argument. The arguments are compared as decimal values if the other argument is a decimal or integer value, or as floating-point values if the other argument is a floating-point value.
>
> 8. In all other cases, the arguments are compared as floating-point (real) numbers. For example, a comparison of string and numeric operands takes places as a comparison of floating-point numbers.

#### 遇到的问题

1. long 型数据比较。
	
		# 转换为浮点数之后精度损失，转换结果都一样	
		SELECT '18446744073709551601' + 0E0 AS VALUE1,
		    	'18446744073709551602' + 0E0 AS VALUE2,
		    	'18446744073709551603' + 0E0 AS VALUE3,
		     	18446744073709551601 + 0E0 AS VALUE4