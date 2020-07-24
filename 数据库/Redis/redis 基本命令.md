## 对键类型的操作
* `keys  pattern ` 找到符合规则的键    

		redis 127.0.0.1:6379> keys task*
		1) "task002"
		2) "task001"
		3) "taskList"
		redis 127.0.0.1:6379>
* `exists task001` 判断键是否存在

		redis 127.0.0.1:6379> exists task001
		(integer) 1

* `del key` 删除键，可以同时删除多个
* `type key` 查看键的类型

		redis 127.0.0.1:6379> type task001
		hash

## 5种数据类型的常用操作

1. 字符串：Redis字符串是二进制安全的，这意味着他们有一个已知的长度没有任何特殊字符终止，所以你可以存储任何东西，最大容量512M。

		redis 127.0.0.1:6379> set name "sun"
		OK
		redis 127.0.0.1:6379> get name
		"sun"
2. 哈希：Redis的哈希是键值对的集合。 Redis的哈希值是字符串字段和字符串值之间的映射，因此它们被用来表示对象。

		redis 127.0.0.1:6379> hmset user name sun age 20
		OK
		redis 127.0.0.1:6379> hgetall user
		1) "name"
		2) "sun"
		3) "pasword"
		4) "1"
		5) "age"
		6) "20"

3. 列表：Redis的列表是简单的字符串列表，按插入顺序。可以添加元素到Redis的列表的头部或尾部，列表的最大长度为 2[32] - 1 元素（4294967295，每个列表中可容纳超过4十亿的元素）。（必须有list）。

		redis 127.0.0.1:6379> lpush numberlist 1
		(integer) 1
		redis 127.0.0.1:6379> lpush numberlist 2
		(integer) 2
		redis 127.0.0.1:6379> rpush numberlist 3
		(integer) 3
		redis 127.0.0.1:6379> lpush numberlist 3
		(integer) 4
		redis 127.0.0.1:6379> lrange numberlist 0 10
		1) "3"
		2) "2"
		3) "1"
		4) "3"
		redis 127.0.0.1:6379>

4. 集合:Redis的集合是字符串的无序集合。在Redis中你可以添加，删除和测试值是否存在，这些操作只需要 O（1）的时间复杂度。

		redis 127.0.0.1:6379> sadd namelist sun
		(integer) 1
		redis 127.0.0.1:6379> sadd namelist sun1
		(integer) 1
		redis 127.0.0.1:6379> sadd namelist sun2
		(integer) 1
		redis 127.0.0.1:6379> sadd namelist sun2
		(integer) 0
		redis 127.0.0.1:6379> smembers namelist
		1) "sun2"
		2) "sun1"
		3) "sun"
		redis 127.0.0.1:6379>
5. 有序集合：Redis的有序集合类似于Redis的集合，字符串不重复的集合。不同的是，一个有序集合的每个成员都有一个对应的分数，以便采取有序set命令，从最小的到最大的成员分数有关。虽然成员具有唯一性，但分数可能会重复。（分数相当于优先级）

		redis 127.0.0.1:6379> zadd name1list 0 sun1
		(integer) 1
		redis 127.0.0.1:6379> zadd name1list 0 sun2
		(integer) 1
		redis 127.0.0.1:6379> zadd name1list 3 sun3
		(integer) 1
		redis 127.0.0.1:6379> zadd name1list 2 sun4
		(integer) 1
		redis 127.0.0.1:6379> zadd name1list 2 sun4
		(integer) 0
		redis 127.0.0.1:6379> zRangeByScore name1list 0 5
		1) "sun1"
		2) "sun2"
		3) "sun4"
		4) "sun3"
		redis 127.0.0.1:6379> zRangeByScore name1list 0 2
		1) "sun1"
		2) "sun2"
		3) "sun4"
		redis 127.0.0.1:6379>

## redis中的一些基础命令
### 1、字符串操作
	redis 127.0.0.1:6379> set name "sun"
	OK
	redis 127.0.0.1:6379> get name
	"sun"
