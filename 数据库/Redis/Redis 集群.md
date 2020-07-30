时间：2018/12/6 10:42:49   

参考：

1. [https://redis.io/topics/cluster-tutorial](https://redis.io/topics/cluster-tutorial)

## Redis 集群

HASH tag #{tag} 
只有一个数据库 0


### 常用命令 

	# 集群节点状态
	redis-cli --cluster check 127.0.0.1:7000
	redis-cli -p 7000 cluster nodes
	# 重新hash函数
	redis-cli --cluster reshard 127.0.0.1:7000
	redis-cli reshard <host>:<port> --cluster-from <node-id> --cluster-to <node-id> --cluster-slots <number of slots> --cluster-yes
	redis-cli reshard 127.0.0.1:7000 --cluster-from <node-id> --cluster-to <node-id> --cluster-slots 1000 --cluster-yes
	# 添加节点
	redis-cli --cluster add-node 127.0.0.1:7006 127.0.0.1:7000
	# 添加从节点 不指定主节点
	redis-cli --cluster add-node 127.0.0.1:7006 127.0.0.1:7000 --cluster-slave
	# 添加从节点 指定主节点
	redis-cli --cluster add-node 127.0.0.1:7006 127.0.0.1:7000 --cluster-slave --cluster-master-id 3c3a0c74aae0b56170ccb03a76b60cfe7dc1912e
	# 删除节点
	redis-cli --cluster del-node 127.0.0.1:7000 `<node-id>`
	# 从节点变更主节点
	CLUSTER REPLICATE <master-node-id>

### 集群配置

|配置项|参数值|说明|
|::|::|::|
|cluster-enabled|yes/no| 是否开启集群模式|
|cluster-config-file|文件名| 保存集群信息，用户不可编辑|
|cluster-node-timeout |单位 ms| 集群节点最大不可用时间，主机点不可用超过时间，从节点将会被提升为主节点，当没有主节点时集群将不可用|
|cluster-migration-barrier|||
|cluster-require-full-coverage|yes/no|当key不能映射到集群的节点时是否停止接收写入命令|
|cluster-migration-barrier|默认值1| 副本迁移之后主节点最少保留多少个从节点|

### 主从复制机制  

1. 副本迁移：假设集群中有主节点 A，B，C，从节点 s1，s2，s3，s4。对应状态 A -> (s1, s2)，B -> (s3)， C -> (s4) 当B的从节点s3挂掉之后，集群会自动从 s1 s2 中选出一个从节点作为 B 的从节点。
2. 主节点升级：手动触发故障迁移，把主节点转换为从节点，然后停止运行主节点并升级主节点，重新运行主节点，手动触发故障迁移把从节点恢复为主节点。

### 数据不一致场景

1. 主从复制。主服务挂掉，从服务被提升为主服务之后，由于主从同步有延迟，可能有一部分数据没有同步到从服务器。虽然Redis提供了命令同步调用机制，保证数据同步到从服务器时再返回保存成功，但是还是会存在不一致的情况主服务数据发送到从服务器之后挂掉，此时数据已经同步到从服务，但是主服务却返回给客户端同步错误，此时客户端认为数据没有保存成功，但是当从服务切换为主服务之后数据已经有了。
2. 网络分区。假设有 A,B,C 三个主服务器，对应的从服务器为 A1,B1,C1，客户端为 Client。假设出现分区1 A,C,A1,B1,C1 和 分区2 B，Client。分区出现一段时间之后 B1会被提升为主服务器，Client的请求都会发送到 B 服务器，当分区恢复的时候 Client B成为B1的备份服务器，客户端在出现网络分区这一段时间发送到B的数据，就丢失了。