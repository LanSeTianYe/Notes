时间：2018/1/6 20:39:31   

参考 ： 

1. [扩容设计](https://elasticsearch.cn/book/elasticsearch_definitive_guide_2.x/scale.html)

环境：  

* 系统版本：Win10 64位  
* Elasticsearch版本:6.0.0

##  扩容设计   

### 预分片

为索引指定多个主分片，支持集群扩容。当集群只有一个节点的时候，多个分片会分配在一个节点上，当集群增加节点的时候，主分片会均匀分配在不同的节点上，当节点数大于等于主分片数量的时候，每一个主分片都会位于不同的节点上。默认的主分片数量是5个。
  
预分片情况下新增节点不会提高索引的写入能力。通过增加副本个数可以提高搜索效率。

对于有三个节点的集群，我们指定两个主分片，同时我们可以指定每个主分片的副分片个数是二， 这样就有了六个分片，每个节点上有两个分片，比较均衡。   

	PUT /my_index
	{
	  "settings": {
	    "number_of_shards":   2, 
	    "number_of_replicas": 2
	  }
	}
如果创建索引时指定的分片数量不能满足需求，此时就需要重新索引数据，可以结合游标查询scroll 和 bulk API（批量操作）把数据复制到新的索引。

需要根据实际情况进行规划。

### 多索引

搜索一个索引（有50个分片）和搜索50个索引（每个索引只有一个分片）完全等价，搜索都是建立在50个分片之上。

因此以前设计的索引由于分片数量过少不能满足搜索性能要求的时候，我们可以把新的数据存储在新的索引上，然后搜索的时候指定多个索引，这样可以达到灵活扩容的目的。

可以利用索引别名达到上述目的：  

以前的索引：`tweets_search` 别名负责搜索， `tweets_index` 负责索引数据（增加数据），删除数据怎么办？

	PUT /tweets_1/_alias/tweets_search 
	PUT /tweets_1/_alias/tweets_index
 
添加新索引：此时添加数据，会添加到 `tweets_2`上，搜索的时候从 `tweets_1` 和 `tweets_2` 中搜索。  

	POST /_aliases
	{
	  "actions": [
	    { "add":    { "index": "tweets_2", "alias": "tweets_search" }}, 
	    { "remove": { "index": "tweets_1", "alias": "tweets_index"  }}, 
	    { "add":    { "index": "tweets_2", "alias": "tweets_index"  }}  
	  ]
	}
注意：搜索可以指定多个索引为目标，索引写入（数据写入）只能以单个索引为目标，GET请求也只能以单个索引为目标，可以使用 `multi Get` 达到多索引搜索的目标。（用别名的方法还不如自己控制一个 索引列表，这样更统一，更灵活。）  
### 按时间的索引   
以日志数据为例，可以每天、周、年创建索引，结合别名使用。旧的数据可以你很容以被删除。

	POST /_aliases
	{
	  "actions": [
	    { "add":    { "alias": "logs_current",  "index": "logs_2014-10" }}, 
	    { "remove": { "alias": "logs_current",  "index": "logs_2014-09" }}, 
	    { "add":    { "alias": "last_3_months", "index": "logs_2014-10" }}, 
	    { "remove": { "alias": "last_3_months", "index": "logs_2014-07" }}  
	  ]
	}
注意：记得在更新别名指向信息之前创建索引（需要配置的话进行配置）。

#### 索引模板

	PUT /_template/my_logs 
	{
	  "template": "logstash-*", 
	  "order":    1, 
	  "settings": {
	    "number_of_shards": 1 
	  },
	  "mappings": {
	    "_default_": { 
	      "_all": {
	        "enabled": false
	      }
	    }
	  },
	  "aliases": {
	    "last_3_months": {} 
	  }
	}
说明：

* 应用于以 `logstash-` 开头的索引。
* order是 1
* 主分片数量为 1
* 禁止 `_all` ？
* 把索引添加到 `last_3_months` 这个别名中

#### 处理过期数据

* 删除对应索引  

		DELETE /logs_2013*
* 迁移旧索引 
 
	可以在节点启动时，给节点指定一个标签，标记节点的性能（或其他内容），然后我们就可以把日志数据的新索引分配到性能好的节点，把过期数据分配到性能一般的节点。比如性能好的节点的标签是 `strong`，性能一般的节点标签是`medium`。
	
	指定标签 `./bin/elasticsearch --node.box_type strong`

	迁移数据：

		//新数据
		PUT /logs_2014-10-01
		{
		  "settings": {
		    "index.routing.allocation.include.box_type" : "strong"
		  }
		}
		//旧数据
		POST /logs_2014-09-30/_settings
		{
		  "index.routing.allocation.include.box_type" : "medium"
		}
* 索引优化，旧数据压缩

		//移除副分片
		POST /logs_2014-09-30/_settings
		{ "number_of_replicas": 0 }
		//合并
		POST /logs_2014-09-30/_optimize?max_num_segments=1
		//恢复副分片
		POST /logs_2014-09-30/_settings
		{ "number_of_replicas": 1 }
* 关闭旧索引：刷新、关闭和打开

		POST /logs_2014-01-*/_flush 
		POST /logs_2014-01-*/_close 
		POST /logs_2014-01-*/_open 
* 归档，存储快照

### 用户数据  

#### 共享索引  
支持多个小论坛的搜索服务，需要保证每个论坛只能搜索到数据该论坛的数据，在这种情况下，如果为每个论坛都指定一个索引可能会造成浪费，此时我们可以创建一个大的索引，然后再文档里面用一个字段标记属于哪个论坛。 

	PUT /forums
	{
	  "settings": {
	    "number_of_shards": 10 
	  },
	  "mappings": {
	    "post": {
	      "properties": {
	        "forum_id": { 
	          "type":  "string",
	          "index": "not_analyzed"
	        }
	      }
	    }
	  }
	}
由于把文档分配到指定分片的路由算法默认使用的是id，这种情况下相同论坛的数据会被分配到不同的分片，我们可以在存数据的时候指定路由算法使用 `forum_id` 从而把同一用户的数据分配到同一个的分片。

	PUT /forums/post/1?routing=baking 
	{
	  "forum_id": "baking", 
	  "title":    "Easy recipe for ginger nuts",
	  ...
	}
搜索的时候也指定对应的 `forum_id`, 这样搜索就只会在一个分片上进行

		GET /forums/post/_search?routing=baking 
		{
		  ... ...
		}
多个论坛数据查询：

	GET /forums/post/_search?routing=baking,cooking,recipes
	{
	... ...
	}
#### 利用别名实现共享索引 

* 创建别名

		PUT /forums/_alias/baking
		{
		  "routing": "baking",
		  "filter": {
		    "term": {
		      "forum_id": "baking"
		    }
		  }
		}
		
		PUT /forums/_alias/recipes
		{
		  "routing": "recipes",
		  "filter": {
		    "term": {
		      "forum_id": "recipes"
		    }
		  }
		}
* 存数据

		PUT /baking/post/1 
		{
		  "forum_id": "baking", 
		  "title":    "Easy recipe for ginger nuts"
		}

		PUT /recipes/post/2 
		{
		  "forum_id": "recipes", 
		  "title":    "Easy recipe for ginger nuts"
		}
* 查询数据 

		GET /baking/post/_search
		{
		  "query": {
		    "match": {
		      "title": "ginger nuts"
		    }
		  }
		}

		GET /baking,recipes/post/_search 
		{
		  "query": {
		    "match": {
		      "title": "ginger nuts"
		    }
		  }
		}
#### 为大用户扩容
当某一个论坛快速发展，数据量慢慢增大的时候，我们可以为其创建一个单独的索引（指定满足预期需求的分片），把数据从共享索引复制到新的索引上，然后把索引别名指向新的索引，最后删除旧索引里面的数据。

	POST /_aliases
	{
	  "actions": [
	    { "remove": { "alias": "baking", "index": "forums"    }},
	    { "add":    { "alias": "baking", "index": "baking_v1" }}
	  ]
	}

#### 减少文档的字段数量

集群状态是一种数据结构，存储在每一个节点上。  

* 集群级别的设置
* 集群中的节点
* 索引以及它们的设置、映射（每个字段是什么类型）、分析器、预热器（Warmers）和别名
* 与每个索引关联的分片以及它们分配到的节点

集群状态数据存储在内存中，当数据过大时会占用过多内存，为了保持集群状态数据不会过大，要尽量减少文档的字段数量（映射）（可以使用  `nested objects`）。