* `select 0~15`   切换数据库,默认有16个数据库  

* `keys pattern`  获取符合正则表达式的规则列表  

		? 匹配一个字符  
		* 匹配人一个字符  
		a[c-e] ac ad 或ae  
		\x 匹配字符x，用于转义符号。如要匹配 ? 则需要使用\?
		
		redis 127.0.0.1:6379[1]> set name sun
		OK
		redis 127.0.0.1:6379[1]> set nam sun
		OK
		redis 127.0.0.1:6379[1]> keys nam*
		1) "name"
		2) "nam"
		redis 127.0.0.1:6379[1]>

* `exists key` 判断一个键是否存在  

		redis 127.0.0.1:6379> exists name
		(integer) 1
		redis 127.0.0.1:6379> exists names
		(integer) 0
		redis 127.0.0.1:6379>

* `del key[key...]` 删除键
		
		redis 127.0.0.1:6379> del name nam
		(integer) 2

* `type key`  获取键对应的值得类型

		redis 127.0.0.1:6379[1]> type name
		string

* `incr key` 递增数字,当字符串中存储的是数字的时候可以递增，键不存在的时候默认键为零。

		redis 127.0.0.1:6379[1]> set number 1
		OK
		redis 127.0.0.1:6379[1]> incr number
		(integer) 2
		redis 127.0.0.1:6379[1]> get number
		"2"
		redis 127.0.0.1:6379[1]>
* `incrby key number`增加指定的数字  

		redis 127.0.0.1:6379[1]> get number
		"2"
		redis 127.0.0.1:6379[1]> incrby number 10
		(integer) 12
		redis 127.0.0.1:6379[1]> 

* `decr key`  `decrby key number` 递减/减少指定的值
		
		redis 127.0.0.1:6379[1]> incrby number 10
		(integer) 12
		redis 127.0.0.1:6379[1]> decr number
		(integer) 11
		redis 127.0.0.1:6379[1]> decrby number 3
		(integer) 8
		redis 127.0.0.1:6379[1]> 

* `incrbyfloat` 增加指定的浮点数

		redis 127.0.0.1:6379> get num
		"1"
		redis 127.0.0.1:6379> incrbyfloat num 2.222
		"3.222"
		redis 127.0.0.1:6379>
* `append key str`项尾部追加
		
		redis 127.0.0.1:6379> get num
		"3.222"
		redis 127.0.0.1:6379> append num 5
		(integer) 6
		redis 127.0.0.1:6379> get num
		"3.2225"
		redis 127.0.0.1:6379>

* `strlen` 获取字符串的长度

		redis 127.0.0.1:6379> strlen num
		(integer) 6
* `mset key1 1 key2 2 key3 3`同时设置多个值

		redis 127.0.0.1:6379[1]> mset key1 1 key2 2 key3 3
		OK
		redis 127.0.0.1:6379[1]> keys key?
		1) "key2"
		2) "key3"
		3) "key1"
		redis 127.0.0.1:6379[1]>
* `位操作...`

### 2、散列表的一些操作  

	redis 127.0.0.1:6379> hmset user name sun age 20
	OK
	redis 127.0.0.1:6379> hgetall user
	1) "name"
	2) "sun"
	3) "pasword"
	4) "1"
	5) "age"
	6) "20"
	redis 127.0.0.1:6379[1]> hgetall car:1
	1) "name"
	2) "BMW"
	3) "color"
	4) "black"
	5) "price"
	6) "10"
	redis 127.0.0.1:6379[1]>

* `hexists key filed` 判断对应key的字段是否存在

		redis 127.0.0.1:6379[1]> hexists car:1 name
		(integer) 1
* `hsetnx key field value` 当字段不存在的时候赋值
	
		redis 127.0.0.1:6379[1]> hsetnx car:1 name ss
		(integer) 0
		redis 127.0.0.1:6379[1]> hsetnx car:1 whight 20t
		(integer) 1
