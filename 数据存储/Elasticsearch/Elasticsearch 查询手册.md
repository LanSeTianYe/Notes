时间： 2018-01-07 23:25:27 

参考： 

1. [QUERY DSL](https://www.elastic.co/guide/en/elasticsearch/reference/6.0/query-dsl.html) 

环境： 

1. Elasticsearch 6.0.0 
2. Win10 64位 

## 核心概念

* term frequency： 词频（TF），查询的单词在当前文档的查询段里面出现的频率，频率越高文档的相关性越高。

* inverse document frequency：逆向文档频率（IDF），查询的单词在查询的索引的所有文档里面出现的频率，频率越高相关性越低。

## 查询归纳

* match_all ：匹配所有文档

    ```json
    { "match_all": {}}
    ```
    
* 前缀查询（PrefixQuery）：根据单词前缀进行查询

    ```json
    "query": {"prefix" : { "user" : "ki" }}
    ```

* 通配符查询（WildcardQuery）：支持 `*` 匹配任意字符串，包含空。 `?` 匹配一个任意字符，查询速度慢。

    ```json
    "query": {"wildcard" : { "user" : { "value" : "ki*y", "boost" : 2.0 } }}
    ```

* `match` 查询:查询在底层会被分解成 `bool` 查询。

    Demo：
    
    ```json
    "query": {
        "match" : {
            "message" : "this is a test"
        }
    }
    ```

    可指定的选项：

    * operator: 部分匹配还是全部匹配，通过or或者and控制。
    * [minimum_should_match](https://www.elastic.co/guide/en/elasticsearch/reference/6.0/query-dsl-minimum-should-match.html) 数字百分比,负数表示总数减去负数的绝对值个。  
    * analyzer: 指定查询内容的分析器。默认使用字段的分析器。
    * lenient :宽容策略。 默认false，设置为true可以忽略查询内容和字段数据类型不匹配而导致的错误。
    * [fuzziness](https://www.elastic.co/guide/en/elasticsearch/reference/6.0/common-options.html#fuzziness) : 模糊查询，在 `text` 和 `keyword` 类型字段上使用。模糊的意思是一个单词经过多少少步变更之后可以变成另外一个单词。
    * zero_terms_query：零词项查询，查询的内容经过分析器变成空之后使用的查询方式（如：`am is are`），支持 `none<==>defaul all<==>match_all`。
    * cutoff_frequency：截断频率，指定频率超多多少的单词不用于相关性打分，可以是大于以的正整数或者(0-1)的百分比。 


* multi_match : 在多个字段上查询

    ```json
    "multi_match": {
        "query":    "full text search",
        "fields":   [ "title", "body" ]
    }
    ```

* range: 范围查询，作用于日期和数字。

    ```json
    "range": {
        "age": {
           "gte":  20,
           "lt":   30
        }
    }
    ```

* term：作用于精确值字段，如时间，数字，布尔或者不被分析的字段。 

    ```json
    { "term": { "age":    26           }}
    { "term": { "date":   "2014-09-01" }}
    { "term": { "public": true         }}
    { "term": { "tag":    "full_text"  }}
    ```

* terms

    ```json
    { "terms": { "tag": [ "search", "full_text", "nosql" ] }}
    ```

* exists 和 missing

    ```json
    "exists":   {"field":    "title"}
    ```

* [模糊查询](https://www.elastic.co/guide/en/elasticsearch/reference/6.0/common-options.html#fuzziness):查询 `text` 或者 `keyword` 的时候，模糊查询表示，一个单词经过[几步转换](https://en.wikipedia.org/wiki/Levenshtein_distance)可以转换为另外一个单词。可选值为 0，1，2。如果不指定则是AUTO。 
