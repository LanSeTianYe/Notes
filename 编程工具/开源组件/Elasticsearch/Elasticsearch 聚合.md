时间：2018/1/2 17:01:34   
参考：

环境：  

* 系统版本：Win10 64位  
* Elasticsearch版本:6.0.0

##  聚合
统计信息如评分的平均数、中位数和最大值等聚合函数。用于数据分析。

> 桶（buckets）：满足特定条件的文档的集合。 桶支持嵌套，比如： `国家 -> 城市 -> 性别 -> 年龄`   
> 指标（Metrics）：对桶内文档进行统计计算。  

	//COUNT(color)
	//GROUP BY color 相当于桶。
	SELECT COUNT(color) FROM table GROUP BY color 

## 简单搜索例子  

#### 构造数据 

1. 如果索引存在删除索引，也可以用其它的名字

		DELETE cars
	
2. 指定color数据类型

		PUT /cars
		{
		    "mappings": {
		        "transactions": {
		            "properties": {
		                "color": {
		                    "type":"keyword"
		                },
		                "make":{
		                  "type": "keyword"
		                }
		            }
		        }
		    }
		}
3. 初始化数据

		POST /cars/transactions/_bulk
		{ "index": {}}
		{ "price" : 10000, "color" : "red", "make" : "honda", "sold" : "2014-10-28" }
		{ "index": {}}
		{ "price" : 20000, "color" : "red", "make" : "honda", "sold" : "2014-11-05" }
		{ "index": {}}
		{ "price" : 30000, "color" : "green", "make" : "ford", "sold" : "2014-05-18" }
		{ "index": {}}
		{ "price" : 15000, "color" : "blue", "make" : "toyota", "sold" : "2014-07-02" }
		{ "index": {}}
		{ "price" : 12000, "color" : "green", "make" : "toyota", "sold" : "2014-08-19" }
		{ "index": {}}
		{ "price" : 20000, "color" : "red", "make" : "honda", "sold" : "2014-11-05" }
		{ "index": {}}
		{ "price" : 80000, "color" : "red", "make" : "bmw", "sold" : "2014-01-01" }
		{ "index": {}}
		{ "price" : 25000, "color" : "blue", "make" : "ford", "sold" : "2014-02-12" }

4. 查询每种颜色的汽车的数量  

		GET /cars/transactions/_search
		{
		    "size" : 0,
		    "aggs" : { 
		        "popular_colors" : { 
		            "terms" : { 
		              "field" : "color"
		            }
		        }
		    }
		}
 	* 查询结果如下：  

			{
			  "took": 0,
			  "timed_out": false,
			  "_shards": {
			    "total": 5,
			    "successful": 5,
			    "skipped": 0,
			    "failed": 0
			  },
			  "hits": {
			    "total": 8,
			    "max_score": 0,
			    "hits": []
			  },
			  "aggregations": {
			    "popular_colors": {
			      "doc_count_error_upper_bound": 0,
			      "sum_other_doc_count": 0,
			      "buckets": [
			        {
			          "key": "red",
			          "doc_count": 4
			        },
			        {
			          "key": "blue",
			          "doc_count": 2
			        },
			        {
			          "key": "green",
			          "doc_count": 2
			        }
			      ]
			    }
			  }
			}
5. 查询每种颜色的汽车的平均价格：  

		GET /cars/transactions/_search
		{
		   "size" : 0,
		   "aggs": {
		      "colors": {
		         "terms": {
		            "field": "color"
		         },
		         "aggs": { 
		            "avg_price": { 
		               "avg": {
		                  "field": "price" 
		               }
		            }
		         }
		      }
		   }
		}

	* 查询结果如下：
			
			{
			  "took": 11,
			  "timed_out": false,
			  "_shards": {
			    "total": 5,
			    "successful": 5,
			    "skipped": 0,
			    "failed": 0
			  },
			  "hits": {
			    "total": 8,
			    "max_score": 0,
			    "hits": []
			  },
			  "aggregations": {
			    "colors": {
			      "doc_count_error_upper_bound": 0,
			      "sum_other_doc_count": 0,
			      "buckets": [
			        {
			          "key": "red",
			          "doc_count": 4,
			          "avg_price": {
			            "value": 32500
			          }
			        },
			        {
			          "key": "blue",
			          "doc_count": 2,
			          "avg_price": {
			            "value": 20000
			          }
			        },
			        {
			          "key": "green",
			          "doc_count": 2,
			          "avg_price": {
			            "value": 21000
			          }
			        }
			      ]
			    }
			  }
			} 
