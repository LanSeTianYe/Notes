时间：2017-12-21 14:29:00 

参考：

1. [Elasticsearch: 权威指南](https://elasticsearch.cn/book/elasticsearch_definitive_guide_2.x/index.html)

环境：

* 系统版本：Win10 64位 
* Elasticsearch版本:6.0.0

## 简单介绍

### 是什么？ 

分布式的文档存储和检索引擎。可以存储非结构化数据数据以及对存储数据进行复杂的搜索。

**核心概念：**

* 索引、类型、id：索引是一个大分类，用于归类文档，类型在新版本已经取消（一个索引下存储的文件结构尽可能相似），id是一个具体文档的标志。
* 主分片、副分片：主分片用于存放数据，副分片时主分片的复制。
* 倒排索引：快速查找哪个文档里面有哪个个字段的数据结构，记录一个词项出现在哪个文档。

    ```json
    Term      Doc_1  Doc_2
    -------------------------
    Quick   |       |  X
    The     |   X   |
    brown   |   X   |  X
    dog     |   X   |
    dogs    |       |  X
    fox     |   X   |
    foxes   |       |  X
    in      |       |  X
    jumped  |   X   |
    lazy    |   X   |  X
    leap    |       |  X
    over    |   X   |  X
    quick   |   X   |
    summer  |       |  X
    the     |   X   |
    ------------------------
    ```
    
* 映射：文档字段的数据类型
* 分析与分析器：

    * 字符过滤器：首先，字符串按顺序通过每个 字符过滤器 。他们的任务是在分词前整理字符串。一个字符过滤器可以用来去掉HTML，或者将 & 转化成 `an
    * 分词器：其次，字符串被 分词器 分为单个的词条。一个简单的分词器遇到空格和标点的时候，可能会将文本拆分成词条。
    * Token 过滤器：最后，词条按顺序通过每个 token 过滤器 。这个过程可能会改变词条（例如，小写化 Quick ），删除词条（例如， 像 a`， `and`， `the 等无用词），或者增加词条（例如，像 jump 和 leap 这种同义词）。
* 游标查询：指定数据的条目，查询结果会包含一个游标，使用这一个游标可以查询除了前面已经查询过的数据。

    * 查询语法（游标保留时间1分钟）：
    
    ````json
    GET /old_index/_search?scroll=1m 
    {
        "query": { "match_all": {}},
        "sort" : ["_doc"], 
        "size":  1000
    }
    ```
    
    * 查询下一批数据

    ```json
    GET /_search/scroll
    {
        "scroll": "1m", 
        "scroll_id" : "cXVlcnlUaGVuRmV0Y2g7NTsxMDk5NDpkUmpiR2FjOFNhNnlCM1ZDMWpWYnRROzEwOTk1OmRSamJHYWM4U2E2eUIzVkMxalZidFE7MTA5OTM6ZFJqYkdhYzhTYTZ5QjNWQzFqVmJ0UTsxMTE5MDpBVUtwN2lxc1FLZV8yRGVjWlI2QUVBOzEwOTk2OmRSamJHYWM4U2E2eUIzVkMxalZidFE7MDs="
    }
    ```

### 可以做什么？

1. 日志分析。
2. 地理位置范围查询。
3. 文档查询，以及评分。
4. 聚合统计，分析数据。
