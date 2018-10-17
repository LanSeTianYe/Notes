##  
时间：2017/8/20 17:29:31   

参考： 

1. [http://facebook.github.io/graphql/](http://facebook.github.io/graphql/)
2. [中文官网](http://graphql.cn/)
## GraphQL 简介

GraphQL 是一个用于 API 的查询语言，是一个使用基于类型系统来执行查询的服务端运行时（类型系统由你的数据定义）。GraphQL 并没有和任何特定数据库或者存储引擎绑定，而是依靠你现有的代码和数据支撑。

例子：查询用户id为4的用户的用户名

查询参数：  

	{
	  user(id: 4) {
	    name
	  }
	}

查询结果：

	{
	  "user": {
	    "name": "Mark Zuckerberg"
	  }
	}

### 设计原则     
 * 分层
 * 以产品为核心
 * 强类型
 * 客户端指定查询
 * 

## 为什么要用 GraphQL

## 怎么用 GraphQL

## 使用

