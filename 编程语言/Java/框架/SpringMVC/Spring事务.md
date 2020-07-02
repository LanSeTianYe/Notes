## 说明
时间：2017/5/4 22:04:07   
参考：

* [深入理解 Spring 事务原理](http://www.codeceo.com/article/spring-transactions.html)
* [MySQL事务提交过程（一）](http://www.cnblogs.com/exceptioneye/p/5451960.html)

## 原理 
Spring事务基于数据库事务。JDBC开启事务代码如下:

1. 获取连接 Connection connect = DriverManager.getConnection()
2. 开启事务 connect.setAutoCommit(true/false);
3. 执行数据库操作（增删改查）。
4. 提交事务 connect.commit() ，出现异常回滚事务 connect.rollback();
5. 关闭连接 connect.close();

## 数据库事务
### MySql事务
事务需要满足四个条件：  

 1. 原子性（Atomicity）
 2. 一致性（Consistency）
 3. 隔离性（Isolation）
 4. 持久性（Durability）

MySQL 本身不提供事务支持，而是开放了存储引擎接口，由具体的存储引擎来实现，具体来说支持 MySQL 事务的存储引擎就是 InnoDB。存储引擎实现事务的通用方式是基于 redo log 和 undo log。

 * redo log 记录事务修改后的数据
 * undo log 记录事务前的原始数据。  

所以当一个事务执行时实际发生过程简化描述如下：  

 1. 先记录 undo/redo log，确保日志刷到磁盘上持久存储。
 2. 更新数据记录，缓存操作并异步刷盘。
 3. 提交事务，在 redo log 中写入 commit 记录。

在 MySQL 执行事务过程中如果因故障中断，可以通过 redo log 来重做事务或通过 undo log 来回滚，确保了数据的一致性。这些都是由事务性存储引擎来完成的。  
MySQL 为了提供主从复制功能引入了一个新的日志文件叫 binlog，它包含了引发数据变更的事件日志集合。从库请求主库发送 binlog到从库， 并通过日志事件还原数据写入从库，所以从库的数据来源为 binlog。这样 MySQL 主库只需做到 binlog 与本地数据一致就可以保证主从库数据一致。但 binlog 不在事务存储引擎范围内，而是由 MySQL Server 来记录的。那么就必须保证 binlog 数据和 redo log 之间的一致性，所以开启了 binlog 后实际的事务执行就多了一步，如下：

 1. 先记录 undo/redo log，确保日志刷到磁盘上持久存储。
 2. 更新数据记录，缓存操作并异步刷盘。
 3. 将事务日志持久化到 binlog。
 4. 提交事务，在 redo log 中写入 commit 记录。

这样的话，只要 binlog 没写成功，整个事务是需要回滚的，而 binlog 写成功后即使 MySQL 崩溃了都可以恢复事务并完成提交。要做到这点，就需要把 binlog 和事务关联起来，而只有保证了 binlog 和事务数据的一致性，才能保证主从数据的一致性。所以 binlog 的写入过程不得不嵌入到纯粹的事务存储引擎执行过程中，并以内部分布式事务（xa 事务）的方式完成两阶段提交。

查看数据库信息：

	-- 数据库版本
	SELECT VERSION();
	-- 数据库引擎
	SHOW ENGINES;
	-- 查看日志信息
	SHOW VARIABLES LIKE 'log_%';

**事务测试** 

	-- 开启事务（关闭自动提交）
	set autocommit=0;
	-- 插入数据
	INSERT INTO employee values(1, 'name1', 20, 2);
	-- commit之前，在另外一个事务（窗口）执行结果为0，在当前窗口执行结果为1
	SELECT count(id) FROM employee;
	-- 提交事务
	commit;
    -- commit之后，在另外一个事务（窗口）执行结果为1，在当前窗口执行结果为1
	SELECT count(id) FROM employee;
## Spring事务传播属性
 * PROPAGATION_REQUIRED（默认） ：支持当前事务，如果当前没有事务，就新建一个事务。这是最常见的选择。
 * PROPAGATION_REQUIRES_NEW：新建事务，如果当前存在事务，把当前事务挂起。新建的事务将和被挂起的事务没有任何关系，是两个独立的事务，外层事务失败回滚之后，不能回滚内层事务执行的结果，内层事务失败抛出异常，外层事务捕获，也可以不处理回滚操作。
 * PROPAGATION_SUPPORTS：支持当前事务，如果当前没有事务，就以非事务方式执行。
 * PROPAGATION_MANDATORY：支持当前事务，如果当前没有事务，就抛出异常。
 * PROPAGATION_NOT_SUPPORTED：以非事务方式执行操作，如果当前存在事务，就把当前事务挂起。
 * PROPAGATION_NEVER：以非事务方式执行，如果当前存在事务，则抛出异常。
 * PROPAGATION_NESTED：如果一个活动的事务存在，则运行在一个嵌套的事务中。如果没有活动事务，则按REQUIRED属性执行。它使用了一个单独的事务，这个事务拥有多个可以回滚的保存点。内部事务的回滚不会对外部事务造成影响。它只对DataSourceTransactionManager事务管理器起效。

## 数据库隔离级别
 * Read-Uncommitted（0）：导致脏读。
 * Read-Committed（1）：避免脏读，允许不可重复读和幻读。
 * Repeatable-Read（2）：避免脏读和不可重复读，允许幻读。
 * Serializable（3）：串行化读，事务只能一个一个执行，避免了脏读、不可重复读、幻读。执行效率慢，使用时慎重。

	名词解释
	
	 * 脏读：一事务对数据进行了增删改，但未提交，另一事务可以读取到未提交的数据。如果第一个事务这时候回滚了，那么第二个事务就读到了脏数据。
	 * 不可重复读：一个事务中发生了两次读操作，第一次读操作和第二次操作之间，另外一个事务对数据进行了修改，这时候两次读取的数据是不一致的。
	 * 幻读：第一个事务对一定范围的数据进行批量修改，第二个事务在这个范围增加一条数据，这时候第一个事务就会丢失对新增数据的修改。

隔离级别越高，越能保证数据的完整性和一致性，但是对并发性能的影响也越大。大多数的数据库默认隔离级别为 Read Commited，比如 SqlServer、Oracle。少数数据库默认隔离级别为：Repeatable Read 比如： MySQL InnoDB。

## Spring中的隔离级别
* ISOLATION_DEFAULT： 这是个 PlatfromTransactionManager 默认的隔离级别，使用数据库默认的事务隔离级别。另外四个与 JDBC 的隔离级别相对应。
* ISOLATION_READ_UNCOMMITTED：这是事务最低的隔离级别，它充许另外一个事务可以看到这个事务未提交的数据。这种隔离级别会产生脏读，不可重复读和幻像读。
* ISOLATION_READ_COMMITTED：保证一个事务修改的数据提交后才能被另外一个事务读取。另外一个事务不能读取该事务未提交的数据。
* ISOLATION_REPEATABLE_READ：这种事务隔离级别可以防止脏读，不可重复读。但是可能出现幻像读。
* ISOLATION_SERIALIZABLE：	这是花费最高代价但是最可靠的事务隔离级别。事务被处理为顺序执行。

## 事务嵌套
假设外层事务 `Service A` 的 `Method A()` 调用 内层 `Service B` 的 `Method B()` 

1. PROPAGATION_REQUIRED

    如果ServiceB.methodB() 的事务级别定义为 PROPAGATION_REQUIRED，那么执行 ServiceA.methodA() 的时候spring已经起了事务，这时调用 ServiceB.methodB()，ServiceB.methodB() 看到自己已经运行在 ServiceA.methodA() 的事务内部，就不再起新的事务。  

    假如 ServiceB.methodB() 运行的时候发现自己没有在事务中，他就会为自己分配一个事务。
	
	这样，在 ServiceA.methodA() 或者在 ServiceB.methodB() 内的任何地方出现异常，事务都会被回滚。
2. PROPAGATION_REQUIRES_NEW

	比如我们设计 ServiceA.methodA() 的事务级别为 PROPAGATION_REQUIRED，ServiceB.methodB() 的事务级别为 PROPAGATION_REQUIRES_NEW。

	那么当执行到 ServiceB.methodB() 的时候，ServiceA.methodA() 所在的事务就会挂起，ServiceB.methodB() 会起一个新的事务，等待 ServiceB.methodB() 的事务完成以后，它才继续执行。

	他与 PROPAGATION_REQUIRED 的事务区别在于事务的回滚程度了。因为 ServiceB.methodB() 是新起一个事务，那么就是存在两个不同的事务。如果 ServiceB.methodB() 已经提交，那么 ServiceA.methodA() 失败回滚，ServiceB.methodB() 是不会回滚的。如果 ServiceB.methodB() 失败回滚，如果他抛出的异常被 ServiceA.methodA() 捕获，ServiceA.methodA() 事务仍然可能提交(主要看B抛出的异常是不是A会回滚的异常)。
3. PROPAGATION_SUPPORTS

	假设ServiceB.methodB() 的事务级别为 PROPAGATION_SUPPORTS，那么当执行到ServiceB.methodB()时，如果发现ServiceA.methodA()已经开启了一个事务，则加入当前的事务，如果发现ServiceA.methodA()没有开启事务，则自己也不开启事务。这种时候，内部方法的事务性完全依赖于最外层的事务。
4. PROPAGATION_NESTED

	现在的情况就变得比较复杂了, ServiceB.methodB() 的事务属性被配置为 PROPAGATION_NESTED, 此时两者之间又将如何协作呢?  ServiceB#methodB 如果 rollback, 那么内部事务(即 ServiceB#methodB) 将回滚到它执行前的 SavePoint 而外部事务(即 ServiceA#methodA) 可以有以下两种处理方式:

	* 捕获异常，执行异常分支逻辑

			void methodA() { 
		        try { 
		            ServiceB.methodB(); 
		        } catch (SomeException) { 
		            // 执行其他业务, 如 ServiceC.methodC(); 
		        } 
			}
	
		这种方式也是嵌套事务最有价值的地方, 它起到了分支执行的效果, 如果 ServiceB.methodB 失败, 那么执行 ServiceC.methodC(), 而 ServiceB.methodB 已经回滚到它执行之前的 SavePoint, 所以不会产生脏数据(相当于此方法从未执行过), 这种特性可以用在某些特殊的业务中, 而 PROPAGATION_REQUIRED 和 PROPAGATION_REQUIRES_NEW 都没有办法做到这一点。

	* 外部事务回滚/提交 代码不做任何修改, 那么如果内部事务(ServiceB#methodB) rollback, 那么首先 ServiceB.methodB 回滚到它执行之前的 SavePoint(在任何情况下都会如此), 外部事务(即 ServiceA#methodA) 将根据具体的配置决定自己是 commit 还是 rollback