* `hincrby key filed num` 增加字段的值
		
		redis 127.0.0.1:6379[1]> hincrby car:1 price 10
		(integer) 20

* `hdel key field[field...]` 删除字段，可以同时删除多个

		redis 127.0.0.1:6379[1]> hdel car:1 whight
		(integer) 1
* `hkeys key` 获取字段名

		redis 127.0.0.1:6379[1]> hkeys car:1
		1) "name"
		2) "color"
		3) "price"

* `hvals key` 获取字段值

		redis 127.0.0.1:6379[1]> hvals car:1
		1) "BMW"
		2) "black"
		3) "20"
		redis 127.0.0.1:6379[1]>
* `hlen key` 获取字段的数量

		redis 127.0.0.1:6379[1]> hlen car:1
		(integer) 3

### 3、列表的操作
* `lpush` `rpush` 向列表的两端添加元素

		redis 127.0.0.1:6379[1]> lpush numbers 1
		(integer) 1
		redis 127.0.0.1:6379[1]> lpush numbers 2
		(integer) 2
		redis 127.0.0.1:6379[1]> rpush numbers 2
		(integer) 3

* `lpop` `rpop` 从列表的两端弹出元素，弹出的同时会删除对应的元素

		redis 127.0.0.1:6379[1]> lrange numbers 0 10
		1) "2"
		2) "1"
		3) "2"
		redis 127.0.0.1:6379[1]> lpop numbers
		"2"
		redis 127.0.0.1:6379[1]> rpop numbers
		"2"
		redis 127.0.0.1:6379[1]> lrange numbers 0 10
		1) "1"
		redis 127.0.0.1:6379[1]>

* `llen key` 获取列表元素的个数

		redis 127.0.0.1:6379[1]> llen numbers
		(integer) 1

* `lrange key start end` 获取列表的片段（包含最右边的元素[0，10]），`end` 为-1表示最右边第一个元素，-2表示最右边第二个元素，以此类推
* 
		redis 127.0.0.1:6379[1]> lrange numbers 0 10
		1) "2"
		2) "1"
		3) "2"

* `lrem key count value` 删除列表中的值，会删除列表前count个value.
* 注：
	* count > 0 从左侧开始删除对应的 `value`
	* count < 0 从右侧开始删除对应的 `value`
	* count = 0 删除所有的 `value`

			redis 127.0.0.1:6379[1]> lrange numbers 0 10
			1) "2"
			2) "2"
			3) "2"
			4) "1"
			redis 127.0.0.1:6379[1]> lrem numbers 2 2
			(integer) 2
			redis 127.0.0.1:6379[1]> lrange numbers 0 10
			1) "2"
			2) "1"
			redis 127.0.0.1:6379[1]>

* `lindex key index` `lset key index value` 获取和设置对应索引的值（索引从零开始）。

		redis 127.0.0.1:6379[1]> lset numbers 0 3
		OK
		redis 127.0.0.1:6379[1]> lindex numbers 0
		"3"
		redis 127.0.0.1:6379[1]>

* `ltrim key start end` 删除指定范围外的所有元素(start和end不会被删除)

		redis 127.0.0.1:6379[1]> lrange numbers 0 10
		 1) "3456789"
		 2) "3456789"
		 3) "345678"
		 4) "34567"
		 5) "3456"
		 6) "345"
		 7) "34"
		 8) "3"
		 9) "3"
		10) "1"
		redis 127.0.0.1:6379[1]> ltrim numbers 0 1
		OK
		redis 127.0.0.1:6379[1]> lrange numbers 0 10
		1) "3456789"
		2) "3456789"
		redis 127.0.0.1:6379[1]>

