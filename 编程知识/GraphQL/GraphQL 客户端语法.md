时间：2019/4/28 22:39:28

参考：

1. [Queries and Mutations](https://graphql.github.io/learn/queries/)   

## 语法  

客户端只需要写出正确的的查询语句，`GraphQL Playground` 等工具提供语法提示和从服务端获取文档的功能。服务端解析并查询语句并根据服务端的查询网络定义返回对应的数据。

查询和变更数据的区别是：**查询语句里面的多个查询操作并行执行的，变更语句里面的操作串行执行。**

通过增加 `__typename` 可以返回数据的具体类型。

### 查询语句  

1. 无参数查询。 

		{			
		  hero {       
		    name  
		  }
		}

2. 关联查询。

		{
		  hero {
		    name
			# 关联另一个查询
		    friends {
		      name
		    }
		  }
		}

3. 有参数查询。  
		
		{
		  human(id: "1000") {
		    name
		    height
		  }
		}

4. 片段， `Book` 必须是服务端定义的类型。

		fragment nameAndAge on Book {
			name
		  	pageCount
		} 

5. 支持字段别名。
6. 变量和片段。 
		
		query HeroComparison($first: Int = 3) {
		  leftComparison: hero(episode: EMPIRE) {
		    ...comparisonFields
		  }
		  rightComparison: hero(episode: JEDI) {
		    ...comparisonFields
		  }
		}
		
		fragment comparisonFields on Character {
		  name
		  friendsConnection(first: $first) {
		    totalCount
		    edges {
		      node {
		        name
		      }
		    }
		  }
		}
7. 从实际类型获取数据，当数据是 `Droid` 时返回 `primaryFunction`，当数据是 `Human` 时返回 `height`。

		query HeroForEpisode($ep: Episode!) {
		  hero(episode: $ep) {
		    name
		    ... on Droid {
		      primaryFunction
		    }
		    ... on Human {
		      height
		    }
		  }
		}
		# 变量 
		{
			"ep": "JEDI"
		}
8. 返回实际类型。 

		{
		  search(text: "an") {
		    __typename
		    ... on Human {
		      name
		    }
		    ... on Droid {
		      name
		    }
		    ... on Starship {
		      name
		    }
		  }
		} 

### 变量   

变量可以是标准类型、枚举或 `input` 需要从服务器获取。

* `Episode=Jndi` 指定默认值。
* `!` 表明变量不能为空，默认可选。

#### 变量用法   
1. 使用变量。

		# 查询语句
		query HeroNameAndFriends($episode: Episode=Jndi, $name:Name!) {
		  hero(episode: $episode) {
		    name !
		    friends {
		      name
		    }
		  }
		}
		# 变量 
		{
		  "episode": "JEDI"
		}
2. 指令，动态包含字段，`GraphQL` 定义了两个所有规范都必须实现的指令 `@include(if: Boolean)` 和 `@skip(if: Boolean)`。

		query Hero($episode: Episode, $withFriends: Boolean!) {
		  hero(episode: $episode) {
		    name
		    friends @include(if: $withFriends) {
		      name
		    }
		  }
		}
		# 参数
		{
		  "episode": "JEDI",
		  "withFriends": false
		}

## 变更数据  

1. 新增，并获取新增的结果。

		mutation CreateReviewForEpisode($ep: Episode!, $review: ReviewInput!) {
		  createReview(episode: $ep, review: $review) {
		    stars
		    commentary
		  }
		}
		# 参数
		{
		  "ep": "JEDI",
		  "review": {
		    "stars": 5,
		    "commentary": "This is a great movie!"
		  }
		}