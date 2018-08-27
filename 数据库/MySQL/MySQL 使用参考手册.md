## MySQL 使用参考手册 

### 数据库基本信息    

* 查看数据库版本 `select version()`
* 查看所有的数据库 `SHOW DATABASES`
* 查看当前使用的数据库 `SELECT DATABASE()`
* 查看当前库里面的表 `show tables`
* 查看SQL语句执行过程 `EXPLAIN SQL语句`
* 查看服务器连接线程的状态 `SHOW FULL PROCESSLIST`
	* `Sleep` 等待客户端发送请求。
	* `Query` 正在执行查询或者正在把查询结果发送给客户端。
	* `Locked` 正在等待表锁。
	* `Anlyzing and statistics` 正在收集存储引擎的统计信息。
	* `Copying to tmp table [on disk]` 正在执行查询并把查询结果复制临时表中。
	* `Sorting result` 正在对结果集进行排序。
	* `Sending data` 可能再多个状态之间传动数据，或者在生成结果集，或者在向客户端发送数据。
	
### 数据表操作相关语句

#### 表操作
* 查看表结构 `describe TABLE_NAME`
* 查看表状态 `SHOW TABLE status`
* 查看建表语句 `SHOW CREATE TABLE TABLE_NAME`
* 添加主键 `ALTER TABLE TABLE_NAME ADD PRIMARY KEY (COLUMN1,COLUMN2...)`
* 删除主键 `ALTER TABLE TABLE_NAME DROP PRIMARY KEY`
* 变更存储引擎 `alter table TABLE_NAME engine=innodb`
* 变更列属性(创建新表，效率低)
    
		# 执行时数据库内部会创建临时表
		ALTER TABLE person_temp MODIFY COLUMN name VARCHAR(30) NOT NULL DEFAULT '' COMMENT '姓名'
		# 执行时不创建临时表
		ALTER TABLE click_statistic ALTER COLUMN count SET DEFAULT 0
* 根据旧表创建新表 `CREATE TABLE NEW_TABLE_NAME LIKE OLD_TABLE_NAME`
* 复制旧表数据到新表 `INSERT INTO NEW_TABLE_NAME SELECT * FROM LOD_TABLE_NAME`
* 插入数据当主键存在时更新数据 

		INSERT INTO person (name, age) VALUES ('7', 7) ON DUPLICATE KEY UPDATE age = age + 1;

#### 查询数据
* 查询行数 `select count(*) from TABLE_NAME`
* 限制查询的行数 `SELECT * FROM TABLE_NAME ORDER BY emp_no LIMIT 30, 20`
* 关联查询：
	* 内连接：交集
	* 左连接/右链接：左表全部/右表全部     
* 连接查询结果：需要返回的列数一样
	* 去重复（去重可能一种影响性能）：
	
			select coulmn1, column2 ... from TABLE_NAME UNION select column1, column2 ... from TABLE_NAME
	* 保留重复：
		
			select coulmn1, column2 ... from TABLE_NAME UNION ALL select column1, column2 ... from TABLE_NAME

* 查看数据库重构的查询：
	1. 执行 `EXPLAIN EXTENDED SQL 语句`。
	2. 查看 `SHOW WARNINGS`。 
#### 索引

* 创建唯一索引 `CREATE UNIQUE INDEX INDEX_NAME ON TABLE_NAME(COLUMN1,COLUMN2...)`
* 创建普通索引 `ALTER TABLE TABLE_NAME add INDEX INDEX_NAME (COLUMN1,COLUMN2...)`
* 创建普通索引，指定索引前缀长度 `ALTER TABLE TABLE_NAME add INDEX INDEX_NAME (COLUMN1(length),COLUMN2...)`
* 修改索引，先删除再创建。
* 查看索引 `SHOW INDEX FROM TABLE_NAME`
* 删除索引 `DROP INDEX INDEX_NAME ON TABLE_NAME`
* 禁用索引：`ALTER TABLE click_statistic DISABLE KEYS`
* 启用索引：`ALTER TABLE click_statistic ENABLE KEYS`

