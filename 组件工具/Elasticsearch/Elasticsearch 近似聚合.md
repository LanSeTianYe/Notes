时间：2018/1/2 21:34:26   
参考：

环境：  

* 系统版本：Win10 64位  
* Elasticsearch版本:6.0.0

## 近似聚合  

**初始化数据：** 在color字段里面映射一个计算的hash值，可以提高统计时的效率（索引的时候已经完成hash计算）。

	PUT /cars
	{
	    "mappings": {
	        "transactions": {
	            "properties": {
	                "color": {
	                    "type":"keyword",
	                    "fields": {
	                      "hash":{
	                        "type": "murmur3"
	                      }
	                    }
	                },
	                "make":{
	                  "type": "keyword"
	                }
	            }
	        }
	    }
	}

### cardinality（基数）度量，统计去重  

**三个特性：**

* 可配置的精度，用来控制内存的使用（更精确 ＝ 更多内存）。
* 小的数据集精度是非常高的。
* 我们可以通过配置参数，来设置去重需要的固定内存使用量。无论数千还是数十亿的唯一值，内存使用量只与你配置的精确度相关。

**一些例子：**  
 
1. 去重，统计汽车颜色的种类 

		GET /cars/transactions/_search
		{
		    "size" : 0,
		    "aggs" : {
		        "distinct_colors" : {
		            "cardinality" : {
		              "field" : "color"
		            }
		        }
		    }
		}
2. 去重，统计每个月销售的汽车颜色的种类  

		GET /cars/transactions/_search
		{
		  "size" : 0,
		  "aggs" : {
		      "months" : {
		        "date_histogram": {
		          "field": "sold",
		          "interval": "month"
		        },
		        "aggs": {
		          "distinct_colors" : {
		              "cardinality" : {
		                "field" : "color"
		              }
		          }
		        }
		      }
		  }
		}
3. 指定精确度。

		GET /cars/transactions/_search
		{
		    "size" : 0,
		    "aggs" : {
		        "distinct_colors" : {
		            "cardinality" : {
		              "field" : "color",
		              "precision_threshold" : 100 
		            }
		        }
		    }
		}
	注： precision_threshold 接受 0–40,000 之间的数字，更大的值还是会被当作 40,000 来处理。

	示例会确保当字段唯一值在 100 以内时会得到非常准确的结果。尽管算法是无法保证这点的，但如果基数在阈值以下，几乎总是 100% 正确的。高于阈值的基数会开始节省内存而牺牲准确度，同时也会对度量结果带入误差。
	
	对于指定的阈值，HLL 的数据结构会大概使用 precision_threshold * 8 字节的内存，所以就必须在牺牲内存和获得额外的准确度间做平衡。
	
	在实际应用中， 100 的阈值可以在唯一值为百万的情况下仍然将误差维持 5% 以内。

4. 通过增加额外hash字段，提高效率。

		GET /cars/transactions/_search
		{
		    "size" : 0,
		    "aggs" : {
		        "distinct_colors" : {
		            "cardinality" : {
		              "field" : "color.hash" 
		            }
		        }
		    }
		}

### 百分位计算  

1. 构造数据
	* 初始化索引
	
			PUT /website
			{
			  "mappings": {
			    "logs":{
			      "properties": {
			        "zone":{
			          "type": "keyword"
			        }
			      }
			    }
			  }
			}
	* 初始化数据：

			POST /website/logs/_bulk
			{ "index": {}}
			{ "latency" : 100, "zone" : "US", "timestamp" : "2014-10-28" }
			{ "index": {}}
			{ "latency" : 80, "zone" : "US", "timestamp" : "2014-10-29" }
			{ "index": {}}
			{ "latency" : 99, "zone" : "US", "timestamp" : "2014-10-29" }
			{ "index": {}}
			{ "latency" : 102, "zone" : "US", "timestamp" : "2014-10-28" }
			{ "index": {}}
			{ "latency" : 75, "zone" : "US", "timestamp" : "2014-10-28" }
			{ "index": {}}
			{ "latency" : 82, "zone" : "US", "timestamp" : "2014-10-29" }
			{ "index": {}}
			{ "latency" : 100, "zone" : "EU", "timestamp" : "2014-10-28" }
			{ "index": {}}
			{ "latency" : 280, "zone" : "EU", "timestamp" : "2014-10-29" }
			{ "index": {}}
			{ "latency" : 155, "zone" : "EU", "timestamp" : "2014-10-29" }
			{ "index": {}}
			{ "latency" : 623, "zone" : "EU", "timestamp" : "2014-10-28" }
			{ "index": {}}
			{ "latency" : 380, "zone" : "EU", "timestamp" : "2014-10-28" }
			{ "index": {}}
			{ "latency" : 319, "zone" : "EU", "timestamp" : "2014-10-29" }
