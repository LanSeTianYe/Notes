时间：2017/12/13 15:41:18  
参考： 

1. [全文搜索](https://www.elastic.co/guide/cn/elasticsearch/guide/current/full-text-search.html)  

环境：     

* 系统版本：Win10 64位  
* Elasticsearch版本:6.0.0

##  搜索

1. 初始化数据。  

		# 如果有删除
		DELETE my_index
		# 设置主分区数目
		PUT /my_index
		{ "settings": { "number_of_shards": 1 }}
		# 插入数据
		POST /my_index/my_type/_bulk
		{ "index": { "_id": 1 }}
		{ "title": "The quick brown fox" }
		{ "index": { "_id": 2 }}
		{ "title": "The quick brown fox jumps over the lazy dog" }
		{ "index": { "_id": 3 }}
		{ "title": "The quick brown fox jumps over the quick dog" }
		{ "index": { "_id": 4 }}
		{ "title": "Brown fox brown dog" } 

### 单字段匹配查询  

1. 匹配一个单词。

		GET /my_index/my_type/_search
		{
		    "query": {
		        "match": {
		            "title": "QUICK!"
		        }
		    }
		}
2. 查询多个单词，查询包含 `BROWN` 或 `DOG` 的文档。

		GET /my_index/my_type/_search
		{
		    "query": {
		        "match": {
		            "title": "BROWN DOG!"
		        }
		    }
		}
3. 查询多个单词，查询同时包含 `BROWN` 和 `DOG` 的文档。  

		GET /my_index/my_type/_search
		{
		    "query": {
		        "match": {
		            "title": {      
		                "query":    "BROWN DOG!",
		                "operator": "and"
		            }
		        }
		    }
		}
4. 指定查询的精度。 

		GET /my_index/my_type/_search
		{
		  "query": {
		    "match": {
		      "title": {
		        "query":                "quick brown dog",
		        "minimum_should_match": "75%"
		      }
		    }
		  }
		}
	minimum_should_match 的取值，假设总数为 `total`：

	* 整数 `n`：最少匹配 `n` 个，如果过 `n` 大于 `total` 则匹配结果为空。
	* 负整数 `-n`：最少匹配 `total - n`个。
	* 百分比 `n%`：最少匹配向下取整 (total*N%)
	* 负百分比：最少匹配向下取整 (total*（1-N)%)
	* 组合 `3<90%` :如果参数的个数小于等于3，则他们全部要求匹配，如果大于3则用后面的条件。
	* 多个组合 `2<-25% 9<-3`： 假设参数个数为 `n`，如果n大于1小于等于2，则要求匹配n个。如果n大于2小于等于9，则要求匹配匹配 n*25个, 如果n大于9则要求至少匹配 (total-3)个。 
5. 组合查询，和过滤查询不同 `should`表示包含但不是必须，如果包含相关性会更高，评分会更高。

		GET /my_index/my_type/_search
		{
		  "query": {
		    "bool": {
		      "must":     { "match": { "title": "quick" }},
		      "must_not": { "match": { "title": "lazy"  }},
		      "should": [
		                  { "match": { "title": "brown" }},
		                  { "match": { "title": "dog"   }}
		      ]
		    }
		  }
		}
6. 组合查询，如果没有must语句，则should至少要匹配一个，也可以通过 `minimum_should_match` 参数控制should的匹配个数。  
	
		GET /my_index/my_type/_search
		{
		  "query": {
		    "bool": {
		      "should": [
		        { "match": { "title": "brown" }},
		        { "match": { "title": "fox"   }},
		        { "match": { "title": "dog"   }}
		      ],
		      "minimum_should_match": 3 
		    }
		  }
		}
7. `match` 和 `bool` 查询互相替换,match在内部会被替换成bool查询。  

		{
		    "match": { "title": "brown fox"}
		}

	等价于：  

		{
		  "bool": {
		    "should": [
		      { "term": { "title": "brown" }},
		      { "term": { "title": "fox"   }}
		    ]
		  }
		}
8. 指定权重，必须包含 `full text search`，如果包含 `Elasticsearch` 或 `Lucene`评分会变高，而且包含 `Elasticsearh` 的评分会比 `Lucene` 高。

		GET /_search
		{
		    "query": {
		        "bool": {
		            "must": {
		                "match": {  
		                    "content": {
		                        "query":    "full text search",
		                        "operator": "and"
		                    }
		                }
		            },
		            "should": [
		                { "match": {
		                    "content": {
		                        "query": "Elasticsearch",
		                        "boost": 3 
		                    }
		                }},
		                { "match": {
		                    "content": {
		                        "query": "Lucene",
		                        "boost": 2 
		                    }
		                }}
		            ]
		        }
		    }
		}

9. 一个查询的评分分析。should语句的三个条件各占1/3的比重，内部的shuold是在1/3的基础上进行评分计算。

	bool 查询运行每个 match 查询，再把评分加在一起，然后将结果与所有匹配的语句数量相乘，最后除以所有的语句数量。处于同一层的每条语句具有相同的权重。在前面这个例子中，包含 translator 语句的 bool 查询，只占总评分的三分之一。如果将 translator 语句与 title 和 author 两条语句放入同一层，那么 title 和 author 语句只贡献四分之一评分。

		GET /_search
		{
		  "query": {
		    "bool": {
		      "should": [
		        { "match": { "title":  "War and Peace" }},
		        { "match": { "author": "Leo Tolstoy"   }},
		        { "bool":  {
		          "should": [
		            { "match": { "translator": "Constance Garnett" }},
		            { "match": { "translator": "Louise Maude"      }}
		          ]
		        }}
		      ]
		    }
		  }
		}
10. 指定优先级，改变默认的比重。 

		GET /_search
		{
		  "query": {
		    "bool": {
		      "should": [
		        { "match": { 
		            "title":  {
		              "query": "War and Peace",
		              "boost": 2
		        }}},
		        { "match": { 
		            "author":  {
		              "query": "Leo Tolstoy",
		              "boost": 2
		        }}},
		        { "bool":  { 
		            "should": [
		              { "match": { "translator": "Constance Garnett" }},
		              { "match": { "translator": "Louise Maude"      }}
		            ]
		        }}
		      ]
		    }
		  }
		}
