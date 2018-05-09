时间：2018/4/27 10:04:14 

参考：  

1. [http://storm.apache.org/](http://storm.apache.org/)
2. [实时计算——聊一聊我所经历的计算框架](https://www.jianshu.com/p/16323566f3c6)

##   

### 是什么？ 

Storm是免费的开源的分布式 **实时** 计算系统。 `nimbus` 和 `supervisor` 是无状态的，状态信息存储在zookeeper或者本地磁盘，任何接节点挂掉都不会影响系统的正常运行，挂掉的节点也可以快速恢复。

#### 组成：

* nimbus:主节点，负责在集群中分发代码，分配任务，监控，错误处理。
* supervisor:Worker节点，执行任务。
* zookeeper：分布式协调。



#### 特性：

* 可扩展性，集群扩展便捷。
* 保证无数据丢失。
	* 最多提交一次，存在数据丢失的问题。
	* 至少提交一次，存在重复提交的问题。
	* 只提交一次，性能最低。 
* 容易管理，提供 Web UI界面。
* 容错：计算过程中节点出错，Storm会重分配任务。
* 多语言支持。
#### Stream(流) ：
  
* spout:流的数据来源。
* bolt: 处理流数据，存储或者重新发布处理过的数据。

  	![](https://raw.githubusercontent.com/longlongxiao/Notes/master/images/storm/topology.png)
#### 流分组

一个Blot会启动多个task并发的进行数据处理和转换，通过流分组可以指定数据分发到对应Task的策略，常用的策略有：

* 随机（Shuffle grouping）：随机分配。
* 根据字段的值（Fields grouping）：相同的字段分配到同一个task上。
* Local or shuffle grouping：
* Partial Key grouping:
* All grouping:
* Global grouping:
* None grouping: 
* Direct grouping:

![](https://raw.githubusercontent.com/longlongxiao/Notes/master/images/storm/topology-tasks.png)
### 怎么用？

* strom nimbus:启动协调节点 
* strom supervisor：启动任务执行节点
* storm ui：启动Web管理界面
* storm jar : 发布计算任务
* storm monitor: 监控节点数据

		storm monitor -i 1 -m words test
* storm activate：技术指定的拓补。

		storm activate test
* storm kill: 停止topology
* storm swap: 更新正在运行的topology。

### 应用场景：

* 实时分析
* 在线机器学习
* 持续计算
* 分布式RPC调用