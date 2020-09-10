时间：2019/1/21 17:14:36 

参考：  

## MongoDB 更新文档    

### 更新文档

1. 更新一个文档 

		# 更新 item 等于 paper 的第一个文档  
		db.inventory.updateOne(
		   { item: "paper" },
		   {
		     $set: { "size.uom": "cm", status: "P" },
		     $currentDate: { lastModified: true }
		   }
		)  
2. 更新多个文档

		db.inventory.updateMany(
		   { "qty": { $lt: 50 } },
		   {
		     $set: { "size.uom": "in", status: "P" },
		     $currentDate: { lastModified: true }
		   }
		)  
3. 替换一个文档 [文档地址](https://docs.mongodb.com/manual/reference/method/db.collection.replaceOne/#db.collection.replaceOne)

		db.restaurant.replaceOne(
		  { "name" : "Central Perk Cafe" },
		  { "name" : "Central Pork Cafe", "Borough" : "Manhattan" }
		);
### 更新命令

#### 字段操作  
* `$set` : 设置字段的值。 
* `$currentDate` : 设置字段的值为当前时间戳，如果不存在则创建字段。 

		$currentDate: { lastModified: true }
* `$inc` : 加上一个数。
* `$min` : 去两个值中最小的，当给定值小于字段的原始值时更新。
* `$max` : 去两个值中的最大的，当给定值大于字段的原始值时更新。
* `$mul` : 乘以给定的值。
* `$rename` : 字段重命名。
* `$setOnInsert` : 当插入文档时设置值。

		db.products.update(
		  { _id: 1 },
		  {
		     $set: { item: "apple" },
		     $setOnInsert: { defaultQty: 100 }
		  },
		  { upsert: true }
		)
* `$unset` : 删除指定的字段。

#### 数组操作  

* `$` : 更新数组的第一个元素。 

		# 更新数组中的第一个值  
		{ <update operator>: { "<array>.$: value } }
* `$[]` : 更新数组中的所有元素。
		
		# 更新数组中所有的值  
		{ <update operator>: { "<array>.$[]" : value } }

* **？**`$[]` : 更新数组中 element 为2。

		db.collection.update(
		   { myArray: [ 0, 1 ] },
		   { $set: { "myArray.$[element]": 2 } },
		   { arrayFilters: [ { element: 0 } ],
		     upsert: true }
		)
* `$addToSet` : 把元素添加到集合中，当且仅当集合中不存在对应元素时添加。
* `$pop` : 移除数组中的第一个或最后一个元素。

		db.students.update( { _id: 1 }, { $pop: { scores: 1 } } )
* `$pull` : 删除所有符合条件的元素。

		db.stores.update(
		    { },
		    { $pull: { fruits: { $in: [ "apples", "oranges" ] }, vegetables: "carrots" } },
		    { multi: true }
		)
* `$push` : 添加一个元素到数组中。

		db.students.update(
		   { _id: 1 },
		   { $push: { scores: 89 } }
		)
* `pullAll` : 删除数组中所有的指元素 

		# 删除 0 5 
		db.survey.update( { _id: 1 }, { $pullAll: { scores: [ 0, 5 ] } } )

#### 变更操作

* `$each` : 结合 `$push` 和 `$addToSet` 使用，添加元素到结合或数组中。

		# 添加元素到数组scores中
		db.students.update(
		   { name: "joe" },
		   { $push: { scores: { $each: [ 90, 92, 85 ] } } }
		) 
		# 添加元素到 tags 集合中
		db.inventory.update(
		   { _id: 2 },
		   { $addToSet: { tags: { $each: [ "camera", "electronics", "accessories" ] } } }
		)

* `$sort` : 排序数组中的元素。  

		# 添加元素并排序
		db.students.update(
		   { _id: 1 },
		   {
		     $push: {
		       quizzes: {
		         $each: [ { id: 3, score: 8 }, { id: 4, score: 7 }, { id: 5, score: 6 } ],
		         $sort: { score: 1 }
		       }
		     }
		   }
		)
* `$slice` : 限制数组元素个数 

		# 添加三个元素，并保留分数最高的三个
		db.students.update(
		   { _id: 5 },
		   {
		     $push: {
		       quizzes: {
		          $each: [ { wk: 5, score: 8 }, { wk: 6, score: 7 }, { wk: 7, score: 6 } ],
		          $sort: { score: -1 },
		          $slice: 3
		       }
		     }
		   }
		)

* `$position` : 指定位置用于向数组中添加元素。

		# 在地 0 个元素的地方添加
		db.students.update(
		   { _id: 1 },
		   {
		     $push: {
		        scores: {
		           $each: [ 50, 60, 70 ],
		           $position: 0
		        }
		     }
		   }
		)