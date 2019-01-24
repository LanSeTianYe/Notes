时间：2019/1/14 11:22:49   

参考：

1. [bson-types](https://docs.mongodb.com/manual/reference/bson-types/)  

## mongodb 查询手册   

**查询语法：** 

* `{ <field1>: <value1>, ... }`  
* `{ <field1>: { <operator1>: <value1> }, ... }`

**限制返回字段：**

	# 返回指定的字段
	db.inventory.find({ status: "A" }, { item: 1, status: 1, "instock.qty": 1 })
	# 返回指定字段之外的字段		
	db.inventory.find( { status: "A" }, { status: 0, instock: 0 } )
`1` 表示返回该字段，当字段是子文档是返回子文档所有字段，可以通过 `.` 语法只返回需要的字段，数组包含子文档类似。 

## 通用查询
  
1. 根据一个或多个字段查询 `and`   

		db.user.find({ age: "18", name: "liujs" })  
2. or 查询 

		db.user.find({ $or: [{ age: "20" }, { name: "liujs" }] })
3. in 查询

		db.getCollection("inventory").find({ tags: { $in: ['cotton', 'blue'] } })   
3. 比较查询 `$gt` `$gte` `$lt` `$lte` `$ne` `$eq` `$in` `$nin`

		db.statistics_data.find({ platformType: { $gte: 101 } }).limit(2)
		db.col.find({ "likes": { $gt: 100, $lt: 1000 } })
4. and 和 or 结合使用 

		db.inventory.find( { $and: [ { price: { $ne: 1.99 } }, { price: { $exists: true } } ] } )
		db.statistics_data.find({ platformType: { $gte: 101 }, $or: [{ operationType: 100 }]} )
		# 
		db.inventory.find( {
		     status: "A",
		     $or: [ { qty: { $lt: 30 } }, { item: /^p/ } ]
		} )
		# 等价SQL
		SELECT * FROM inventory WHERE status = "A" AND ( qty < 30 OR item LIKE "p%")
5. 数组查询，查询数组中包含 `mongodb` 的数据    

		# 查询标签只包含 blank  和 red，且顺序为 ["blank", "red"]
		db.getCollection("inventory").find({ tags: ["blank", "red"] })
		# 查询tag包含 cotton 和 red 任意一个文档
		db.getCollection("inventory").find({ tags: { $in: ["cotton", "red"] } })
		# 查询所有tag包含 `red` 和 `blank` 的文档
		db.inventory.find( { tags: { $all: ["red", "blank"] } } )
		# 查询 tag 包含 red 的文档 
		db.inventory.find( { tags: "red" } )
		# 查询数组中有元素大于 25 的文档
		db.inventory.find({ dim_cm: { $gt: 25 } })
		# 查询数组中有元素满足 大于等于15 小于等于20 可以是多个元素组合满足该条件 
		db.inventory.find( { dim_cm: { $gt: 15, $lt: 20 } } )
		# 查询至少有一个元素同时满足大于等于和小于等于条件 
		db.inventory.find( { dim_cm: { $elemMatch: { $gt: 22, $lt: 30 } } } )
		# 查询数组中第二个元素大于25的文档 
		db.inventory.find( { "dim_cm.1": { $gt: 25 } } )
		# 查询数组元素个数等于三的文档 
		db.inventory.find({ "tags": { $size: 3 } })  
		# 查询数组里面的子文档，有满足条件的子文档 （顺序，个数）
		db.inventory.find( { "instock": { warehouse: "A", qty: 5 } } )
		# 查询数组里面的子文档，有 `qty` 小于20的文档
		db.inventory.find( { 'instock.qty': { $lte: 20 } } )
		# 数组里面第一个元素的 qty 小于20的文档
		db.inventory.find({ 'instock.0.qty': { $lte: 20 } })
 		# 查询数组里面有一个元素满足下面条件
		db.inventory.find({ "instock": { $elemMatch: { qty: 5, warehouse: "A" } } }) 
		# 查询数组里面有一个元素满足下面条件
		db.inventory.find({ "instock": { $elemMatch: { qty: { $gt: 10, $lte: 20 } } } }) 
		# 查询数组中有元素满足 大于等于15 小于等于20 可以是多个元素组合满足该条件 
		db.inventory.find({ "instock.qty": { $gt: 10, $lte: 20 } })   
		# 查询数组中有元素满足下面条件，可以是多个元素组合满足
		db.inventory.find({ "instock.qty": 5, "instock.warehouse": "A" }) 

6. 嵌套文档查询。 

		# 查询指定字段
		db.getCollection("inventory").find({ "size.h": { $eq: 28 } })
		# 查询条件字段顺序必须和嵌套文档的字段顺序一致
		db.inventory.find( { size: { h: 14, w: 21, uom: "cm" } } )
7. 空值查询

		# 查询 item 字段为空 或 没有item字段的文档 
		db.inventory.find({ item: null })	
		# 查询 item 字段类型为 null（10）的文档 double(1) string(2)
		db.inventory.find( { item : { $type: 10 } } )
		# 字段是否存在 
		db.inventory.find( { item : { $exists: false } } )
 
8. 类型查找 `$type`  

		db.col.find({ "title": { $type: "string" } })
9. `limit` 查询多少条记录，`ship` 跳过多少条。

		db.col.find({}).limit(2).skip(1)
10. `sort` 排序(1 正序，-1 倒序）

		db.col.find({}).sort({ "likes": -1 })

## 文本正则查询   

MongoDB 使用 `Perl` 兼容的正则语法。正则用于字符串匹配。

**正则匹配语法：**

	{ <field>: { $regex: /pattern/, $options: '<options>' } }
	{ <field>: { $regex: 'pattern', $options: '<options>' } }
	{ <field>: { $regex: /pattern/<options> } }

**选项：options:**

* `i`：大小写不敏感。
* `x`: 忽略正则中的空白字符。
* `m`: 允许定位行首行尾，`^` 行首，`$` 行尾。
* `s` : 允许 `.` 匹配任意字符。

## 查询和规划操作符  


* `$slice` : 限制返回的数组中的元素个数，整数表示前面几个，负数表示后面几个。

		# 跳过20个元素，之后取10个元素，也支持倒着跳
		db.posts.find( {}, { comments: { $slice: [ 20, 10 ] } } )
* `$meta` : 返回源信息，如文档匹配的分数。

		db.inventory.find(
		    { item: { $regex:/p/i} },
		    { score: { $meta: "textScore" } }
		)
* `$elemMatch` : 数组中的单个元素满足匹配条件。

		db.inventory.find({ "instock": { $elemMatch: { qty: 15, warehouse: "C" } } })

* `$` : 只返回数组中的第一个元素，如果查询包含数组过滤条件，则返回匹配的元素中的第一个元素。

		db.students.find(
		    { semester: 1, grades: { $gte: 85 } },
		    { "grades.$": 1 }
		)
