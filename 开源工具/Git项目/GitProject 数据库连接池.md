时间： 2018/7/4 9:50:34   

参考： 

1. [各种数据库连接池对比](https://github.com/alibaba/druid/wiki/%E5%90%84%E7%A7%8D%E6%95%B0%E6%8D%AE%E5%BA%93%E8%BF%9E%E6%8E%A5%E6%B1%A0%E5%AF%B9%E6%AF%94)
2. [主流Java数据库连接池比较及前瞻](http://blog.didispace.com/java-datasource-pool-compare/)
3. [数据库连接池性能比对](http://freeman1.iteye.com/blog/2268874)


##  数据库连接池

### 简介

* **C3p0**: 开源的JDBC连接池，实现了数据源和JNDI绑定，支持JDBC3规范和JDBC2的标准扩展。目前使用它的开源项目有Hibernate、Spring等。单线程，性能较差，适用于小型系统，代码600KB左右。

* **DBCP (Database Connection Pool)**：由Apache开发的一个Java数据库连接池项目， Jakarta commons-pool对象池机制，Tomcat使用的连接池组件就是DBCP。单独使用dbcp需要3个包：common-dbcp.jar,common-pool.jar,common-collections.jar，预先将数据库连接放在内存中，应用程序需要建立数据库连接时直接到连接池中申请一个就行，用完再放回。单线程，并发量低，性能不好，适用于小型系统。
* **Tomcat Jdbc Pool：** Tomcat在7.0以前都是使用common-dbcp做为连接池组件，但是dbcp是单线程，为保证线程安全会锁整个连接池，性能较差，dbcp有超过60个类，也相对复杂。Tomcat从7.0开始引入了新增连接池模块叫做Tomcat jdbc pool，基于Tomcat JULI，使用Tomcat日志框架，完全兼容dbcp，通过异步方式获取连接，支持高并发应用环境，超级简单核心文件只有8个，支持JMX，支持XA Connection。

* **BoneCP：** 官方说法BoneCP是一个高效、免费、开源的Java数据库连接池实现库。设计初衷就是为了提高数据库连接池性能，根据某些测试数据显示，BoneCP的速度是最快的，要比当时第二快速的连接池快25倍左右，完美集成到一些持久化产品如Hibernate和DataNucleus中。BoneCP特色：高度可扩展，快速；连接状态切换的回调机制；允许直接访问连接；自动化重置能力；JMX支持；懒加载能力；支持XML和属性文件配置方式；较好的Java代码组织，100%单元测试分支代码覆盖率；代码40KB左右。

* **Druid：** Druid是Java语言中最好的数据库连接池，Druid能够提供强大的监控和扩展功能，是一个可用于大数据实时查询和分析的高容错、高性能的开源分布式系统，尤其是当发生代码部署、机器故障以及其他产品系统遇到宕机等情况时，Druid仍能够保持100%正常运行。主要特色：为分析监控设计；快速的交互式查询；高可用；可扩展；Druid是一个开源项目，源码托管在github上。 

### 数据库连接池对比  

|特性|Druid|BoneCP|DBCP|C3P0|Proxool|JBoss|Tomcat-Jdbc|HikariCP|
|:--|:--|:--|:--|:--|:--|:--|:--|:--|
|线程同步|多线程、异步|多线程、异步|单线程|单线程|多线程、异步|多线程、异步|多线程、异步|多线程、异步|
|LRU|是|否|是|否|是|是|?|?|
|PSCache|是|是|是|是|否|否|是|否|
|PSCache-Oracle-Optimized|是|否|否|否|否|否|否|?|
|ExceptionSorter|是|否|否|否|否|是|否|?|
|连接池管理|数组、CopyOnWriteArray|堆栈|LinkedBlockingDequeue、FIFO队列、FILO堆栈|队列|？|？|FairBlockingQueue|ThreadLocal+copyOnWriteArrayList|
|更新维护|是|否|否|否|否|?|是|是|

指标简介：

* LRU

    LRU是一个性能关键指标，特别Oracle，每个Connection对应数据库端的一个进程，如果数据库连接池遵从LRU，有助于数据库服务器优化，这是重要的指标。在测试中，Druid、DBCP、Proxool是遵守LRU的。BoneCP、C3P0则不是。BoneCP在mock环境下性能可能好，但在真实环境中则就不好了。

* PSCache

	PSCache是数据库连接池的关键指标。在Oracle中，类似SELECT NAME FROM USER WHERE ID = ?这样的SQL，启用PSCache和不启用PSCache的性能可能是相差一个数量级的。Proxool是不支持PSCache的数据库连接池，如果你使用Oracle、SQL Server、DB2、Sybase这样支持游标的数据库，那你就完全不用考虑Proxool。

* PSCache-Oracle-Optimized

	Oracle10系列的Driver，如果开启PSCache，会占用大量的内存，必须做特别的处理，启用内部的EnterImplicitCache等方法优化才能够减少内存的占用。这个功能只有DruidDataSource有。如果你使用的是Oracle Jdbc，你应该毫不犹豫采用DruidDataSource。

* ExceptionSorter

	ExceptionSorter是一个很重要的容错特性，如果一个连接产生了一个不可恢复的错误，必须立刻从连接池中去掉，否则会连续产生大量错误。这个特性，目前只有JBossDataSource和Druid实现。Druid的实现参考自JBossDataSource，经过长期生产反馈补充。


### 常用数据库
#### [Druid](https://github.com/alibaba/druid)


#### Tomcat-Jdbc

#### HikariCP

