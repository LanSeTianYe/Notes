#### 制造数据

##### 创建表
    create table t_person (
    	id int identity(1,1),
    	name char(50),
    	age int,
    	address char(100),
    	email char(100),
    	sex char(2) default '男',
    	birthday date,
    	telphone char(50)
    	primary key(id)
    )
##### 从表中复制数据，这样有少量的数据可以快速的生成大量的数据


    insert into t_person(name,age,address,email,telphone) select name,age,name,name,name from user1
##### 常用的sql语句

1. `select COUNT(*) from t_person`
2. `select top 100 * from t_person order by id asc`
3. `update t_person set age = 17 where age > 100`

## SQL 优化
SQL Server 默认在主键 `Id` 上面创建了一个聚合索引，所以根据主键查询的速度比较快。
> `select * from t_person where name = 'aaa'` 有卡顿的感觉，等一会儿才出结果，时间不大于1s
> `select * from t_person where id = 100000 or id = '5'` 很流畅，点执行按钮之后立即出结果

|前置条件|执行的SQL语句|所用时间|结果(s)|说明|
|--|--|--|--|--|
||select count(*) from t_person|8|7172440|前几次查询所用时间比较长，后面查询需要的时间有时长有时短，有时2s有时4s|
||select count(*) from t_person where name like '%11'|19|67488||
||select * from t_person where name like '%11'|27||查询所有的字段，时间略长|
||select name from t_person where name like '%11'|22||只查询name字段时间缩短|
||select top 10000 * from t_person where name like '%11'|2||使用top，限制查询结果的条数，时间大幅缩短，当限制的条数比较少的时候，查询时间可以忽略|
|--|select * from t_person where name = 'aaa'|--|--|查出两条记录，有卡顿，时间小于1s|
|--|向数据库插入数据，速度很快|--|--|--|
|在name列创建非聚集索引|select count(*) from t_person where name like '%11'|17~20|67488|时间不稳定，在17~20s之间跳跃|
|在name列创建非聚集索引|select * from t_person where name like '%11'|45||时间相比之前增加，可能是由于查询的数据太多和非聚集索引的弊端导致的|
|在name列创建非聚集索引|select name from t_person where name like '%11'|19||只查询name字段时间缩短，效果比较明显|
|在name列创建非聚集索引|select top 10000 * from t_person where name like '%11'|6||时间相比之前增加，可能是由于查询的数据太多和非聚集索引的弊端导致的，即便是限制的条数比较少（10），查询也需要1s的时间|
|在name列创建非聚集索引|select * from t_person where name = 'aaa'|--|--|查出两条记录，无卡顿|
|在name列创建非聚集索引|select count(*) from t_person where name like '%11'|184|67488|时间增长|
|在name列添加聚合索引|select * from t_person where name like '%11'|63|--|时间增长|
|在name列添加聚合索引|select top 10000 * from t_person where name like '%11'|4|--|时间变短，当限制的条数比较少时，速度更快|
|在name列添加聚合索引|select name from t_person where name like '%11'|139||只查询name字段时间增长|

1. 当只需要部分结果时使用 `top` 限制返回结果的数量。
2. 当只需要部分字段的时候，限制返回结果的列数。
#### 创建视图

    create view count as SELECT * from [user] WHERE name LIKE '%11'
    select * from count



