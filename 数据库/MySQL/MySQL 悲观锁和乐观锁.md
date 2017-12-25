时间：2017/12/25 13:56:39  
 
参考： 

1.[深入理解乐观锁与悲观锁](http://www.hollischuang.com/archives/934)

环境：

1.  MySql 5.7.17

## 乐观锁悲观锁

#### 乐观锁和悲观锁简介

悲观锁（Pessimistic Concurrency Control）：认为每次对数据库的操作都会出现不同步的问题，因此每次更新数据的时候，都对要更新的数据进行加锁操作（其他事务对加锁数据的访问会阻塞），防止其他事务同时修改数据产生数据不同步问题。基于数据库的Inno DB引擎的行锁和表所实现。

乐观锁（Optimistic Lock）：认为每次对数据库进行操作不会出现不同步问题，此时要保证数据的完整性，需要用户自己通过一些技术手段控制，比如版本号（ES就是基于版本版本号进行数据一致性控制的）进行数据一致性控制。

#### 乐观锁和悲观锁简单实现  

乐观锁原理：

1. 通过版本号控制，给数据增加一个 `verson` 列，每次事务开始的时候，获取版本号，事务提交的时候比较事务开始时的版本号和提交时的版本号是否一样，不一样则重新处理，或者提示错误。

		SELECT id, version FROM person;
		//id和verson时上面获取的
		update person set age = 24 where id = 'id' and verson = 'version'
##### JPA 乐观锁

1. 实体增加version字段，并增加@Version注解。

		@Version
	    private int version;

##### 悲观锁

1. 关闭自动提交功能，更新数据的时候，增加 `for update`。

		SET AUTOCOMMIT=FALSE ;
		BEGIN;
		SELECT * FROM person FOR UPDATE;
		//先执行上面的一部分，然后再另外的客户端执行对 person 表的变更
		commit;

	 `SELECT * FROM person FOR UPDATE` 获取一个排他锁，在 `commit` 执行之前，其他客户端对 `pseron` 表数据的变更操作或获取锁的操作都会阻塞。
	
	其他客户端的操作：
	
		//1. 需要获取锁的查询语句
		SELECT* FROM person FOR UPDATE;
		//2. 需要变更数据的操作
		UPDATE person s SET s.age = 50 WHERE s.age = 10;

