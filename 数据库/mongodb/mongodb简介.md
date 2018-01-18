时间：2017/8/8 10:13:05  
 
环境：
  
1. win 10
2. MongoDB 3.6.2 Community

## 简介  
### 存储结构
1. 数据库 -> 集合 -> 文档(由字段组成)  

### 特性  

1. [模式验证 （Schema Validation）](https://docs.mongodb.com/manual/core/schema-validation/)：限制字段存储数据的类型等。
2. [视图](https://docs.mongodb.com/manual/core/views/)：只读，不能改名。3.4+
3. [固定容量集合](https://docs.mongodb.com/manual/core/capped-collections/):集合大小固定，类似于一个环，当存储数据超过指定大小时，会删除以前的记录。不能删除元素，不能分片。

		# size bytes，最小 4096
		db.createCollection("log", { capped: true, size: 100000 } )
		db.createCollection("log", { capped: true, size: 5242880, max: 5000 } )
5. 文档字段可动态扩展。
6. 集合分片，扩容。
7. 主从备份，容灾。







	