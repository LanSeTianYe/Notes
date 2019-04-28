时间：2017/8/20 17:29:31
   
## 简介  

`GraphQL` 是 `Facebook` 提出的一种查询语言。通过语言定义查询的规范。服务端通过编程语言根据定义的规范构造查询网络，为每个需要数据的地方提供数据源。客户端可以通过相应的查询语法编写查询语句，服务端根据对应的查询动态的生成查询结果。

**定义数据结构：**

	type Project {
	  name: String
	  tagline: String
	  contributors: [User]
	}

**定义查询语句：**

	{
	  project(name: "GraphQL") {
	    tagline
	  }
	}

**动态返回结果：**

	{
	  "project": {
	    "tagline": "A query language for APIs"
	  }
	}

## 工具

### 官网  

1. [https://graphql.org/](https://graphql.org/)  

### 实现  

* JAVA： [Graphql-Java](https://www.graphql-java.com/documentation/v12/) Java 语言实现。


### 模拟客户端  

1. [GraphQL Playground](https://github.com/prisma/graphql-playground) :
 
	* 获取服务端的查询定义。
	* 查询语法高亮提示。
	* 语法提示。
	* 不同操作系统桌面版。

2. [Idea GraphQL 插件](https://jimkyndemeyer.github.io/js-graphql-intellij-plugin/docs/developer-guide)：

	* 编写和执行查询语句。
	* 支持获取远端接口定义。

