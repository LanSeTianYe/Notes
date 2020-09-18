时间：2017/12/13 17:01:15    
参考： 

1. [控制分析](https://www.elastic.co/guide/cn/elasticsearch/guide/current/_controlling_analysis.html)  

环境：     

* 系统版本：Win10 64位  
* Elasticsearch版本:6.0.0

## 配置

### 索引配置

### 分析器配置  
#### 分析器是什么\有什么用
分析器用于倒排索引的创建，`转换 -> 分词`之后的数据会经过分析器，此时数据已经时分离的单词，分析器负责对语义进行分析，如过滤掉 `a an the` 等单词，转换同义词等，之后根据结果创建倒排索引。

在我们进行查询的时候，查询参数也需要经过 `转换->分词->分析` 之后从倒排索引中进行查找。  

分析器可以从三个层面进行定义：按字段（per-field）、按索引（per-index）或全局缺省（global default）。Elasticsearch 会按照以下顺序依次处理，直到它找到能够使用的分析器。索引时的顺序如下：

1. 字段映射里定义的 analyzer ，否则
2. 索引设置中名为 default 的分析器，默认为
3. standard 标准分析器  

在搜索时，顺序有些许不同：

1. 查询自己定义的 analyzer ，否则
2. 字段映射里定义的 analyzer ，否则
3. 索引设置中名为 default 的分析器，默认为
4. standard 标准分析器

有时，在索引时和搜索时使用不同的分析器是合理的。 我们可能要想为同义词建索引（例如，所有 quick 出现的地方，同时也为 fast 、 rapid 和 speedy 创建索引）。但在搜索时，我们不需要搜索所有的同义词，取而代之的是寻找用户输入的单词是否是 quick 、 fast 、 rapid 或 speedy 。

为了区分，Elasticsearch 也支持一个可选的 search_analyzer 映射，它仅会应用于搜索时（ analyzer 还用于索引时）。还有一个等价的 default_search 映射，用以指定索引层的默认配置。

如果考虑到这些额外参数，一个搜索时的 完整 顺序会是下面这样：

1. 查询自己定义的 analyzer ，否则
2. 字段映射里定义的 search_analyzer ，否则
3. 字段映射里定义的 analyzer ，否则
4. 索引设置中名为 default_search 的分析器，默认为
5. 索引设置中名为 default 的分析器，默认为
6. standard 标准分析器


#### 分析器配置和查询  
1. 配置指定字段的分析器，指定english字段的类型为 `text`,分析器为 `english`。

		PUT /my_index/_mapping/my_type
		{
		    "my_type": {
		        "properties": {
		            "english_title": {
		                "type":     "text",
		                "analyzer": "english"
		            }
		        }
		    }
		}

2. 查看索引分析器。

		GET /my_index/_mapping
	title使用默认的分析器，结果如下：  

		{
		  "my_index": {
		    "mappings": {
		      "my_type": {
		        "properties": {
		          "english_title": {
		            "type": "text",
		            "analyzer": "english"
		          },
		          "title": {
		            "type": "text",
		            "fields": {
		              "keyword": {
		                "type": "keyword",
		                "ignore_above": 256
		              }
		            }
		          }
		        }
		      }
		    }
		  }
		} 
3. 用字段的分析器分析单词。

		GET /my_index/_analyze
		{
		  "field": "title",   
		  "text": "Foxes"
		}
		//
		GET /my_index/_analyze/
		{
		  "field": "english_title",   
		  "text": "Foxes"
		}
	分析结果：
  
		{
		  "tokens": [
			    {
			      "token": "foxes",
			      "start_offset": 0,
			      "end_offset": 5,
			      "type": "<ALPHANUM>",
			      "position": 0
			    }
			  ]
			}
		{
		  "tokens": [
		    {
		      "token": "fox",
		      "start_offset": 0,
		      "end_offset": 5,
		      "type": "<ALPHANUM>",
		      "position": 0
		    }
		  ]
		}
4. 验证查询是否会匹配，并返回验证解释信息。 

		GET /my_index/my_type/_validate/query?explain
		{
		    "query": {
		        "bool": {
		            "should": [
		                { "match": { "title":         "Foxes"}},
		                { "match": { "english_title": "Foxes"}}
		            ]
		        }
		    }
		}
	验证结果：

		{
		  "valid": true,
		  "_shards": {
		    "total": 1,
		    "successful": 1,
		    "failed": 0
		  },
		  "explanations": [
		    {
		      "index": "my_index",
		      "valid": true,
		      "explanation": "+(title:foxes english_title:fox) #*:*"
		    }
		  ]
		}