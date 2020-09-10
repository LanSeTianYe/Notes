时间：2019/1/15 10:57:27 

## MongoDB 聚合查询

MongoDB 查询操作用于从 `Collection` 中查询出对应的文档信息。 

MongoDB 聚合查询用于数据统计和计算，一次聚合查询可以分为多个阶段，上一阶段的结果作为下一阶段的输入。  

### Pipleline 阶段

* [$match](https://docs.mongodb.com/manual/reference/operator/aggregation/match/): 根据条件过滤元素。

		db.articles.aggregate(
		    [ { $match : { author : "dave" } } ]
		);
* [$project](https://docs.mongodb.com/manual/reference/operator/aggregation/project/):用于控制传递拿些字段，以及增加字段 。

		# 条件控制
		db.books.aggregate( [
		   {
		      $project: {
		         title: 1,
		         "author.first": 1,
		         "author.last" : 1,
		         "author.middle": {
		            $cond: {
		               if: { $eq: [ "", "$author.middle" ] },
		               then: "$$REMOVE",
		               else: "$author.middle"
		            }
		         }
		      }
		   }
		] )
		# 字段截取
		db.books.aggregate(
		   [
		      {
		         $project: {
		            title: 1,
		            isbn: {
		               prefix: { $substr: [ "$isbn", 0, 3 ] },
		               group: { $substr: [ "$isbn", 3, 2 ] },
		               publisher: { $substr: [ "$isbn", 5, 4 ] },
		               title: { $substr: [ "$isbn", 9, 3 ] },
		               checkDigit: { $substr: [ "$isbn", 12, 1] }
		            },
		            lastName: "$author.last",
		            copiesSold: "$copies"
		         }
		      }
		   ]
		)
		# 数组
		db.collection.aggregate( [ { $project: { myArray: [ "$x", "$y" ] } } ] )

* [$facet](https://docs.mongodb.com/manual/reference/operator/aggregation/facet/)：多个阶段联合起来作为输出结果，可以实现对上一阶段的文档进行多维度的聚合。

		db.artwork.aggregate( [
		  {
		    $facet: {
		      "price": [
		        {
		          $bucket: {
		              groupBy: "$price",
		              boundaries: [ 0, 200, 400 ],
		              default: "Other",
		              output: {
		                "count": { $sum: 1 },
		                "artwork" : { $push: { "title": "$title", "price": "$price" } }
		              }
		          }
		        }
		      ],
		      "year": [
		        {
		          $bucket: {
		            groupBy: "$year",
		            boundaries: [ 1890, 1910, 1920, 1940 ],
		            default: "Unknown",
		            output: {
		              "count": { $sum: 1 },
		              "artwork": { $push: { "title": "$title", "year": "$year" } }
		            }
		          }
		        }
		      ]
		    }
		  }
		] )  

* [$addFields](https://docs.mongodb.com/manual/reference/operator/aggregation/addFields/) 添加字段，从现有字段中。

		db.scores.aggregate( [
		   {
		     $addFields: {
		       totalHomework: { $sum: "$homework" } ,
		       totalQuiz: { $sum: "$quiz" }
		     }
		   },
		   {
		     $addFields: { totalScore:
		       { $add: [ "$totalHomework", "$totalQuiz", "$extraCredit" ] } }
		   }
		] )

* [$bucket](https://docs.mongodb.com/manual/reference/operator/aggregation/bucket/): 把文档按指定的分组条件分成几个桶，并计算每个桶里面有几个元素。

		db.artwork.aggregate( [
		  {
		    $bucket: {
		      groupBy: "$price",
		      boundaries: [ 0, 200, 400 ],
		      default: "Other",
		      output: {
		        "count": { $sum: 1 },
		        "titles" : { $push: "$title" }
		      }
		    }
		  }
		] )
* [bucketAuto](https://docs.mongodb.com/manual/reference/operator/aggregation/bucketAuto/):自动分桶，并计算桶里面元素的个数。

		db.artwork.aggregate( [
		   {
		     $bucketAuto: {
		         groupBy: "$price",
		         buckets: 4
		     }
		   }
		] )
* [$group](https://docs.mongodb.com/manual/reference/operator/aggregation/group/):根据指定字段分组。

		# group by null 所有文档作为一个分组
		db.sales.aggregate(
		   [
		      {
		        $group : {
		           _id : null,
		           totalPrice: { $sum: { $multiply: [ "$price", "$quantity" ] } },
		           averageQuantity: { $avg: "$quantity" },
		           count: { $sum: 1 }
		        }
		      }
		   ]
		)

	内部支持的操作：

	* $addToSet：当前组的元素添加到集合，去重。
	* $push：分组的元素放到数组，不去重。
	* $avg：	计算当前组里面元素的平均值，非数字忽略。
	* $first：取分组里文档取第一个元素。
	* $last：取分组文档里最后一个元素。
	* $max：	取分组里的最大元素。
	* $min：	取分组里的最小元素。
	* $sum：	取分组元素的和。
	* $mergeObjects：合并分组里面的元素。

			{
			   $mergeObjects: [
			      { a: 1 },
			      { a: 2, b: 2 },
			      { a: 3, c: 3 }
			   ]
			}
	* $stdDevPop：标准差。

			db.users.aggregate([
			   { $group: { _id: "$quiz", stdDev: { $stdDevPop: "$score" } } }
			])
	* $stdDevSamp：计算样本标准差。

			db.users.aggregate(
			   [
			      { $sample: { size: 100 } },
			      { $group: { _id: null, ageStdDev: { $stdDevSamp: "$age" } } }
			   ]
			)

* [$sortByCount](https://docs.mongodb.com/manual/reference/operator/aggregation/sortByCount/)：根据数量排序。
* [$unwind](https://docs.mongodb.com/manual/reference/operator/aggregation/unwind/):拆分数组。

		{
		  $unwind:
		    {
		      path: <field path>,                      字段
		      includeArrayIndex: <string>,             新字段的名字，不指定则使用数组名字
		      preserveNullAndEmptyArrays: <boolean>    是否保留空值（没有数组字段，和对应值为空的都会保留）。
		    }
		}
* [$sort](https://docs.mongodb.com/manual/reference/operator/aggregation/sort/)：排序。

		{ $sort: { <field1>: <sort order>, <field2>: <sort order> ... } }

* [$skip](https://docs.mongodb.com/manual/reference/operator/aggregation/skip/): 跳过多少个元素。

		{ $skip: <positive integer> }

* [$limits](https://docs.mongodb.com/manual/reference/operator/aggregation/limit/): 限制返回数量。

		{ $limit: <positive integer> }
* [$count](https://docs.mongodb.com/manual/reference/operator/aggregation/count/): 计算上一阶段文档的数量。

		db.scores.aggregate([{ $count: "passing_scores" }])

* [$out](https://docs.mongodb.com/manual/reference/operator/aggregation/out/)：把结果存入到另外一个 `Collection` 中。

		db.books.aggregate( [
            { $group : { _id : "$author", books: { $push: "$title" } } },
            { $out : "authors" }
        ] )
* [$sample](https://docs.mongodb.com/manual/reference/operator/aggregation/sample/)：从输入文档中随机选择指定个数的文档。当指定个书大于实际文档个数时返回所有元素。

		db.users.aggregate(
		   [ { $sample: { size: 3 } } ]
		)
* [$replaceRoot](https://docs.mongodb.com/manual/reference/operator/aggregation/replaceRoot/): 替换根元素，用于把子文档升级成主文档。

		db.people.aggregate( [
		   {
		     $match: { pets : { $exists: true } }
		   },
		   {
		     $replaceRoot: { newRoot: "$pets" }
		   }
		] )
*　[$redact](https://docs.mongodb.com/manual/reference/operator/aggregation/redact/): 修剪文档。

	* $$DESCEND：保留，不保留包含的低级别的文档。
	* $$PRUNE:修剪。
	* $$KEEP：保留，如果文档不含低等级的文档，低等级的也会被包含。

	例子：

		# 
		db.forecasts.aggregate(
		   [
		     { $match: { year: 2014 } },
		     { $redact: {
		        $cond: {
		           if: { $gt: [ { $size: { $setIntersection: [ "$tags", [ "STLW", "G" ] ] } }, 0 ] },
		           then: "$$DESCEND",
		           else: "$$PRUNE"
		         }
		       }
		     }
		   ]
		);

* [$lookup](https://docs.mongodb.com/manual/reference/operator/aggregation/lookup/): 连接其它集合，类似于SQL的 join。

		db.orders.aggregate([
		   {
		     $lookup:
		       {
		         from: "inventory",
		         localField: "item",
		         foreignField: "sku",
		         as: "inventory_docs"
		       }
		  }
		])

* [$graphLookup](https://docs.mongodb.com/manual/reference/operator/aggregation/graphLookup/): 图查找。

		# 
		db.employees.aggregate( [
		   {
		      $graphLookup: {
		         from: "employees",
		         startWith: "$reportsTo",
		         connectFromField: "reportsTo",
		         connectToField: "name",
		         as: "reportingHierarchy"
		      }
		   }
		] )

* [$geoNear](https://docs.mongodb.com/manual/reference/operator/aggregation/geoNear/): 地理位置相关聚合。

* [$indexStats](https://docs.mongodb.com/manual/reference/operator/aggregation/indexStats/)：索引状态。

		db.orders.aggregate( [ { $indexStats: { } } ] )

* [$collStats](https://docs.mongodb.com/manual/reference/operator/aggregation/collStats/): 集合状态。

### [聚合操作](https://docs.mongodb.com/manual/reference/operator/aggregation/)  

在聚合阶段可以使用的操作符，用于聚合阶段的运算。

* `$setIntersection`：数组交集运算。

		{ $setIntersection: [ [ "a", "b", "a" ], [ "b", "a" ] ] }  -> [ "b", "a" ]

* `$abs` ：求绝对值。 
* `avg`： 求平均值。
* `$ceil`：进一。
* `$floor`: 去尾。
* `$divide`：除法。`{ $divide: [ <expression1>, <expression2> ] }`
* `$add` ：计算数组中元素的和，当其中一个元素为日期时，其它数字会被转化为毫秒。
* `$addToSet`: 将元素放入集合（去重）。
* `$push`：将元素放入数组（不去重）。
* `$allElementsTrue`: 判断数组和集合中的元素都是 true，包含 `false` `null` `undefined` `0` 返回false，其它返回true。
* `$and`：并操作，表达式都为true时返回true。
* `$anyElementTrue`: 表达式中有一个元素为true时返回true。
* `$arrayElemAt`：获取数组的指定位置上的元素。
* [$arrayToObject](https://docs.mongodb.com/manual/reference/operator/aggregation/arrayToObject/): 数组转换为对象。
* `$cmp`：比较两个元素的大小。 -1 、1、0。
* `$concat`：连接元素。`{ $concat: [ <expression1>, <expression2>, ... ] }`。
* `$concatArrays`：连接数组。
* `$cond`：条件判断。 `{ $cond: [ <boolean-expression>, <true-case>, <false-case> ] }`
* `$convert`：类型转换。
* `$dateFromParts`:将年月日转换为对应的日期。`{ $dateFromParts: { 'year' : 2017, 'month' : 14, 'day': 1, 'hour' : 12  } }`。
* `$dateToParts`：日期转换为年月日时分秒。
* `$dateFromString`：字符串转换为日期。
* `$dateToString`: 日期转换为字符串。
* `$dayOfMonth`：一月的第几天。
* `$dayOfWeek`：一周的第几天。
* `$dayOfYear` 一年的第几天。
* `$divide`:除法。
* `$eq`：是否相等。
* `$exp`: e 的n次方。
* `$filter`：用于过滤数组中的元素。
* `$first`：分组中的第一个文档。
* `$gt`：大于。
* `$gte`： 大于等于。
* `$hour`：日期的小时。
* `$ifNull`:如果表达式的结果为空，返回默认。  `$ifNull: [ "$description", "Unspecified" ]`
* `$in`: 判断元素是否存在于数组中。`{ $in: [ 2, [ 1, 2, 3 ] ] }`
* `$indexOfArray`：返回元素在数组中的坐标，没有返回 -1。`{ $indexOfArray: [ [ "a", "abc" ], "a" ] }`
* `$indexOfBytes`：字符在字符串中的位置。
* `$indexOfCP`：字符串在另一个字符串中的位置。
* `$isArray`:是否是数组。`{ $isArray: [ <expression> ] }`
* `$isoDayOfWeek`：一周的第几天。
* `$isoWeek`: 第几周。
* `$isoWeekYear`: 一年的第几周。
* `$last`：分组中的最后一个元素。
* `$let`: 定义变量。
* `$literal`: 字面含义，相当于转义操作。`{ $literal:  { $literal: 1 } } -> { "$literal" : 1 }`
* `$ln`: e 的对数。
* `$log`: 对数。`{ $log: [ <number>, <base> ] }`
* `$log10`：10的对数。
* `$lt`：小于。
* `$lte`: 小于等于。
* `$ltrim`：句首去除字符。`{ $ltrim: { input: <string>,  chars: <string> } }`，`chars: <string> }` 中的任意一个字符。
* `$map`：转换运算。类似于java流的map。
* `$max`：最大值。
* `$mergeObjects`: 合并对象。
* `$meta`: 元信息，如文档分数。
* `$min`：最小值。
* `$millisecond`: 毫秒数。
* `$minute`：第几分钟。
* `$mod`: 求余。
* `$month`：月。
* `$multiply`：乘法。
* `$ne`: 不等于。
* `$not`：非。
* `$objectToArray`: 对象转数组。转换成 k/v 格式。
* `$or`：或。
* `$pow`: x 的 n 次方。`{ $pow: [ 5, 0 ] }`
* `$push`: 加入数组。
* `$range`: 自动生成等差数组。`{ $range: [ <start>, <end>, <non-zero step> ] }`
* `$reduce`: 运算。

		# { "sum" : 15, "product" : 48 }
		{
		   $reduce: {
		      input: [ 1, 2, 3, 4 ],
		      initialValue: { sum: 5, product: 2 },
		      in: {
		         sum: { $add : ["$$value.sum", "$$this"] },
		         product: { $multiply: [ "$$value.product", "$$this" ] }
		      }
		   }
		}
* `$reverseArray`: 反转数组。
* `$rtrim`：句尾去除指定字符。
* `$second`:秒。
* `$setDifference`: 集合差集。
* `$setEquals`：集合是否相等。
* `$setIntersection`: 集合交集。
* `$setIsSubset`: 集合是否是另一个的子集。
* `$setUnion`: 集合并集。
* `$size`: 数组或集合的大小。
* `$slice`: 数组切割。
* `$split`: 字符串分割。
* `$sqrt`: 开方。
* `$stdDevPop`：标准差。
* `$stdDevSamp`: 样本标准差。
* `$strcasecmp`: 字符串比较。
* `$strLenBytes`：字符串的字节长度。
* `$strLenCP`：字符串的长度，一个汉字一个字节。
* `$substr`: 子字符串。
* `$substrBytes`:子字符串，utf字符中间分割会报错。
* `$substrCP`:子字符串。
* `$subtract`：减法。
* `$sum`：求和。每个分组中文档个数 `count: { $sum: 1 }`。
* `$switch`:条件选择。

		{
		   $switch: {
		      branches: [
		         { case: { $eq: [ 0, 5 ] }, then: "equals" },
		         { case: { $gt: [ 0, 5 ] }, then: "greater than" },
		         { case: { $lt: [ 0, 5 ] }, then: "less than" }
		      ]
		   }
		}
* `$toBool`:转换为boolean值。
* `$toDate`: 转换为日期。
* `$toDecimal`:转换为10进制数字。
* `$toDouble`: 转换为double类型。
* `$toInt`:
* `$toLong`:
* `$toObjectId`:
* `$toString`:
* `$toLower`:
* `$toUpper`:
* `$trim`:去除句首句尾的字符。
* `$trunc`:去尾。
* `$type`:字段类型。
* `$week`:周
* `$year`：年
* `$zip`:矩阵转置。

## 聚合查询的一个例子  

	db.getCollection("statistics_data").aggregate([
	    { "$match": { "source": 1, "dealerInfo.dealerId": 10000, "createTimeDay": { "$gte": 1548086400000, "$lte": 1548086400000 } } },
	    {
	        "$project":
	            {
	                "createTimeHour": 1,
	                "createTimeDay": 1,
	                "clueInfo": 1,
	                "platformType": 1,
	                "serialName": "$carInfo.serialName",
	                "organizationType": "$dealerInfo.organizationType",
	                "orgId": "$dealerInfo.orgId",
	                "dealerId": "$dealerInfo.dealerId",
	                "dealerName": "$dealerInfo.dealerFullName",
	                "provinceName": "$dealerInfo.provinceName",
	                "provinceId": "$dealerInfo.provinceId",
	                "cityName": "$dealerInfo.cityName",
	                "cityId": "$dealerInfo.cityId",
	                "clue_flag": { "$cond": { "if": { "$eq": ["$operationType", 400] }, "then": 1, "else": 0 } },
	                "share_flag": { "$cond": { "if": { "$eq": ["$operationType", 300] }, "then": 1, "else": 0 } },
	                "view_flag": { "$cond": { "if": { "$eq": ["$operationType", 200] }, "then": 1, "else": 0 } },
	                "open_flag": { "$cond": { "if": { "$eq": ["$operationType", 100] }, "then": 1, "else": 0 } },
	                "share_person": { "$cond": { "if": { "$eq": ["$operationType", 300] }, "then": "$wxUserInfo.openId", "else": "$$REMOVE" } },
	                "open_person": { "$cond": { "if": { "$eq": ["$operationType", 100] }, "then": "$wxUserInfo.openId", "else": "$$REMOVE" } }
	            }
	    },
	    {
	        "$group":
	            {
	                //四个依次是 小时 天 车系 经销商
	                "_id": "$createTimeHour",
	                //"_id": "$createTimeDay",
	                //"_id": "$serialName",
	                //"_id": "$dealerName",
	                //"_id": "$provinceName",
	                "createTimeHour": { "$first": "$createTimeHour" },
	                "createTimeDay": { "$first": "$createTimeDay" },
	                "dealerId": { "$first": "$dealerId" },
	                "dealerName": { "$first": "$dealerName" },
	                "provinceId": { "$first": "$provinceId" },
	                "provinceName": { "$first": "$provinceName" },
	                "clueCount": { "$sum": "$clue_flag" },
	                "shareTimes": { "$sum": "$share_flag" },
	                "openTimes": { "$sum": "$open_flag" },
	                "openUserSet": { "$addToSet": "$open_person" },
	                "shareUserSet": { "$addToSet": "$share_person" }
	            }
	    },
	    {
	        "$project":
	            {
	                "title": "$_id",
	                "createTimeHour": 1,
	                "createTimeDay": 1,
	                "dealerId": 1,
	                "dealerName": 1,
	                "provinceId": 1,
	                "provinceName": 1,
	                "clueCount": 1,
	                "shareTimes": 1,
	                "openTimes": 1,
	                "convertRate": { "$divide": [{ "$toDouble": "$clueCount" }, { "$toDouble": "$openTimes" }] },
	                "accessUserCount": { "$size": ["$openUserSet"] },
	                "shareUserCount": { "$size": ["$shareUserSet"] }
	            }
	    },
	    { "$sort": { "title": -1 } },
	    { "$skip": 0 },
	    { "$limit": 20 }
	])                           