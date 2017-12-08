时间：2017/12/8 15:36:29   

参考：   

1. [ElasticSearch 权威指南](https://www.elastic.co/guide/cn/elasticsearch/guide/current/index.html)

##  

### 是什么以及能做什么    

分布式的文档存储和检索引擎。可以存储非结构化数据数据以及对存储数据进行复杂的搜索。

它的索引、类型和标识（标识一条记录），分别对应关系型数据库的库、表和主键（标识一行数据）。不同于关系型数据库，它存储的数据结构是不固定的，以JSON结构进行存储，不要求每一个标识存储的数据完全一样，可以动态的扩展存储的数据的结构。  

分片机制：主分片和副分片，主分片的集合代表所有的数据，副分片是主分片的复制，通过指定复制因子（kafka也有类似的机制）来确定每一个主分片对应的副分片的个数，在集群中，在节点个数大于 `复制因子+1` 的情况下，当有小于等于复制因子的节点挂掉之后可以保证数据不会丢失。  

注：索引对应的主分片指定后不能修改，对应的复制因子可以动态修改。  
注：当节点数小于主分片数是，多个主分片会分配到一个节点上。当节点数小于 `复制因子+1` 时，每个主分片只会有 `节点数 - 1` 个副分片。  

基于版本号的冲突处理：ES使用乐观的并发控制。更新数据的时候可以指定基础数据的版本号，实际存储的版本号和传入的版本号不一样，则会更新失败，此时客户端可以进一步处理，比如重新查询并更改，从而达到并发控制目的。

注：ES6.x 已经不支持一个索引下面包含多个 type，[why?](https://www.elastic.co/guide/en/elasticsearch/reference/6.0/breaking-changes-6.0.html)

结构化查询和全文检索。  

### 基本概念  

* 映射（Mapping）
* 分析（Analysis）
* 领域特定查询语言（Query DSL）

    
### 怎么用  

#### 一些常用的 Restful 接口    

注：put操作要求是幂等的。  
1. 查看集群的运行状况 `GET /_cluster/health`  

		{
		  "cluster_name": "elasticsearch",
		  "status": "yellow",
		  "timed_out": false,
		  "number_of_nodes": 1,
		  "number_of_data_nodes": 1,
		  "active_primary_shards": 17,
		  "active_shards": 17,
		  "relocating_shards": 0,
		  "initializing_shards": 0,
		  "unassigned_shards": 17,
		  "delayed_unassigned_shards": 0,
		  "number_of_pending_tasks": 0,
		  "number_of_in_flight_fetch": 0,
		  "task_max_waiting_in_queue_millis": 0,
		  "active_shards_percent_as_number": 50
		} 
2. 创建索引（对应三个主分片，每个主分片对应一个副分片）  

		PUT /person
		{
		   "settings" : {
		      "number_of_shards" : 3,
		      "number_of_replicas" : 1
		   }
		}
		//返回结果
		{
		  "acknowledged": true,
		  "shards_acknowledged": true,
		  "index": "person"
		}
  
3. 修改索引的复制因子  

		PUT /blogs/_settings
		{
		   "number_of_replicas" : 2
		}
4. put存数据（幂等）  

		PUT /{index}/{type}/{id}
		{
		  "field": "value",
		  ...
		}
5. post存储数据（非幂等）  

		POST /{index}/{type}/
		{
		  "field":"value",
		  ...
		}
6. 获取存储数据（pretty会美化返回的JSON数据）   

		GET /{index}/{type}/{id}?pretty
7. 获取存储数据的一部分内容

		//获取指定的字段
		GET /{index}/{type}/{id}?_source=[field1],[field2]...
		//获取 存储的数据，不返回版本等信息
		GET /{index}/{type}/{id}?_source
8. 检查数据是否存在，存在返回 200响应码，不存在返回404响应码   

		Head /{index}/{type}/{id}
9. 更新整个文档   

		PUT /{index}/{type}/{id}
		{
		  "field": "value",
		  ...
		}
10. 不存在时创建，成功时返回201，不成功返回409     

		PUT /{index}/{type}/{id}?op_type=create
		{ ... }
		PUT /{index}/{type}/{id}/create
		{ ... }
11. 删除数据，成功200，失败404    

		DELETE /{index}/{type}/{id}
12. 指定更新的版本号，版本号相同更新成功，版本号不同更新失败，失败409    

		PUT /{index}/{type}/{id}?version={base_version}
		{...}
13. 外部版本号，此时更新的时候如果当前版本号小于指定的版本号则更新成功   

		PUT /{index}/{type}/{id}?version={version}&version_type=external
14. 更新部分数据  

		POST /website/blog/1/_update
		{
		   "doc" : {
		      "tags" : [ "testing" ],
		      "views": 0
		   }
		}
15. 使用脚本更新文档（支持Groovy脚本）  

		POST /website/blog/1/_update
		{
		   "script" : "ctx._source.views+=1"
		}
16. 冲突的时候，尝试多次  

		POST /website/blog/11/_update?retry_on_conflict=5 
		{
		   "script" : "ctx._source.views+=1",
		   "upsert": {
		       "views": 0
		   }
		}

17. 取回多个文档  

		GET /_mget
		{
		   "docs" : [
		      {
		         "_index" : "website",
		         "_type" :  "blog",
		         "_id" :    2
		      },
		      {
		         "_index" : "website",
		         "_type" :  "blog",
		         "_id" :    1,
		         "_source": "views"
		      }
		   ]
		}
		//简化
		GET /website/blog/_mget
		{
		   "docs" : [
		      { "_id" : 2 },
		      { "_id" : 1 }
		   ]
		}
		//再简化
		GET /website/blog/_mget
		{
		   "ids" : [ "2", "1" ]
		}
18. 批量操作，格式如下：  

		{ action: { metadata }}\n
		{ request body        }\n
		{ action: { metadata }}\n
		{ request body        }\n  


   * action: 执行什么操作
     * create:如果文档不存在，那么就创建它
     * index:创建一个新文档或者替换一个现有的文档。
     * update:部分更新一个文档。
     * delete:删除一个文档。
   * metadata ： 数据

			POST /_bulk?pretty
			{ "delete": { "_index": "website", "_type": "blog", "_id": "123" }} 
			{ "create": { "_index": "website", "_type": "blog", "_id": "123" }}
			{ "title":    "My first blog post" }
			{ "index":  { "_index": "website", "_type": "blog" }}
			{ "title":    "My second blog post" }
			{ "update": { "_index": "website", "_type": "blog", "_id": "123", "_retry_on_conflict" : 3} }
			{ "doc" : {"title" : "My updated blog post"} }

#### 搜索相关  

1. 空条件查询  

		GET /_search
		//指定超时时间 
		GET /_search?timeout=10ms
		//查询指定索引下的数据
		GET /{idenx},{index2}.../_search
		//简单正则
		GET /w*,u*/_search
		//指定类型
		GET /website/blog
		//查询指定索引下的指定类型
		GET /gb,us/user,tweet/_search
		//查询所有索引下的指定类型
		GET /_all/user,tweet/_search
2. 分页（size查询多少条，默认10，from跳过前面多少条记录，默认0）   
 
		//查询5条
		GET /_search?size=5
		GET /_search?size=5&from=5
3. 轻量查询  

		//查询所有索引中blog类型的文档，其中nane字段等于sun的。
		GET /_all/blog/_search?q=name:sun
		//+title:second +text:this 查询tile包含second单词并且text包含this单词的文档
		//+标识必须匹配，-表示不一定匹配，没有+和-匹配的越多越相关
		GET /_search?q=+title:second +text:this
		//搜索包含age的文档,不指定字段名字，相当于在所有的字段中查询  
		GET /_search?q=age
		//查询title包含 My和blog并且日期大于2013-12-12，并且任意字段包含post
		GET /website/blog/_search?q=+title(My,blog) +date>2013-12-12 +(post)
3.  分析索引  
	
		//获取website索引blog类型数据的映射
		GET /website/_mapping/blog

    结果如下：

		{
		  "website": {
		    "mappings": {
		      "blog": {
		        "properties": {
		          "age": {
		            "type": "text",
		            "fields": {
		              "keyword": {
		                "type": "keyword",
		                "ignore_above": 256
		              }
		            }
		          },
		          "date": {
		            "type": "date",
		            "format": "yyyy/MM/dd HH:mm:ss||yyyy/MM/dd||epoch_millis"
		          },
		          "title": {
		            "type": "text",
		            "fields": {
		              "keyword": {
		                "type": "keyword",
		                "ignore_above": 256
		              }
		            }
		          },
		          "views": {
		            "type": "long"
		          }
		        }
		      }
		    }
		  }
		}