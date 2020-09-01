时间：2019/4/28 12:31:48  

参考： 

1. [https://graphql.org/learn/schema/](https://graphql.org/learn/schema/) 

## 模式 `schema`  

类似于JSON。使用 `schema` 定义对象类型，查询方法，变更方法等。
	
	type Query {
	  me: User
	}
	
	type User {
	  id: ID
	  name: String
	}     

## 类型系统 `type`

定义服务提供的查询数据。

### 标量类型   

类似编程语言的基本类型，在查询中 `非标量类型` 需要服务端查询以获取数据，`标量类型` 类似于对象的字段，不需要进一步查询。

#### 默认标量类型  

* `Int`：32 位整型（有符号）。
* `Float`：双精度浮点类型（有符号）。
* `String`： `UTF-8` 类型的字符串。
* `Boolean`: `true` or `false`。
* `ID`：唯一标识符。

#### 自定义标量类型

需要实现类型的序列化、反序列化和数据验证。  

	scalar Date

#### 枚举类型

类型的值只能是定义中的一个。

	enum Sex {
	  MAN
	  WOMAN
	  OTHER
	}

#### 列表和非空 

	type Character {
	  name: String!
	  appearsIn: [Episode]!
	}

该定义表示：在服务端，`name` 字段总是非空的，如果为空，客户端查询会收到一个异常。 `[]` 表示返回的结果是一个非空的数组。

列表及列表元素非空的情况：

* `[Object!]`: 列表可以为空，但列表不可以包含空对象。
* `[Object]!`: 列表不可以为空，但列可以包含空对象。
* `[Object!]!`: 列表不能为空，列表也不能包含空对象。

注：`null` 表示空，列表的大小为零并不表示列表为空。

#### 接口  

接口是一种抽象类型，接口的实现需要包含接口的所有字段。在查询时如果两个对象实现了同一个接口，可以通过指定查询接口类型，服务端返回的结果会包含所有实现该接口的类型的数据。在查询端可以根据不同的类型取不同的字段。

接口定义：

	interface Character {
	  id: ID!
	  name: String!
	  friends: [Character]
	  appearsIn: [Episode]!
	}

接口实现：

	type Human implements Character {
	  id: ID!
	  name: String!
	  friends: [Character]
	  appearsIn: [Episode]!
	  starships: [Starship]
	  totalCredits: Int
	}
	
	type Droid implements Character {
	  id: ID!
	  name: String!
	  friends: [Character]
	  appearsIn: [Episode]!
	  primaryFunction: String
	}
查询语句：

	query HeroForEpisode($ep: Episode!) {
	  hero(episode: $ep) {
	    name
	    ... on Droid {
	      primaryFunction
	    }
		... on Human{
		  totalCredits
		}
	  }
	}

查询的时候，如果返回的类型是 `Droid` 就取 `primaryFunction` 字段，如果是 `Human`，就取 `totalCredits` 字段。

#### 联合类型  

类似于接口，返回的结果会包含指定的类型，但不要求每个类型都有相同的字段。

	union SearchResult = Human | Droid | Starship

客户端查询语法：

	{
	  search(text: "an") {
	    __typename
	    ... on Character {
	      name
	    }
	    ... on Human {
	      height
	    }
	    ... on Droid {
	      primaryFunction
	    }
	    ... on Starship {
	      name
	      length
	    }
	  }
	}

#### 输入类型  

输入类型常用于数据变更操作。

	input ReviewInput {
	  stars: Int!
	  commentary: String
	}

客户端语句：

	mutation CreateReviewForEpisode($ep: Episode!, $review: ReviewInput!) {
	  createReview(episode: $ep, review: $review) {
	    stars
	    commentary
	  }
	}



   