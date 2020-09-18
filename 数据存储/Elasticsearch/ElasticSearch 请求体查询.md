时间：2017/12/10 16:21:12   
参考：  

1. [请求体查询](https://www.elastic.co/guide/cn/elasticsearch/guide/current/full-body-search.html)   

环境：  

* 系统版本：Win10 64位  
* Elasticsearch版本:6.0.0

##  请求体查询
### 空查询  

	//查询所有索引
	GET /_search
	//查询u开头的索引
	GET /u*/_search
	//分页查询
	GET /_search 
	{
	  "from": 0,
	  "size": 10
	}
### 查询表达式    
格式：

	GET /_search
	{
	    "query": YOUR_QUERY_HERE
	}
一些查询例子： 
  
1. 匹配所有

		GET /_search
		{
		    "query": {
		        "match_all": {}
		    }
		}
2. 查询指定字段，查询 `text` 字段包含 `trying` 的文档    

		GET /_search
		{
		    "query": {
		        "match": {
		          "text": "trying"
		        }
		    }
		}
3. 合并查询语句，可以嵌套。    

    查询是为了找出信件正文包含 business opportunity 的星标邮件，或者在收件箱正文包含 business opportunity 的非垃圾邮件：

		{
		    "bool": {
		        "must": { "match":   { "email": "business opportunity" }},
		        "should": [
		            { "match":       { "starred": true }},
		            { "bool": {
		                "must":      { "match": { "folder": "inbox" }},
		                "must_not":  { "match": { "spam": true }}
		            }}
		        ],
		        "minimum_should_match": 1
		    }
		}
4. multi_match 查询  
	
		GET /_search
		{
		    "query": {
		        "multi_match": {
		          "query": "com smith",
		          "fields": ["name","email"]
		        }
		    }
		}
5. range 查询，支持gt、gte、lt、lte   

		{
		    "range": {
		        "age": {
		            "gte":  20,
		            "lt":   30
		        }
		    }
		}
6. term 用于精确值查询，tag被设置为 `keywoed` 类型  

		GET /_search
		{
		   "query": {
		     "term": { "tag":  "my name is sunfeilong!"}
		   }
		}
7. terms查询，匹配指定值的一个即匹配   

		{ "terms": { "tag": [ "search", "full_text", "nosql" ] }}
8. exists查询，查询name字段有值的文档  

		GET /_search
		{
		   "query": {
		     "exists": { "field":  "name"}
		   }
		}
9. 一个简单的组合查询（boolean可以包含 must, must_not,should,filter）   

	查找 title 字段匹配 how to make millions 并且不被标识为 spam 的文档。那些被标识为 starred 或在2014之后的文档，将比另外那些文档拥有更高的排名。如果 _两者_ 都满足，那么它排名将更高：

		{
		    "bool": {
		        "must":     { "match": { "title": "how to make millions" }},
		        "must_not": { "match": { "tag":   "spam" }},
		        "should": [
		            { "match": { "tag": "starred" }},
		            { "range": { "date": { "gte": "2014-01-01" }}}
		        ]
		    }
		}

	> 注： 如果没有 must 语句，那么至少需要能够匹配其中的一条 should 语句。但，如果存在至少一条 must 语句，则对 should 语句的匹配没有要求。

10. 增加 `filter` 指定不想影响评分的查询语句。日期字段只是用来过滤，不会影响相关性评分。

		{
		    "bool": {
		        "must":     { "match": { "title": "how to make millions" }},
		        "must_not": { "match": { "tag":   "spam" }},
		        "should": [
		            { "match": { "tag": "starred" }}
		        ],
		        "filter": {
		          "range": { "date": { "gte": "2014-01-01" }} 
		        }
		    }
		}
11. filter 多条件 


		{
		    "bool": {
		        "must":     { "match": { "title": "how to make millions" }},
		        "must_not": { "match": { "tag":   "spam" }},
		        "should": [
		            { "match": { "tag": "starred" }}
		        ],
		        "filter": {
		          "bool": { 
		              "must": [
		                  { "range": { "date": { "gte": "2014-01-01" }}},
		                  { "range": { "price": { "lte": 29.99 }}}
		              ],
		              "must_not": [
		                  { "term": { "category": "ebooks" }}
		              ]
		          }
		        }
		    }
		}
12. constant_score查询，用于只有过滤查询的查询。  

		GET /_search
		{
		   "query": {
		     "bool": {
		       "filter":{
		          "match":{"text":"trying"}
		        }
		     }
		   }
		}
	等价于：  

		GET /_search
		{
		   "query": {
		     "constant_score": {
		       "filter":{
		          "match":{"text":"trying"}
		        }
		     }
		   }
		}
13. 验证查询是否合法以及查询错误验证信息   
     验证查询：

		GET /website/blog/_validate/query
		{
		   "query": {
		      "tweet" : {
		         "match" : "really powerful"
		      }
		   }
		}
	获取错误信息：

		GET /website/blog/_validate/query?explain 
		{
		   "query": {
		      "tweet" : {
		         "match" : "really powerful"
		      }
		   }
		}
		//错误信息如下：  
		{
		  "valid": false,
		  //没有 tweet 类型的查询语句
		  "error": "org.elasticsearch.common.ParsingException: no [query] registered for [tweet]"
		}
14. 排序。先按date排序，再按_score排序    

		GET /_search
		{
		    "query" : {
		        "bool" : {
		            "must":   { "match": { "tweet": "manage text search" }},
		            "filter" : { "term" : { "user_id" : 2 }}
		        }
		    },
		    "sort": [
		        { "date":   { "order": "desc" }},
		        { "_score": { "order": "desc" }}
		    ]
		}
15. 字段多值排序，对于数字和日期可以指定model（mix、max、svg或sum） 

		"sort": {
		    "dates": {
		        "order": "asc",
		        "mode":  "min"
		    }
		}