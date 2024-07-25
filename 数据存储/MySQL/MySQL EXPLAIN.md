时间：2018/8/21 14:56:59   

参考：

1 《高性能MySQL第三版》

## EXPLAIN 详解

分析SQL执行计划信息，SQL可能会怎么执行，并不准确。  

* EXPLAIN EXTENDED 结合 `SHOW WARNINGS` 可以查看服务器优化过的实际执行的SQL。
* EXPLAIN PARTITIONS 会显示查询将访问的分区。 

### 返回结果字段含义
* id:标识列（有几个Select语句）
* select_type: 查询类型
	* SIMPLE：不包含任何子查询和UNION语句。
	* PRIMARY：包含子查询或UNION语句时，外层查询的类型。
		* SUBQUERY： 包含在 Select 列表里面的子查询。
			
				SELECT p1.age, (SELECT 1 FROM person LIMIT 1) FROM person p1
		* DERIVED：包含在Form子的子查询的SELECT。
			
				SELECT * FROM (SELECT * FROM person) as p
		* UNION：在UNION中的第二个以及以后的SELECT
		* UNION RESULT：从UINON的匿名临时表检测数据的SELECT语句
* table: 查询访问的数据表。
	* 正常情况，查询的数据表。
	* UNION 语句，显示联合的表。
* type: 访问类型（由上向下效率依次提高）
	* ALL：全表扫描
	* index：索引扫描全表。当 `Extra` 出现 `use index` 时，说明正在使用覆盖索引，效率相对高一点。
	* range：索引范围扫描。
	* ref：索引访问，返回匹配单个值的所有行。

			SELECT * FROM person WHERE age = 3;
	* eq_ref: 最多只返回一条记录，唯一索引。
	* const 和 system: 对查询的部分进行优化并转换为常量。
			
			SELECT id FROM person WHERE id = 1 
	* NULL：在性能优化阶段分解查询语句，在查询阶段甚至不用再访问表或索引。
			
			SELECT min(age) FROM person_copy

* possible_keys: 可以使用哪些索引来提升查询性能。
* key: 实际使用的key，最小化查询成本的Key（覆盖索引）
* key_len: 使用索引的字节数。
* ref: 在 `key` 列显示的索引中查找值使用的列或常量。
* rows: 估算指定查询执行需要扫描的行数。
* filtered：符合某个条件的记录数所占的百分比， 和row相乘得出实际符合条件的行数。
* Extra: 额外信息
	* `Using Index` 使用覆盖索引，不需要访问数据表。
	* `Using index condition` 使用索引条件过滤。
	* `Using where` 存储引擎检索后再进行数据过滤。
	* `Using temporary` 对查询结果排序的时候使用临时表。
	* `Using filesort` 使用外部文件排序
	* `Range checked for each record(index map:N)`  没有好用的索引。
