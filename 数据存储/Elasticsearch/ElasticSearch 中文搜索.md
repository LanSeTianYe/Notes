时间：2017-12-20 21:57:52 

参考：

1. [Smart Chinese Analysis plugin](https://www.elastic.co/guide/en/elasticsearch/plugins/current/analysis-smartcn.html)
2. [IK](https://github.com/medcl/elasticsearch-analysis-ik)

环境：

* 系统版本：Win10 64位 
* Elasticsearch版本:6.0.0

##  Elasticsearch 中文搜索 

###  中文分析器 smartcn 和 ik

smartcn 不支持自定以分析器

1. 进入bin目录执行下面命令安装插件，安装成功之后需要重启es。
        
    ```shell
    1. 安装 smartcn
    .\elasticsearch-plugin.bat install analysis-smartcn
    2. 安装 ik
    .\elasticsearch-plugin.bat install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v6.0.0/elasticsearch-analysis-ik-6.0.0.zip
    ```

    分析器: ik_smart , ik_max_word , token过滤器: ik_smart , ik_max_wor

2. 配置索引使用中文分析器（指定创建索引分析器和搜索分析器）。

    ```json
    DELETE animals
    
    PUT /animals
    {
        "mappings": {
            "human": {
                "properties": {
                    "about": {
                        "type":     "text",
                        "analyzer": "smartcn",
                        "search_analyzer": "smartcn"
                    }
                }
            }
        }
    }
    ```
    
3. 测试解析效果。

    使用汉语解析器：

    ```json
    GET /animals/_analyze
    {
      "field": "about", 
      "text": "如果有很多节点"
    }
    ```
    
    使用汉语解析器解析结果：

    ```json
    {
      "tokens": [
        {
          "token": "如果",
          "start_offset": 0,
          "end_offset": 2,
          "type": "word",
          "position": 0
        },
        {
          "token": "有",
          "start_offset": 2,
          "end_offset": 3,
          "type": "word",
          "position": 1
        },
        {
          "token": "很",
          "start_offset": 3,
          "end_offset": 4,
          "type": "word",
          "position": 2
        },
        {
          "token": "多",
          "start_offset": 4,
          "end_offset": 5,
          "type": "word",
          "position": 3
        },
        {
          "token": "节点",
          "start_offset": 5,
          "end_offset": 7,
          "type": "word",
          "position": 4
        }
      ]
    }
    ```