* `linsert key before|after value insertvalue`  向列表中指定值得前面或者后面插入

		redis 127.0.0.1:6379[1]> lrange numbers 0 10
		1) "5"
		2) "3456789"
		3) "3456789"
		redis 127.0.0.1:6379[1]> linsert numbers before 5 1
		(integer) 4
		redis 127.0.0.1:6379[1]> linsert numbers after 5 10
		(integer) 5
		redis 127.0.0.1:6379[1]> lrange numbers 0 10
		1) "1"
		2) "5"
		3) "10"
		4) "3456789"
		5) "3456789"
		redis 127.0.0.1:6379[1]>

* `rpoplpush source target` 将列表元素从一个列表移动到另外一个列表

		redis 127.0.0.1:6379[1]> lrange numbers 0 10
		1) "1"
		2) "5"
		3) "10"
		4) "3456789"
		5) "3456789"
		redis 127.0.0.1:6379[1]> rpoplpush numbers nums
		"3456789"
		redis 127.0.0.1:6379[1]> lrange numbers 0 10
		1) "1"
		2) "5"
		3) "10"
		4) "3456789"
		redis 127.0.0.1:6379[1]>

### 4、集合操作
* `sadd key [value...]` `srem key [value..]` 增加或者删除元素

		redis 127.0.0.1:6379[1]> sadd sets a b
		(integer) 2
		redis 127.0.0.1:6379[1]> srem sets a
		(integer) 1
		redis 127.0.0.1:6379[1]> smembers sets
		1) "b"
		redis 127.0.0.1:6379[1]>

* `smembers key`  获得集合的所有元素

		redis 127.0.0.1:6379[1]> smembers sets
		1) "b"

* `sismember key value`判断集合元素是否存在

		redis 127.0.0.1:6379[1]> sismember sets a
		(integer) 0
		redis 127.0.0.1:6379[1]> sismember sets b
		(integer) 1
		redis 127.0.0.1:6379[1]>

* `sdiff set1 set2 ...` 集合的差(set1-set2-set3...)

		redis 127.0.0.1:6379[1]> sadd setA a b c
		(integer) 3
		redis 127.0.0.1:6379[1]> sadd setB b c d
		(integer) 3
		redis 127.0.0.1:6379[1]> sadd setC c d e
		(integer) 3
		redis 127.0.0.1:6379[1]> sdiff setA setB
		1) "a"
* `sinter set1 set2 set3 ...` 集合的交际

		redis 127.0.0.1:6379[1]> sinter setA setB setC
		1) "c"
		redis 127.0.0.1:6379[1]>

* `sunion set1 set2 set3 ...` 集合的并集运算

		redis 127.0.0.1:6379[1]> sunion setA setB setC
		1) "d"
		2) "a"
		3) "b"
		4) "e"
		5) "c"
		redis 127.0.0.1:6379[1]>

* `scard keys` 获取集合元素的个数

		redis 127.0.0.1:6379[1]> scard setA
		(integer) 3

* `sdiffstore storeSet set1 set2 ...`  运算并储存
* `sinterstore storeSet set1 set2 ...` 运算并储存
* `sunionstore storeSet set1 set2 ...` 运算并储存

		redis 127.0.0.1:6379[1]> sunionstore ABC setA setB setC
		(integer) 5
		redis 127.0.0.1:6379[1]> smembers ABC
		1) "d"
		2) "a"
		3) "b"
		4) "e"
		5) "c"
		redis 127.0.0.1:6379[1]>

* `srandmember key [count]` 随机获取集合中的元素
* 注：
	* count > 0 获取count个不同的元素，count大于集合元素的个数的时候获取所有。
	* count < 0 获取|count|个元素，可能重复

			redis 127.0.0.1:6379[1]> srandmember ABC 3
			1) "e"
			2) "d"
			3) "c"
			redis 127.0.0.1:6379[1]> srandmember ABC 3
			1) "b"
			2) "e"
			3) "a"
			redis 127.0.0.1:6379[1]> srandmember ABC -2
			1) "c"
			2) "c"
			redis 127.0.0.1:6379[1]>