### 存储引擎和事务  
* 查看事务自动提交开关 `SHOW VARIABLES LIKE 'autocommit'`
* 执行事务的步骤：
	* 开始事务 `START TRANSACTION`
	* 回滚事务 `ROLLBACK`
	* 提交事务 `COMMIT`
* 设置事务隔离级别 `set session transaction isolation level read committed`
	* read uncommitted
	* read committed
	* repeatable read
	* serializable

#### 数据库参数设置及维护

* 查看数据库变量配置 `show variables `
	* 编码 character
	* 端口 port
	* 查询 query
	* 存储引擎 storage
* 查询性能
	* 打开性能记录 `SET profiling = 'ON'`
	* 查看性能记录 `SHOW PROFILES`
	* 查看具体查询的性能记录 `SHOW PROFILE for query QUERY_ID;`

#### 数据库维护

* 表维护：
	* 查看表状态：`CHECK TABLE TABLE_NAME`
	* 修复表索引：
		* 常用办法：`REPAIR TABLE TABLE_NAME`
		* INNODB 引擎：`ALTER TABLE TABLE_NAME ENGINE = 'INNODB'`

#### 常用函数

* `left('str', length)`: 截取字符串的前 `length` 个字符。 

#### 经典示例

1. 用临时表记录页面点击次数，为了避免更新点击次数时行锁阻塞其它并发操作，在一个表里面使用多条记录来记录统计次数：

		# 创建数据表
		CREATE TABLE `click_statistic` (
		  `slot` tinyint(4) NOT NULL AUTO_INCREMENT COMMENT '主键',
		  `count` bigint(20) DEFAULT '0' COMMENT '点击次数',
		  PRIMARY KEY (`slot`),
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='点击数量统计表'
		# 更新语句
		INSERT INTO click_statistic (slot, count) VALUES (rand() * 100, 1) ON DUPLICATE KEY UPDATE count = count + 1;
		# 统计数量
		SELECT sum(count) FROM click_statistic
2. 长字段列，通过增加额外的hash值列，并在hash值列创建索引，提高查询效率。

		# 创建数据表
		CREATE TABLE `user_info` (
		  `user_id` int(11) NOT NULL AUTO_INCREMENT,
		  `profile_picture_url` varchar(200) NOT NULL DEFAULT '' COMMENT '头像URL',
		  `profile_picture_hash` int(10) unsigned DEFAULT '0' COMMENT '头像URL的hash值',
		  PRIMARY KEY (`user_id`),
		  KEY `index_profile_hash` (`profile_picture_hash`)
		) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4
		# 初始化数据
		INSERT INTO user_info (user_id, profile_picture_url, profile_picture_hash) VALUES (1, 'URL', crc32('URL'));
		INSERT INTO user_info (user_id, profile_picture_url, profile_picture_hash) VALUES (2, 'URL1', crc32('URL1'));
		INSERT INTO user_info (user_id, profile_picture_url, profile_picture_hash) VALUES (3, 'URL2', crc32('URL2'));
		# 查询
		SELECT *
		FROM user_info
		WHERE
		  profile_picture_hash = crc32('URL') AND
		  profile_picture_url = 'URL';
3. 删除大量数据分批完成。删除指定日期以前的数据，删除成功之后判断影响的行数，如果影响的行数不等于0则继续删除。

		DELETE FROM TABLE_NAME WHERE record_date < '2018-07-30 17:00:00' LIMIT 2000
4. count : `count(column1)` 统计对应列非空值的行数，`count(*)` 统计总行数。
		
	* 统计年龄等于8和年龄等于7的数量
	
			SELECT count(if(age = 8 , 1 ,NULL)) as a8 , count(if(age = 8 , 1 ,NULL)) as a FROM person_copy
	* 对于不精确的统计可以使用 Explain 代替。
	
			EXPLAIN SELECT count(*) FROM person_copy