2. 延迟数据百分位查询：  

		GET /website/logs/_search
		{
		    "size" : 0,
		    "aggs" : {
		        "load_times" : {
		            "percentiles" : {
		                "field" : "latency" 
		            }
		        },
		        "avg_load_time" : {
		            "avg" : {
		                "field" : "latency" 
		            }
		        }
		    }
		}
	查询结果：  

		{
		  "took": 21,
		  "timed_out": false,
		  "_shards": {
		    "total": 5,
		    "successful": 5,
		    "skipped": 0,
		    "failed": 0
		  },
		  "hits": {
		    "total": 12,
		    "max_score": 0,
		    "hits": []
		  },
		  "aggregations": {
		    "load_times": {
		      "values": {
		        "1.0": 75.55,
		        "5.0": 77.75,
		        "25.0": 94.75,
		        "50.0": 101,
		        "75.0": 289.75,
		        "95.0": 489.34999999999985,
		        "99.0": 596.2700000000002
		      }
		    },
		    "avg_load_time": {
		      "value": 199.58333333333334
		    }
		  }
		}
3. 分区域查询延迟数据。

		GET /website/logs/_search
		{
		    "size" : 0,
		    "aggs" : {
		        "zones" : {
		            "terms" : {
		                "field" : "zone" 
		            },
		            "aggs" : {
		                "load_times" : {
		                    "percentiles" : { 
		                      "field" : "latency",
		                      "percents" : [50, 95.0, 99.0] 
		                    }
		                },
		                "load_avg" : {
		                    "avg" : {
		                        "field" : "latency"
		                    }
		                }
		            }
		        }
		    }
		}
	查询结果：

		"aggregations": {
		    "zones": {
		      "doc_count_error_upper_bound": 0,
		      "sum_other_doc_count": 0,
		      "buckets": [
		        {
		          "key": "EU",
		          "doc_count": 6,
		          "load_times": {
		            "values": {
		              "50.0": 299.5,
		              "95.0": 562.25,
		              "99.0": 610.85
		            }
		          },
		          "load_avg": {
		            "value": 309.5
		          }
		        },
		        {
		          "key": "US",
		          "doc_count": 6,
		          "load_times": {
		            "values": {
		              "50.0": 90.5,
		              "95.0": 101.5,
		              "99.0": 101.9
		            }
		          },
		          "load_avg": {
		            "value": 89.66666666666667
		          }
		        }
		      ]
		    }
		  }
4. 查询小于某个值的数据所占的百分比。下面查询小于210，以及小于800的数据的百分比。

		GET /website/logs/_search
		{
		    "size" : 0,
		    "aggs" : {
		        "zones" : {
		            "terms" : {
		                "field" : "zone"
		            },
		            "aggs" : {
		                "load_times" : {
		                    "percentile_ranks" : {
		                      "field" : "latency",
		                      "values" : [210, 800] 
		                    }
		                }
		            }
		        }
		    }
		}
	查询结果如下：
		
		{
		  "took": 1,
		  "timed_out": false,
		  "_shards": {
		    "total": 5,
		    "successful": 5,
		    "skipped": 0,
		    "failed": 0
		  },
		  "hits": {
		    "total": 12,
		    "max_score": 0,
		    "hits": []
		  },
		  "aggregations": {
		    "zones": {
		      "doc_count_error_upper_bound": 0,
		      "sum_other_doc_count": 0,
		      "buckets": [
		        {
		          "key": "EU",
		          "doc_count": 6,
		          "load_times": {
		            "values": {
		              "210.0": 31.944444444444443,
		              "800.0": 100
		            }
		          }
		        },
		        {
		          "key": "US",
		          "doc_count": 6,
		          "load_times": {
		            "values": {
		              "210.0": 100,
		              "800.0": 100
		            }
		          }
		        }
		      ]
		    }
		  }
		}