* `spop` 从集合中弹出一个元素，随机弹出

		redis 127.0.0.1:6379[1]> spop ABC
		"b"

### 5、有序集合
* `zadd  key score1 member1 score2 member2 ...` 添加元素

		redis 127.0.0.1:6379[1]> zadd listSet 1 a 2 b
		(integer) 2

* `zadd key score member` 改变元素的分数

		redis 127.0.0.1:6379[1]> zadd listSet 3 a
		(integer) 0

* `zscore key member` 获取对应元素的分数

		redis 127.0.0.1:6379[1]> zscore listSet a
		"3"
		redis 127.0.0.1:6379[1]> zscore listSet b
		"2"
* `zadd listSet inf|-inf member` 分数设置为正无穷或者负无穷

		redis 127.0.0.1:6379[1]> zadd listSet inf a
		(integer) 0

* `zrange key start stop [withscores]`获取索引从start到end的元素，索引不代表分数，分数只能确定元素顺序，索引从零开始，集合按分数由小到大排序（负数代表从最后开始查找，-1代表最后一个元素）,withscores显示分数

		redis 127.0.0.1:6379[1]> zrange listSet 0 -1 withscores
		1) "b"
		2) "2"
		3) "a"
		4) "inf"

* `zrangebyscore key startscore endscore` 获取指定分数范围内的元素 `(` 表示不包含端点。

		redis 127.0.0.1:6379[1]> zrangebyscore listSet 1 10
		1) "b"
		redis 127.0.0.1:6379[1]> zrangebyscore listSet 1 inf
		1) "b"
		2) "a"
		redis 127.0.0.1:6379[1]>
* `zrangebyscore listSet (3 inf limit 1 3` 获取分数大于三的，从第二个元素开始后的三个元素

		redis 127.0.0.1:6379[1]> zadd listSet 1 a 2 b 3 c 4 d 5 e 6 f 7 g
		(integer) 5
		redis 127.0.0.1:6379[1]> zrange listSet 0 -1
		1) "a"
		2) "b"
		3) "c"
		4) "d"
		5) "e"
		6) "f"
		7) "g"
		redis 127.0.0.1:6379[1]> zrangebyscore listSet (3 inf limit 1 3
		1) "e"
		2) "f"
		3) "g"
		redis 127.0.0.1:6379[1]>

* `zrevrangebyscore listSet (3 inf limit 1 3` 获取分数小于最大值的，从第二个元素开始（包含第二个）的三个元素

		redis 127.0.0.1:6379[1]> zrevrangebyscore listSet inf 0 limit 1 3
		1) "f"
		2) "e"
		3) "d"
		redis 127.0.0.1:6379[1]>

* `zincrby key addscore member` 增加某个元素的分数

		redis 127.0.0.1:6379[1]> zincrby listSet 10 a
		"11"

* `zcard key` 获取元素的数量

		redis 127.0.0.1:6379[1]> zcard listSet
		(integer) 7

* `zcount key start end` 获取指定分数范围内的元素个数

		redis 127.0.0.1:6379[1]> zcount listSet   2 5
		(integer) 4
		redis 127.0.0.1:6379[1]> zcount listSet   (2 (5
		(integer) 2
		redis 127.0.0.1:6379[1]>

* `zrem key members [members...]` 删除一个或多个元素

		redis 127.0.0.1:6379[1]> zrem listSet a b c
		(integer) 3

* `zremrangebyscore key start end` 删除指定分数范围的元素

		redis 127.0.0.1:6379[1]> zremrangebyscore listSet 3 (5
		(integer) 1

* `zrank key member` 获取元素排名（顺序）

		redis 127.0.0.1:6379[1]> zrank listSet f
		(integer) 1
		redis 127.0.0.1:6379[1]> zrank listSet e
		(integer) 0
* `zrevrank key member` 获取倒数排名

		redis 127.0.0.1:6379[1]> zrevrank listSet e
		(integer) 2