时间：2017/12/11 20:12:17   
参考：   
1. [深入搜索](https://elasticsearch.cn/book/elasticsearch_definitive_guide_2.x/search-in-depth.html)  

环境：  

* 系统版本：Win10 64位  
* Elasticsearch版本:6.0.0

##  
### 设置字段类型（如果索引已经存在需要删除索引）
  
  
* 设置productID类型为keyword，使之可以进行精确查询。    

		PUT /my_store 
		{
		    "mappings" : {
		        "products" : {
		            "properties" : {
		                "productID" : {
		                    "type" : "keyword"
		                }
		            }
		        }
		    }
		
		}

### 插入数据   

* 批量插入数据  

		POST /my_store/products/_bulk
		{ "index": { "_id": 1 }}
		{ "price" : 10, "productID" : "XHDK-A-1293-#fJ3" }
		{ "index": { "_id": 2 }}
		{ "price" : 20, "productID" : "KDKE-B-9947-#kL5" }
		{ "index": { "_id": 3 }}
		{ "price" : 30, "productID" : "JODL-X-1937-#pV7" }
		{ "index": { "_id": 4 }}
		{ "price" : 30, "productID" : "QQPX-R-3956-#aD8"}


### 更新数据  

* 根据id更新文档部分内容    

		POST /my_store/products/1/_update
		{"doc":{ "tags" : ["a","b"], "tagCount" : 2 }}
		POST /my_store/products/2/_update
		{"doc":{ "tags" : ["a"], "tagCount" : 1}}
		POST /my_store/products/3/_update
		{"doc":{ "tags" : ["b"], "tagCount" : 1}}
		POST /my_store/products/4/_update
		{"doc": { "tags" : ["c"], "tagCount" : 1}}
* 增加日期字段   

		POST /my_store/products/1/_update
		{"doc" :{"date" : "2017-12-01" }}
		POST /my_store/products/2/_update
		{"doc" :{"date" : "2017-12-02"}}
		POST /my_store/products/3/_update
		{"doc" :{"date" : "2017-12-03"}}
		POST /my_store/products/4/_update
		{"doc" :{"date" : "2017-12-04"}}
* 增加名字（文本字段）

		POST /my_store/products/1/_update
		{"doc" :{"name" : "aaa" }}
		POST /my_store/products/2/_update
		{"doc" :{"name" : "bbb"}}
		POST /my_store/products/3/_update
		{"doc" :{"name" : "aba"}}
		POST /my_store/products/4/_update
		{"doc" :{"name" : "bab"}}

### 查询数据  

#### 概念    
* 值查询：term 和 terms 的意思是包含而不是等于，比如查询条件 `{ "term" : { "tags" : "search" } }`,下面两个都会匹配：

		{ "tags" : ["search"] }
		{ "tags" : ["search", "open_source"] }
* 范围查询：range支持 ge（大于）、gte（大于等于）、lt（小于）和 lte（小于等于）。

#### 值查询 
 
* 根据Id进行过滤查询（过滤查询会缓存，效率高）

		GET /my_store/products/_search
		{
		    "query" : {
		        "constant_score" : {
		            "filter" : {
		                "term" : {
		                    "productID" : "XHDK-A-1293-#fJ3"
		                }
		            }
		        }
		    }
		}
 
* 查询多个值 `terms`  

		GET my_store/_search
		{
		  "query": {
		    "constant_score": {
		      "filter": {
		        "terms": {
		          "price": [20,30]
		        }
		      }
		    }
		  }
		}
* 组合过滤条件，多个条件同时满足,包含must（都匹配）、must_not（都不匹配）和should（至少有一个匹配）

	* 查询价格等于20，或者产品ID等于 `XHDK-A-1293-#fJ3`，同时价格不等于30的数据
	
			GET /my_store/products/_search
			{
			  "query": {
			    "bool":{
			       "filter" : {
			          "bool" : {
			            "should" : [
			               { "term" : {"price" : 20}}, 
			               { "term" : {"productID" : "XHDK-A-1293-#fJ3"}} 
			            ],
			            "must_not" : {
			               "term" : {"price" : 30} 
			            }
			         }
			      } 
			    }
			  }
			}
	* 嵌套boolean，价格等于20或 （价格等于30且productID等于JODL-X-1937-#pV7）的数据
  
			GET /my_store/products/_search
			{
			  "query": {
			    "bool":{
			       "filter" : {
			          "bool" : {
			            "should" : [
			               { "term" : {"price" : 20}}, 
			               { "bool" : {
			                  "must" : [
			                    { "term" : {"productID" : "JODL-X-1937-#pV7"}}, 
			                    { "term" : {"price" : 30}} 
			                  ]
			               }}
			            ]
			         }
			      }
			    }
			  }
			}
* term实现精确相等，通过指定数量，精确查询数组的值。

		GET my_store/products/_search
		{
		  "query": {
		    "constant_score": {
		      "filter": {
		        "bool": {
		          "must" : [
		              { "term" : {"tagCount" : 1}},
		              { "term" : {"tags":"a"}}
		          ]
		        }
		      }
		    }
		  }
		}

#### 范围查询  
* 查询价格在一定范围的数据  

		GET my_store/products/_search
		{
		  "query": {
		    "constant_score": {
		      "filter": {
		        "range": {
		          "price": {
		            "gte": 10,
		            "lte": 20
		          }
		        }
		      }
		    }
		  }
		}
	等价的查询 

		GET my_store/products/_search
		{
		  "query": {
		    "range": {
		      "price": {
		        "gte": 10,
		        "lte": 20
		      }
		    }
		  }
		}
* 日期范围   

		GET my_store/products/_search
		{
		  "query": {
		    "constant_score": {
		      "filter": {
		        "range": {
		          "date": {
		            "gte": "2017-12-01",
		            "lte": "2017-12-02"
		          }
		        }
		      },
		      "boost": 1.2
		    }
		  }
		}
	
* 日期范围同时加计算

		GET my_store/products/_search
		{
		  "query": {
		    "constant_score": {
		      "filter": {
		        "range": {
		          "date": {
		            "gte": "2017-12-01",
					//加一天
		            "lte": "2017-12-02||+1d"
		          }
		        }
		      }
		    }
		  }
		}
#### 字符串范围  

* 字符串范围查询

		GET my_store/products/_search
		{
		  "query": {
		    "constant_score": {
		      "filter": {"range": {
		        "name": {
		          "gte": "a",
		          "lt": "b"
		        }
		      }}
		    }
		  }
		}
#### 存在查询和缺失查询
* 数据初始化  

		POST /test_exists/posts/_bulk
		{ "index": { "_id": "1"              }}
		{ "tags" : ["search"]                }  
		{ "index": { "_id": "2"              }}
		{ "tags" : ["search", "open_source"] }  
		{ "index": { "_id": "3"              }}
		{ "other_field" : "some data"        }  
		{ "index": { "_id": "4"              }}
		{ "tags" : null                      }  
		{ "index": { "_id": "5"              }}
		{ "tags" : ["search", null]          }    
* 存在查询  

		GET /test_exists/posts/_search
		{
		    "query" : {
		        "constant_score" : {
		            "filter" : {
		                "exists" : { "field" : "tags" }
		            }
		        }
		    }
		}
* 缺失查询(不能执行)  

		
		GET /test_exists/posts/_search
		{
		    "query" : {
		        "constant_score" : {
		            "filter" : {
		              "bool": {
		                "must_not": {
		                  "exists": {
		                      "field": "tags"
		                  }
		                }
		              } 
		            }
		        }
		    }
		}
* 对象上的缺失  


### 分析数据  

* 使用 productID的分析器分析 `XHDK-A-1293-#fJ3`  

		GET /my_store/_analyze
		{
		  "field": "productID",
		  "text": "XHDK-A-1293-#fJ3"
		}
	分析结果：

		{
		  "tokens": [
		    {
		      "token": "XHDK-A-1293-#fJ3",
		      "start_offset": 0,
		      "end_offset": 16,
		      "type": "word",
		      "position": 0
		    }
		  ]
		}

### 删除数据  

* 删除索引  

		DELETE /my_store