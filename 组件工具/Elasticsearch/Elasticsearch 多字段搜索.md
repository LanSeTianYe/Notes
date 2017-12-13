时间：2017/12/13 15:41:18  
参考： 

1. [多字段查询](https://www.elastic.co/guide/cn/elasticsearch/guide/current/multi-field-search.html)  

环境：     

* 系统版本：Win10 64位  
* Elasticsearch版本:6.0.0

## 
  
### 多字段搜索
####  多字段搜索构造数据  
1. 插入数据   

		PUT /my_index_muilt/my_type/1
		{
		    "title": "Quick brown rabbits",
		    "body":  "Brown rabbits are commonly seen."
		}
		
		PUT /my_index_muilt/my_type/2
		{
		    "title": "Keeping pets healthy",
		    "body":  "My quick brown fox eats rabbits on a regular basis."
		}

####  多字段查询例子  
  
1. `dis_max` 最大化查询，将任何与任一查询匹配的文档作为结果返回，但只将最佳匹配的评分作为查询的评分结果返回。  

		GET my_index_muilt/_search
		{
		    "query": {
		        "dis_max": {
		            "queries": [
		                { "match": { "title": "Brown fox" }},
		                { "match": { "body":  "Brown fox" }}
		            ]
		        }
		    }
		}
	查询结果：
	
		{
		    "_index": "my_index_muilt",
		    "_type": "my_type",
		    "_id": "2",
		    "_score": 0.5753642,
		    "_source": {
		      "title": "Keeping pets healthy",
			  # Brown fox
		      "body": "My quick brown fox eats rabbits on a regular basis."
		    }
	    },
	    {
		    "_index": "my_index_muilt",
		    "_type": "my_type",
		    "_id": "1",
		    "_score": 0.2876821,
		    "_source": {
			   # title 是最佳的，虽然title和body都匹配了但是title更短，所以更佳
		      "title": "Quick brown rabbits",
		      "body": "Brown rabbits are commonly seen."
	    }
2. `tie_breaker` 查询，`tie_breaker`取值范围在 `0~1` 之间。  

    tie_breaker 评分机制：

	1. 获得最佳匹配语句的评分 _score 。
	2. 将其他匹配语句的评分结果与 tie_breaker 相乘。
	3. 对以上评分求和并规范化。

	查询语句：

		GET /my_index_muilt/_search
		{
		    "query": {
		        "dis_max": {
		            "queries": [
		                { "match": { "title": "Quick pets" }},
		                { "match": { "body":  "Quick pets" }}
		            ],
		            "tie_breaker": 0.3
		        }
		    }
		}
3. `multi_match` 查询，在多个字段上反复执行相同查询。下面语句分别在 `title` 和 `body` 上进行查。    

		GET /my_index_muilt/_search
		{
		  "query": {
		    "multi_match": {
		        "query":                "Quick brown fox",
		        "type":                 "best_fields", 
		        "fields":               [ "title", "body" ],
		        "tie_breaker":          0.3,
		        "minimum_should_match": "30%" 
		    }
		  }
		}

	等价于：

		GET /my_index_muilt/_search
		{
		  "query": {
		    "dis_max": {
		      "queries":[
		        {
		          "match": {
		            "title": {
		              "query": "Quick brown fox",
		              "minimum_should_match": "30%"
		            }
		          }
		        },
		        {
		          "match": {
		            "body": {
		              "query": "Quick brown fox",
		              "minimum_should_match": "30%"
		            }
		          }
		        }
		      ],
		      "tie_breaker": 0.3
		    }
		  }
		}
4. `multi_match` 查询。字段名称模糊匹配，查询包含 `title` 的字段。
	
		GET /my_index_muilt/_search
		{
		  "query": {
		    "multi_match": {
		        "query":  "Quick brown fox",
		        "fields": "*title*"
		    }
		  }
		}
5. `multi_match` 查询。提升字段的权重，title的评分乘2。  

		GET /my_index_muilt/_search
		{
		  "query": {
		    "multi_match": {
		        "query":  "Quick brown fox",
		        "fields": ["title^2", "body"]
		    }
		  }
		}
### 多映射查询（一个字段的值在多个字段上存储）
把一个字段的值映射到不同的字段上，ES提供内部支持，每个字段设置不同的过滤、分词和分析器，这样每个字段的倒排索引都是不一样的，查询的时候可以更精确的查询。  

主字段一般用来匹配尽可能多的文档，结合映射字段，根据需求定制映射字段的查询条件，从而提升需要的数据的评分。 

#### 多映射查询数据构造  
1. 定义结构，定义这样的结构之后，title的值会自动填充到std字段，std字段的数据会根据对应的分析器创建倒排索引。   
	
		PUT /my_index_mutil_map
		{
		    "settings": { "number_of_shards": 1 }, 
		    "mappings": {
		        "my_type": {
		            "properties": {
		                "title": { 
		                    "type":     "text",
		                    "analyzer": "english",
		                    "fields": {
		                        "std":   { 
		                            "type":     "text",
		                            "analyzer": "standard"
		                        }
		                    }
		                }
		            }
		        }
		    }
		}
2. 插入数据。

		PUT /my_index_mutil_map/my_type/1
		{ "title": "My rabbit jumps" }
		
		PUT /my_index_mutil_map/my_type/2
		{ "title": "Jumping jack rabbits" }
#### 多映射查询数例子
1. 简单查询，评分相同。

		GET /my_index_mutil_map/_search
		{
		   "query": {
		        "match": {
		            "title": "jumping rabbits"
		        }
		    }
		}
	查询结果： 
		
		{
			"_index": "my_index_mutil_map",
			"_type": "my_type",
			"_id": "1",
			"_score": 0.36464313,
			"_source": {
			  "title": "My rabbit jumps"
		}
		{
			"_index": "my_index_mutil_map",
			"_type": "my_type",
			"_id": "2",
			"_score": 0.36464313,
			"_source": {
			  "title": "Jumping jack rabbits"
		}
	
2. 多字段查询，使用映射字段。

		GET /my_index_mutil_map/_search
		{
		   "query": {
		        "multi_match": {
		            "query":  "jumping rabbits",
		            "type":   "most_fields", 
		            "fields": [ "title", "title.std" ]
		        }
		    }
		}
	查询结果：  

		{
			"_index": "my_index_mutil_map",
			"_type": "my_type",
			"_id": "2",
			"_score": 1.7509375,
			"_source": {
			  "title": "Jumping jack rabbits"
		}
		{
			"_index": "my_index_mutil_map",
			"_type": "my_type",
			"_id": "1",
			"_score": 0.36464313,
			"_source": {
			  "title": "My rabbit jumps"
		}
3. 指定权重。


		GET /my_index_mutil_map/_search
		{
		   "query": {
		        "multi_match": {
		            "query":       "jumping rabbits",
		            "type":        "most_fields",
		            "fields":      [ "title^10", "title.std" ] 
		        }
		    }
		}
4. 跨字段搜索，通过指定 `type` 为 `most_fields` 实现。

			GET /my_index_muilt/_search
		{
		  "query": {
		    "multi_match": {
		        "query":                "Quick brown fox",
		        "type":                 "most_fields", 
		        "fields":               [ "title", "body" ],
		        "tie_breaker":          0.3,
		        "minimum_should_match": "30%" 
		    }
		  }
		}  

    用 most_fields 这种方式搜索也存在某些问题，这些问题并不会马上显现：

	* 它是为多数字段匹配 任意 词设计的，而不是在 所有字段 中找到最匹配的。
	* 它不能使用 operator 或 minimum_should_match 参数来降低次相关结果造成的长尾效应。
	* 词频对于每个字段是不一样的，而且它们之间的相互影响会导致不好的排序结果。

5. 自定义 `_all` 字段，把 `first_name` 和 `last_name` 拷贝到 `full_name` 字段。  
	
	解决用字段 `first_name` 和 `last_name` 查询 “Peter Smith” 的时候， Peter 是个平常的名 Smith 也是平常的姓，这两者都具有较低的 IDF 值。但当索引中有另外一个人的名字是 “Smith Williams” 时， Smith 作为名来说很不平常，以致它有一个较高的 IDF 值，从而导致 “Smith Williams” 的评分比 “Peter Smith” 高的问题。

		PUT /my_person
		{
		    "mappings": {
		        "person": {
		            "properties": {
		                "first_name": {
		                    "type":     "text",
		                    "copy_to":  "full_name" 
		                },
		                "last_name": {
		                    "type":     "text",
		                    "copy_to":  "full_name" 
		                },
		                "full_name": {
		                    "type":     "text"
		                }
		            }
		        }
		    }
		}
6. `cross_fields` 跨字段查询 

	cross_fields 使用词中心式（term-centric）的查询方式，这与 best_fields 和 most_fields 使用字段中心式（field-centric）的查询方式非常不同，它将所有字段当成一个大字段，并在 每个字段 中查找 每个词 。  

	比如：

		GET /_validate/query?explain
		{
		    "query": {
		        "multi_match": {
		            "query":       "peter smith",
		            "type":        "most_fields",
		            "operator":    "and", 
		            "fields":      [ "first_name", "last_name" ]
		        }
		    }
		}

	对于匹配的文档， peter 和 smith 都必须同时出现在相同字段中，要么是 first_name 字段，要么 last_name 字段 

		(+first_name:peter +first_name:smith)
		(+last_name:peter  +last_name:smith) 
	词中心式 会使用以下逻辑：
	
		+(first_name:peter last_name:peter)
		+(first_name:smith last_name:smith)

	换句话说，词 peter 和 smith 都必须出现，但是可以出现在任意字段中。

	cross_fields 类型首先分析查询字符串并生成一个词列表，然后它从所有字段中依次搜索每个词。这种不同的段查询是否能够优于多字段查询，取决于在多字段查询与单字段自定义 _all 之间代价的权衡，即哪种解决方案会带来更大的性能优化就选择哪一种。搜索方式很自然的解决了 字段中心式 查询三个问题中的二个。剩下的问题是逆向文档频率不同。
	
	幸运的是 cross_fields 类型也能解决这个问题，通过 validate-query 可以看到：
	
		GET /_validate/query?explain
		{
		    "query": {
		        "multi_match": {
		            "query":       "peter smith",
		            "type":        "cross_fields", 
		            "operator":    "and",
		            "fields":      [ "first_name", "last_name" ]
		        }
		    }
		}

	它通过 混合 不同字段逆向索引文档频率的方式解决了词频的问题：

		+blended("peter", fields: [first_name, last_name])
		+blended("smith", fields: [first_name, last_name])

	换句话说，它会同时在 first_name 和 last_name 两个字段中查找 smith 的 IDF ，然后用两者的最小值作为两个字段的 IDF 。结果实际上就是 smith 会被认为既是个平常的姓，也是平常的名。
		
7. 提高字段权重,可以指定权重。

		GET /books/_search
		{
		    "query": {
		        "multi_match": {
		            "query":       "peter smith",
		            "type":        "cross_fields",
		            "fields":      [ "title^2", "description" ] 
		        }
		    }
		}