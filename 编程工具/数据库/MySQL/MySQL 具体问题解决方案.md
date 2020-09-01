### 参考文章
[MySQL索引原理及慢查询优化](http://tech.meituan.com/mysql-index.html)

### 数据引擎

#### 简介：
1. `MyISAM` 是MySQL的默认存储引擎，基于传统的ISAM类型，支持全文搜索，但不是事务安全的，而且不支持外键。每张MyISAM表存放在三个文件中：frm 文件存放表格定义；数据文件是MYD (MYData)；索引文件是MYI (MYIndex)。 
2. `InnoDB` 是事务型引擎，支持回滚、崩溃恢复能力、多版本并发控制、ACID事务，支持行级锁定（InnoDB表的行锁不是绝对的，如果在执行一个SQL语句时MySQL不能确定要扫描的范围，InnoDB表同样会锁全表，如like操作时的SQL语句），以及提供与Oracle类型一致的不加锁读取方式。InnoDB存储它的表和索引在一个表空间中，表空间可以包含数个文件。

#### 区别：

1. MyISAM是非事务安全型的，而InnoDB是事务安全型的。

2. MyISAM锁的粒度是表级，而InnoDB支持行级锁定。

3. MyISAM支持全文类型索引，而InnoDB不支持全文索引。

4. MyISAM相对简单，所以在效率上要优于InnoDB，小型应用可以考虑使用MyISAM。

5. MyISAM表是保存成文件的形式，在跨平台的数据转移中使用MyISAM存储会省去不少的麻烦。

6. InnoDB表比MyISAM表更安全，可以在保证数据不会丢失的情况下，切换非事务表到事务表（alter table tablename type=innodb）。


### 查询优化

#### select count(*) from table 的优化
 
方案一 ： 数据库主键自增，而且不删除数据的前提下。这里假设主键是连续的:

    SELECT max(uid)-min(uid)+1 from alarminfo

方案二 ： 创建触发器，用一个单独的表存储表的总行数
    
    -- 建立一个表来存储总行数
    create table row_count_table(
    	alarminfo_rows int,
    )
    -- 初始化记录
    INSERT INTO row_count_table SELECT count(*) from alarminfo
    -- 创建触发器,增加记录的时候总条数加一
    CREATE TRIGGER alarminfo_row_add_tri AFTER INSERT ON alarminfo FOR EACH ROW
    BEGIN
    	update row_count_table set alarminfo_rows = 1 + alarminfo_rows;
    END;
    -- 创建触发器，删除记录的时候总条数减一
    CREATE TRIGGER alarminfo_row_minus_tri AFTER DELETE ON alarminfo FOR EACH ROW
    BEGIN
    	update row_count_table set alarminfo_rows = alarminfo_rows - 1;
    END;
    -- 查看最后的总记录
    select alarminfo_rows from row_count_table;

#### 有一个查询条件的查询
在要查询字段上创建索引，这样查询的条数就会变少，如下：
    
    -- 查询4950509行耗时5.492s,共96记录
    select count(*) from alarminfo WHERE  num = '3253'
    -- 创建索引之后，扫描96行，耗时0.002s
    -- 删除索引 DROP INDEX index_num on alarminfo
    ALTER TABLE alarminfo ADD INDEX index_num (num)
    select count(*) from alarminfo WHERE  num = '3253'

#### 分页查询,根据Id进行排序
方案一 : 假设记录了上次查询的最大 `uid`,适用于通过下一页翻页的情况，不适用于跳页的情况。

    SELECT uid from alarminfo where uid > lastMaxUid order by uid asc LIMIT 20
往下翻 第n页：

    SELECT uid from alarminfo where uid > lastMaxUid order by uid asc LIMIT (n-1)20,20
往上翻n页：

    SELECT uid from alarminfo where uid < lastMinUid order by uid dasc LIMIT (n-1)20,20

方案二：使用索引，找出最小的uid，uid是自增主键，int类型，在uid上面创建了一个聚集索引，数据库有5020255条数据，查询的时候使用的是主键。

    EXPLAIN SELECT uid from alarminfo order by uid asc LIMIT 4000000,20
上面的语句查询了4000020行。耗时12.208s

    EXPLAIN SELECT uid from alarminfo where uid > 0 order by uid asc LIMIT 4000000,20
上面的语句查询了2475254条记录，使用的书聚集索引，耗时: 0.920s

### 多条件查询
条件过滤，哪个条件过滤出来的内容越少，把哪个条件放在前面，并根据 `最左前缀匹配原则` 建立对应的索引。这里只在num上创建了索引。

	select
		*
	from
		 alarminfo 
	where
		 num = '3253'
		 and priority = 4
		 and location != 'F3_服务电梯厅烟感37_084'
		 and time < '2016-07-28 12:24:06'
		 and time > '2014-07-28 12:24:06'
	ORDER BY num
	limit 10 ,10

由于在num上面创建了一个索引，搜索出来的 `num='3253'` 记录只有96条，然后对96条记录再进行进一步的过滤，结果耗时只有 0.006s。
### 另外一个例子


    	SELECT * from alarminfo 
    		WHERE num = '0' 
    					and location = 'F21_行政酒廊' 
    					and priority in(
    													select priority from alarminfo 
    															WHERE 
    																			time > '2015-06-28 12:24:06'
    																	AND time < '2015-08-28 12:24:06'
    													)
上面的Sql语句查询很耗时间，根据查询需要的含义可以替换为下面的语句

    SELECT SQL_NO_CACHE  * from alarminfo 
		WHERE num = '4' 
					and location = 'F21_行政酒廊' 
					and time > '2015-06-28 12:24:06'
					and time < '2015-08-28 12:24:06'
		ORDER BY time asc
在num列有索引的情况下： 扫描36688行，耗时2.434s
创建联合索引:

    CREATE INDEX index_num_location_time on alarminfo(num,location,time)

创建num和location和time上联合索引之后，扫描199行，耗时0.005s



### 建索引的几大原则:  
注: 索引一旦创建之后，索引字段的顺序就确定了，在Sql语句中， **=和in可以乱序** ，比如`b = 2 and c = 3 and a = 1` 等价于 `a = 1 and b = 2 and c = 3`，建立(a,b,c)索引就可以，一定要确定的一点是索引的顺序一旦建立之后就不会改变，不同的Sql只是MySql在查询的时候会调整Sql的顺序。另外指定的索引遇到范围查询(>、<、between、like)就停止后面的索引，这和BTree的查询结构有关。假设这个语句 `a = 1 and b = 2 and c > 3 and d = 4` 我们要向建立对四个字段都通用的索引，就需要先自己调整一下Sql的结构，使索引不会中断（范围查询中断）。 `a = 1 and b = 2 and d = 4 and c > 3 ` 的顺序就是一个可行的方案（abd的顺序可以任意调整）。

1. 最左前缀匹配原则，非常重要的原则，mysql会一直向右匹配直到遇到范围查询(>、<、between、like)就停止匹配，比如a = 1 and b = 2 and c > 3 and d = 4 如果建立(a,b,c,d)顺序的索引，d是用不到索引的，如果建立(a,b,d,c)的索引则都可以用到，a,b,d的顺序可以任意调整。
2. =和in可以乱序，比如a = 1 and b = 2 and c = 3 建立(a,b,c)索引可以任意顺序，mysql的查询优化器会帮你优化成索引可以识别的形式
3. 尽量选择区分度高的列作为索引,区分度的公式是count(distinct col)/count(*)，表示字段不重复的比例，比例越大我们扫描的记录数越少，唯一键的区分度是1，而一些状态、性别字段可能在大数据面前区分度就是0，那可能有人会问，这个比例有什么经验值吗？使用场景不同，这个值也很难确定，一般需要join的字段我们都要求是0.1以上，即平均1条扫描10条记录
4. 索引列不能参与计算，保持列“干净”，比如from_unixtime(create_time) = ’2014-05-29’就不能使用到索引，原因很简单，b+树中存的都是数据表中的字段值，但进行检索时，需要把所有元素都应用函数才能比较，显然成本太大。所以语句应该写成create_time = unix_timestamp(’2014-05-29’);
5. 尽量的扩展索引，不要新建索引。比如表中已经有a的索引，现在要加(a,b)的索引，那么只需要修改原来的索引即可

### 慢查询优化基本步骤:  

0. 先运行看看是否真的很慢，注意设置SQL_NO_CACHE
1. where条件单表查，锁定最小返回记录表。这句话的意思是把查询语句的where都应用到表中返回的记录数最小的表开始查起，单表每个字段分别查询，看哪个字段的区分度最高
2. explain查看执行计划，是否与1预期一致（从锁定记录较少的表开始查询）
3. order by limit 形式的sql语句让排序的表优先查
4. 了解业务方使用场景
5. 加索引时参照建索引的几大原则
6. 观察结果，不符合预期继续从0分析

### explain 中 `key_len` 的计算方法:

|列类型	|key_len|	备注|
|-----|-----|-----|
|id int	|key_len = 4+1 = 5	|允许NULL，加1byte|
|id int not null|	key_len = 4	|不允许NULL|
|user char(30) utf8|	key_len = 30*3+1|	允许NULL|
|user varchar(30) not null utf8	|key_len = 30*3+2	|动态列类型，加2bytes|
|user varchar(30) utf8|	key_len = 30*3+2+1	|动态列类型，加2bytes；允许NULL，再加1byte|
|detail text(10) utf8|	key_len = 30*3+2+1|	TEXT列截取部分，被视为动态列类型，加2bytes；且允许NULL|