时间：2017-12-15 17:19:09 

参考： 

1. [近似匹配](https://elasticsearch.cn/book/elasticsearch_definitive_guide_2.x/proximity-matching.html)

环境：

* 系统版本：Win10 64位 
* Elasticsearch版本:6.0.0

## 近似匹配

对于： 

* Sue ate the alligator.
* The alligator ate Sue.
* Sue never goes anywhere without her alligator-skin purse.

用 `match` 搜索 `sue alligator`，上面三个文档都会得到匹配，但却不能确定这两个词是否至来自于一种语境，甚至不能确定是否来自同一段落。想要语义更接近的数据有更高的相关度，这是我们就可以使用 `短语匹配` 或者 `近似匹配` 。

### 数据构造

1. 数据如下。

    ```json
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
    ```

### 短语查询  

1. `match_phrase` 是短语查询，匹配包含指定短语的文档。下面的例子匹配文档里有 `quick brown fox`三个单词相连的文档，如果删除 `fox` 就不会匹配到任何数据。

    ```json
    GET /my_index/my_type/_search
    {
        "query": {
            "match_phrase": {
                "title": "quick brown fox"
            }
        }
    }
    ```

2. `match_phrase`查询，添加 `slop` 灵活度参数，意思是在把要查询的词条移动灵活度指定的次数之内，如果可以匹配，也视为文档匹配。每个查询参数里面的每个单词都可以前移或后移。如下面的查询只会匹配 `title` 是 `The quick brown fox jumps over the quick dog` 的文档。

    ```json
    GET /my_index/my_type/_search
    {
        "query": {
            "match_phrase": {
                "title": {
                    "query": "quick jumps quick",
                    "slop":  4
                }
            }
        }
    }
    ```
    
    官网的示例图：

    为了使查询 fox quick 匹配我们的文档， 我们需要 slop 的值为 3:

    ```json
                Pos 1         Pos 2         Pos 3
    -----------------------------------------------
    Doc:        quick         brown         fox
    -----------------------------------------------
    Query:      fox           quick
    Slop 1:     fox|quick  ↵  
    Slop 2:     quick      ↳  fox
    Slop 3:     quick                 ↳     fox
    ```
    
3. `position_increment_gap` 参数指定同一个字段内包含多个数据（数组）时，在对字段创建倒排索引时，数组里面两个相邻元素的位置差，需要在创建索引前指定。

    ```json
    PUT /my_index/_mapping/groups 
    {
        "properties": {
            "names": {
                "type":                "string",
                "position_increment_gap": 100
            }
        }
    }
    ```

4. 通过设置较大的 `slop` 值，可以使单词邻近的文档有更高的评分。
        
    ```json
    GET /my_index/my_type/_search
    {
        "query": {
            "match_phrase": {
                "title": {
                    "query": "quick dog",
                    "slop":  50
                }
            }
        }
    }
    ```

5. 把邻近查询用来提高文档的相关度。由于邻近查询要求所有的字段都匹配才算匹配，可以把邻近查询放在should语句里面，用作提高评分，用 match 查询作为主查询，尽可能多的匹配文档。
        
    ```json
    GET /my_index/my_type/_search
    {
      "query": {
        "bool": {
          "must": {
            "match": { 
              "title": {
                "query":                "quick brown fox",
                "minimum_should_match": "30%"
              }
            }
          },
          "should": {
            "match_phrase": { 
              "title": {
                "query": "quick brown fox",
                "slop":  50
              }
            }
          }
        }
      }
    }
    ```

6. `rescore` 结果集重新打分，通过match查询，查到对应的文档。然后对查询结果进行重打分，可以指定每个分片重打分文档的最大数量，可以避免上面那个例子里面使用should对所有匹配结果进行重打分的行为，提高查询效率。

    ```json
    GET /my_index/my_type/_search
    {
        "query": {
            "match": {  
                "title": {
                    "query":                "quick brown fox",
                    "minimum_should_match": "30%"
                }
            }
        },
        "rescore": {
            "window_size": 50, 
            "query": {         
                "rescore_query": {
                    "match_phrase": {
                        "title": {
                            "query": "quick brown fox",
                            "slop":  50
                        }
                    }
                }
            }
        }
    }
    ```

7. 寻找相关词，把两个相连的单词或者多个相连的单词作为索引。比如 `Sue ate the alligator` 对应的索引是 `["sue ate", "ate the", "the alligator"]` 。具体步骤如下：

    1. 如果索引里面已经存在数据需要删除索引，之后创建自定义的自定义的词汇单元过滤器。
            
    ```json
    PUT /my_index
    {
        "settings": {
            "number_of_shards": 1,  
            "analysis": {
                "filter": {
                    "my_shingle_filter": {
                        "type":             "shingle",
                        "min_shingle_size": 2, 
                        "max_shingle_size": 2, 
                        "output_unigrams":  false   
                    }
                },
                "analyzer": {
                    "my_shingle_analyzer": {
                        "type":             "custom",
                        "tokenizer":        "standard",
                        "filter": [
                            "lowercase",
                            "my_shingle_filter" 
                        ]
                    }
                }
            }
        }
    }
    ```
    
    2. 进行分析以及查看分析结果。
    
         分析语句：

        ```json
        GET /my_index/_analyze
        {
          "field": "my_type.english_title",   
          "text": "Quick brown fox",
          "analyzer": "my_shingle_analyzer"
        }
        ```
    
        分析结果：
        
        ```json
        {
          "tokens": [
            {
              "token": "quick brown",
              "start_offset": 0,
              "end_offset": 11,
              "type": "shingle",
              "position": 0
            },
            {
              "token": "brown fox",
              "start_offset": 6,
              "end_offset": 15,
              "type": "shingle",
              "position": 1
            }
          ]
        }
        ```
    
8. 上面的自定义词汇单元过滤器中 `"output_unigrams":  false ` 表示这个这个索引里面不会包含单个的单词，这样我们就需要多字段来表示来分别表示 `多单词的索引` 和 `一个单词的索引`。例子如下：

    创建多字段：

    ```json
    PUT /my_index/_mapping/my_type
    {
        "my_type": {
            "properties": {
                "title": {
                    "type": "text",
                    "fields": {
                        "shingles": {
                            "type":     "text",
                            "analyzer": "my_shingle_analyzer"
                        }
                    }
                }
            }
        }
    }
    ```

    初始化数据：

    ```json
    POST /my_index/my_type/_bulk
    { "index": { "_id": 1 }}
    { "title": "Sue ate the alligator" }
    { "index": { "_id": 2 }}
    { "title": "The alligator ate Sue" }
    { "index": { "_id": 3 }}
    { "title": "Sue never goes anywhere without her alligator skin purse" }
    ```

    进行查询，会发现第二个查询包含 `The alligator ate Sue` 的文档有较高的评分：  
    
    查询一：

    ```json 
    GET /my_index/my_type/_search
    {
       "query": {
            "match": {
               "title": "the hungry alligator ate sue"
            }
       }
    }
    ```
    
    查询二：

    ```json
    GET /my_index/my_type/_search
    {
       "query": {
          "bool": {
             "must": {
                "match": {
                   "title": "the hungry alligator ate sue"
                }
             },
             "should": {
                "match": {
                   "title.shingles": "the hungry alligator ate sue"
                }
             }
          }
       }
    }    
    ```