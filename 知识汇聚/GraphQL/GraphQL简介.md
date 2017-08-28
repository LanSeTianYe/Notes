##  
时间：2017/8/20 17:29:31   

参考： 

1. [http://facebook.github.io/graphql/](http://facebook.github.io/graphql/)

## GraphQL 简介

GraphQL 是Facebook在2012年创建的描述客户端-服务器应用程序的数据模型能力和要求的查询语言。语言的标准定制开始于2015年。GraphQL 是一种规范。

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

