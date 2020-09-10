时间：2019/5/30 14:57:45  

参考： 

1. 《高性能MySQL》第三版

## 查询优化   

核心：在完成查询任务的前提下搜索尽可能少的行。 

1. 只从数据库中查询需要的行，如：分页的时候只取指定分页的数据。
2. 通过优化合适的 `SQL` 使数据库在存储引擎中扫描数据的时候扫描尽量少的行。
3. 通过创建索引、分区函数等是的存储引擎扫描数据时，扫描的行尽量少。

### MySQL 中的关联查询   

MySQL 中的所有查询都可以看作 `join` 查询，单表查询类似于只有一层循环，MySQL会自动优化循环的次序，伪代码如下：

**查询：**

	select * from user left join atricle use(user_id) where user.user_id in (3,4)

**伪代码：**

	outer_iter = iterator over user where user_id in (3,4)
	outer_row = outer_iter.next
	while outer_row
		inner_iter = iterator over article where article.user_id = outer_row.user_id 
		inner_row = inner_iter.next
		if inner_row
			while inner_row
				output[outer_row, inner_row]
			 	inner_row = inner_iter.next
			end
		else
			output[outer_row, null]
		end
		outer_row = outer_iter.next 
	end

## 优化的几个方面   

### 表结构   

创建数据库以及表的时候考虑查询的效率：

1. 灵活使用范式和反范式，创建合适的表结构。
2. 使用合适的字段类型。
3. 需要大量计算的数据考虑使用 `缓存表` 和 `汇总表`。
	* 缓存分段时间的统计数据，当计算实时统计数据时，只需计算未缓存时间的统计数据，然后加上已经统计时段的统计数据。

### 索引    

MySQL 中最常用的索引是 `B-Tree索引`，其次还有 `Hash 索引`。其它的如 `（GEO）空间数据索引` `全文索引` 等不很常用，且有其他类型的数据存储系统如 `ElasticSearch` 对 `GEO` 和 `全文索引` 都有较好的支持。`MongoDB` 也支持 `GEO`。

1. 根据实际情况在最左前缀的原则下创建合适的索引。
2. 索引会影响数据插入或变更的性能，同时也会占用大量磁盘空间，所以索引不是越多越好。
3. 索引覆盖查询：只需查询索引不需要回表取数据的查询，对于InnoDB是 `索引字段 + 主键`， 对于 MyISAM 是 `索引字段`。
    

### 查询优化   

结合实际情况，使用最优的 `SQL` 语句，完成数据查询工作。

1. 只取实际需要的数据，不取多余的数据。
	* 减少数据可以提高存储引擎数据查询的速度，同时减少客户端和MySQL服务器之间通信的时间。
2. 扫描行数和实际返回函数的比值越低越好。
	* 可以通过建立合适的索引解决。
3. 多利用 `索引覆盖查询`。
4. 切分查询。
	* 耗时长的查询可以考虑拆分成多个查询，比如：批量操作。

### 数据分区  

1. 热点数据和旧数据分区，保持热点数据在一个分区中，减少查询需要扫描的行。 

### 应用层

1. 应用层缓存减少访问数据库的次数。


