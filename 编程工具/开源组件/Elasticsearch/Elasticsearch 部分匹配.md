时间：2017/12/16 20:59:55    
参考： 

1. [部分匹配](https://elasticsearch.cn/book/elasticsearch_definitive_guide_2.x/partial-matching.html)

环境：  

* 系统版本：Win10 64位  
* Elasticsearch版本:6.0.0

## 部分匹配
* 前缀匹配
* 实时搜索，根据输入信息实时搜索
* 长组合词

### 构造数据

1. 指定字段数据类型以及分析器
		
		PUT /my_index/
		{
		    "settings": {
		        "number_of_shards": 1,  
		        "analysis": {
		            "filter": {
		                "autocomplete_filter": {
		                    "type":     "edge_ngram",
		                    "min_gram": 1,
		                    "max_gram": 20
		                }
		            },
		            "analyzer": {
		                "autocomplete": {
		                    "type":      "custom",
		                    "tokenizer": "standard",
		                    "filter": [
		                        "lowercase",
		                        "autocomplete_filter" 
		                    ]
		                }
		            }
		        }
		    },
		    "mappings": {
		        "address": {
		            "properties": {
		                "postcode": {
		                    "type":  "keyword"
		                },
		                "name": {
		                    "type":     "text",
		                    "analyzer": "autocomplete"
		                }
		            }
		        }
		    }
		}

	注：`autocomplete` 分析器会把单词按如下形式分割  `quick` 会分解成 `q` `qu` `qui` `quic` `quick`。
2. 插入数据 

		POST /my_index/address/_bulk
		{ "index": { "_id": 1 }}
		{ "postcode": "W1V 3DG","title": "Sue ate the alligator", "name": "Brown foxes"}
		{ "index": { "_id": 2 }}
		{ "postcode": "W2F 8HW" ,"title": "The alligator ate Sue", "name":"Kobe Briant"  }
		{ "index": { "_id": 3 }}
		{ "postcode": "WC1N 1LZ","title" : "Sue never goes anywhere without her alligator skin purse", "name": "Yellow furballs"}
		{ "index": { "_id": 3 }}
		{ "postcode": "SW5 0BE","title":"The alligator eat Sue", "name":"Sun Feilong" }

	数据含义：这些数据是美国邮编，以 `W1V 3DG` 为例：  

	W1V ：这是邮编的外部，它定义了邮件的区域和行政区：
	> W 代表区域（ 1 或 2 个字母）  
	> 1V 代表行政区（ 1 或 2 个数字，可能跟着一个字符）
	
	3DG ：内部定义了街道或建筑：
	> 3 代表街区区块（ 1 个数字）  
	> DG 代表单元（ 2 个字母）
### 查询示例
1. 前缀查询 `prefix`。 根据前缀进行匹配。

		GET /my_index/address/_search
		{
		    "query": {
		        "prefix": {
		            "postcode": "W"
		        }
		    }
		}

2. 模糊查询 `wildcard`。下面查询匹配以W开头，后面一个任意字符，后面是F，再后面是任意个任意字符后面跟着 HW 的数据。
	
		GET /my_index/address/_search
		{
		    "query": {
		        "wildcard": {
		            "postcode": "W?F*HW" 
		        }
		    }
		}
3. 正则查询 `regexp`。下面查询匹配以W开头，后面跟一个数字，后面至少有一个任意字符的数据， `W1` 不会匹配。

		GET /my_index/address/_search
		{
		    "query": {
		        "regexp": {
		            "postcode": "W[0-9].+" 
		        }
		    }
		}
4. 短语前缀匹配 `match_phrase_prefix`。 下面查询会匹配 title 包含 `the  alligator at*` 的内容。

		GET /my_index/address/_search
		{
		  "query": {
		    "match_phrase_prefix": {
		      "title": "The alligator at"
		    }
		  }
		}
5. 短语前缀匹配 `match_phrase_prefix` 指定 `slop`，。只有最后一个词才能当前缀使用。

		GET /my_index/address/_search
		{
		  "query": {
		    "match_phrase_prefix": {
		      "title": {
		        "query": "The alligator at",
		        "slop" :10
		      }
		    }
		  }
		}
	查询结果：

	    "hits": [
	      {
	        "_index": "my_index",
	        "_type": "address",
	        "_id": "2",
	        "_score": 0.8630463,
	        "_source": {
	          "postcode": "W2F 8HW",
	          "title": "The alligator ate Sue"
	        }
	      },
	      {
	        "_index": "my_index",
	        "_type": "address",
	        "_id": "1",
	        "_score": 0.3273624,
	        "_source": {
	          "postcode": "W1V 3DG",
	          "title": "Sue ate the alligator"
	        }
	      }
	    ]
6. 短语前缀匹配 `match_phrase_prefix` 指定 `slop`，同时限制前缀查询查询数据量。

		GET /my_index/address/_search
		{
		  "query": {
		    "match_phrase_prefix": {
		      "title": {
		        "query": "The alligator at",
		        "max_expansions": 50,
		        "slop" :10
		      }
		    }
		  }
		}
7. `n-grams` 边界查询。对单词进行特殊的切分，如 `quick` 会分解成 `q` `qu` `qui` `quic` `quick`。


		GET /my_index/address/_search
		{
		    "query": {
		        "match": {
		            "name": "brown fo"
		        }
		    }
		}

	查询结果：

		"hits": [
	      {
	        "_index": "my_index",
	        "_type": "address",
	        "_id": "1",
	        "_score": 2.0325346,
	        "_source": {
	          "postcode": "W1V 3DG",
	          "title": "Sue ate the alligator",
	          "name": "Brown foxes"
	        }
	      },
	      {
	        "_index": "my_index",
	        "_type": "address",
	        "_id": "2",
	        "_score": 1.2379456,
	        "_source": {
	          "postcode": "W2F 8HW",
	          "title": "The alligator ate Sue",
	          "name": "Kobe Briant"
	        }
	      },
	      {
	        "_index": "my_index",
	        "_type": "address",
	        "_id": "3",
	        "_score": 0.5361201,
	        "_source": {
	          "postcode": "SW5 0BE",
	          "title": "The alligator eat Sue",
	          "name": "Sun Feilong"
	        }
	      }
	    ]
	匹配结果和预期的不一样，是因为我们查询参数也是用了 `autocomplete` 分析器，使用下面的语句进行验证：

		GET /my_index/address/_validate/query?explain
		{
		    "query": {
		        "match": {
		            "name": "brown fo"
		        }
		    }
		}
	验证结果：

		"explanations": [
		    {
		      "index": "my_index",
		      "valid": true,
		      "explanation": "+(Synonym(name:b name:br name:bro name:brow name:brown) Synonym(name:f name:fo)) #*:*"
		    }
		  ]
	为了查找到想要的结果，我们可以在查询时指定其他分析器或者再定义索引的时候，配置相应的查询解析器
	
	方案一：查询时，指定查询参数的分析器

		GET /my_index/address/_search
		{
		    "query": {
		        "match": {
		            "name": {
		              "query": "brown fo",
		              "analyzer": "standard" 
		            }
		        }
		    }
		}
	方案二（推荐）：创建索引时指定对应的查询分析器。

		PUT /my_index/address/_mapping
		{
		    "address": {
		        "properties": {
		            "name": {
		                "type":            "string",
		                "index_analyzer":  "autocomplete", 
		                "search_analyzer": "standard" 
		            }
		        }
		    }
		}
8. 解决长组合词问题，长组合词时多个单词包含连接起来组成的一个单词，例如 `MyNameIsSunFeiLong` 在分词的时候，会被分割成一个完整的单词，如果查询 `name` 或其包含的任意一个单词，并不会与之匹配，我们可以通过分词器把长词组合分割成一段段的单词，如 `myn` `yna` `nam` `ame` ... ，我们查询的词也被分割成 `nam` `ame`，这样就能和结果匹配，为了达到这种效果，我们需要自定义的分析器。
	
	定义分析器：

		PUT /my_index
		{
		    "settings": {
		        "analysis": {
		            "filter": {
		                "trigrams_filter": {
		                    "type":     "ngram",
		                    "min_gram": 3,
		                    "max_gram": 3
		                }
		            },
		            "analyzer": {
		                "trigrams": {
		                    "type":      "custom",
		                    "tokenizer": "standard",
		                    "filter":   [
		                        "lowercase",
		                        "trigrams_filter"
		                    ]
		                }
		            }
		        }
		    },
		    "mappings": {
		        "my_type": {
		            "properties": {
		                "text": {
		                    "type":     "text",
		                    "analyzer": "trigrams" 
		                }
		            }
		        }
		    }
		}
	
	插入数据

		POST /my_index/my_type/_bulk
		{ "index": { "_id": 1 }}
		{ "text": "Aussprachewörterbuch" }
		{ "index": { "_id": 2 }}
		{ "text": "Militärgeschichte" }
		{ "index": { "_id": 3 }}
		{ "text": "Weißkopfseeadler" }
		{ "index": { "_id": 4 }}
		{ "text": "Weltgesundheitsorganisation" }
		{ "index": { "_id": 5 }}
		{ "text": "Rindfleischetikettierungsüberwachungsaufgabenübertragungsgesetz" }

	测试查询：

		GET /my_index/my_type/_search
		{
		    "query": {
		        "match": {
		            "text": "Adler"
		        }
		    }
		}
	查询结果：

		"hits": [
	      {
	        "_index": "my_index",
	        "_type": "my_type",
	        "_id": "3",
	        "_score": 0.56437,
	        "_source": {
	          "text": "Weißkopfseeadler"
	        }
	      }
	    ]
			