6. 嵌套桶，查询每种颜色的汽车的平均价格，以及每种颜色里属于不同汽车制造商的汽车的数量。

		GET /cars/transactions/_search
		{
		   "size" : 0,
		   "aggs": {
		      "colors": {
		         "terms": {
		            "field": "color"
		         },
		         "aggs": {
		            "avg_price": { 
		               "avg": {
		                  "field": "price"
		               }
		            },
		            "make": { 
		                "terms": {
		                    "field": "make" 
		                }
		            }
		         }
		      }
		   }
		}
	* 查询结果： 

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
			    "total": 8,
			    "max_score": 0,
			    "hits": []
			  },
			  "aggregations": {
			    "colors": {
			      "doc_count_error_upper_bound": 0,
			      "sum_other_doc_count": 0,
			      "buckets": [
			        {
			          "key": "red",
			          "doc_count": 4,
			          "avg_price": {
			            "value": 32500
			          },
			          "make": {
			            "doc_count_error_upper_bound": 0,
			            "sum_other_doc_count": 0,
			            "buckets": [
			              {
			                "key": "honda",
			                "doc_count": 3
			              },
			              {
			                "key": "bmw",
			                "doc_count": 1
			              }
			            ]
			          }
			        },
			        {
			          "key": "blue",
			          "doc_count": 2,
			          "avg_price": {
			            "value": 20000
			          },
			          "make": {
			            "doc_count_error_upper_bound": 0,
			            "sum_other_doc_count": 0,
			            "buckets": [
			              {
			                "key": "ford",
			                "doc_count": 1
			              },
			              {
			                "key": "toyota",
			                "doc_count": 1
			              }
			            ]
			          }
			        },
			        {
			          "key": "green",
			          "doc_count": 2,
			          "avg_price": {
			            "value": 21000
			          },
			          "make": {
			            "doc_count_error_upper_bound": 0,
			            "sum_other_doc_count": 0,
			            "buckets": [
			              {
			                "key": "ford",
			                "doc_count": 1
			              },
			              {
			                "key": "toyota",
			                "doc_count": 1
			              }
			            ]
			          }
			        }
			      ]
			    }
			  }
			}
7. 嵌套桶，查询每种颜色的汽车的平均价格，以及每种颜色里属于不同汽车制造商的汽车的数量，并计算每个制造商的最高最低价格。

		GET /cars/transactions/_search
		{
		   "size" : 0,
		   "aggs": {
		      "colors": {
		         "terms": {
		            "field": "color"
		         },
		         "aggs": {
		            "avg_price": { "avg": { "field": "price" }
		            },
		            "make" : {
		                "terms" : {
		                    "field" : "make"
		                },
		                "aggs" : { 
		                    "min_price" : { "min": { "field": "price"} }, 
		                    "max_price" : { "max": { "field": "price"} } 
		                }
		            }
		         }
		      }
		   }
		}

	* 查询结果： 

			"aggregations": {
		    "colors": {
		      "doc_count_error_upper_bound": 0,
		      "sum_other_doc_count": 0,
		      "buckets": [
		        {
		          "key": "red",
		          "doc_count": 4,
		          "avg_price": {
		            "value": 32500
		          },
		          "make": {
		            "doc_count_error_upper_bound": 0,
		            "sum_other_doc_count": 0,
		            "buckets": [
		              {
		                "key": "honda",
		                "doc_count": 3,
		                "max_price": {
		                  "value": 20000
		                },
		                "min_price": {
		                  "value": 10000
		                }
		              },
		              {
		                "key": "bmw",
		                "doc_count": 1,
		                "max_price": {
		                  "value": 80000
		                },
		                "min_price": {
		                  "value": 80000
		                }
		              }
		            ]
		          }
		        }
				... ...
8. 条形图，统计每个价格区间内的价格总和，价格间隔为 20000。

		GET /cars/transactions/_search
		{
		   "size" : 0,
		   "aggs":{
		      "price":{
		         "histogram":{ 
		            "field": "price",
		            "interval": 20000
		         },
		         "aggs":{
		            "revenue": {
		               "sum": { 
		                 "field" : "price"
		               }
		             }
		         }
		      }
		   }
		}
9. 日期聚合查询，查询每月销售汽车的数量  

		GET /cars/transactions/_search
		{
		   "size" : 0,
		   "aggs": {
		      "sales": {
		         "date_histogram": {
		            "field": "sold",
		            "interval": "month", 
		            "format": "yyyy-MM-dd" 
		         }
		      }
		   }
		}
10. 日期聚合查询，返回整年的数据 `extended_bounds`。

		GET /cars/transactions/_search
		{
		   "size" : 0,
		   "aggs": {
		      "sales": {
		         "date_histogram": {
		            "field": "sold",
		            "interval": "month",
		            "format": "yyyy-MM-dd",
		            "min_doc_count" : 0, 
		            "extended_bounds" : { 
		                "min" : "2014-01-01",
		                "max" : "2014-12-31"
		            }
		         }
		      }
		   }
		}
11. 先按季度，然后按品牌计算销售总额。

		GET /cars/transactions/_search
		{
		   "size" : 0,
		   "aggs": {
		      "sales": {
		         "date_histogram": {
		            "field": "sold",
		            "interval": "quarter", 
		            "format": "yyyy-MM-dd",
		            "min_doc_count" : 0,
		            "extended_bounds" : {
		                "min" : "2014-01-01",
		                "max" : "2014-12-31"
		            }
		         },
		         "aggs": {
		            "per_make_sum": {
		               "terms": {
		                  "field": "make"
		               },
		               "aggs": {
		                  "sum_price": {
		                     "sum": { "field": "price" } 
		                  }
		               }
		            },
		            "total_sum": {
		               "sum": { "field": "price" } 
		            }
		         }
		      }
		   }
		}
