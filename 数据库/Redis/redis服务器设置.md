时间：2018/12/8 15:33:04 

参考：  

## Redis 服务器优化

###  内存驱逐策略

* `noeviction`： 不驱逐当超过最大内存时，客户端创建key会报错。
* `volatile-lru`: 从设置过期时间的 key 中删除，最近最少使用的键。
* `allkeys-lru`: 从所有的key中删除最近最少使用的键，所有的键都有可能被删除。
* `volatile-random`: 设置过期时间的key随机驱逐一个。
* `allkeys-random`: 所有的key随机驱逐一个。
* `volatile-ttl`: 根据key的剩余时间删除键。


**相关命令：**

	# 最大内存设置
	config set maxmemory 1mb
	config get maxmemory
	# 键驱逐策略
	config get maxmemory-policy
	config set maxmemory-policy
 
### 慢命令		

* 设置延迟监控的耗时(单位毫秒)： `config set latency-monitor-threshold 100`
* 查看延迟命令: `latency latest`
* 延迟历史记录：`latency history command`
* 图形化显示，看不懂： `latency graph command`