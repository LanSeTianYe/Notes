时间：2018/1/18 10:55:56    
   
参考：  
 
1. [MongoDB TutorialsMongoDB Tutorials](https://docs.mongodb.com/manual/tutorial/)

环境： 
 
1. win 10
2. MongoDB 3.6.2 Community
3. python

##  查询总结   
### 插入数据

1. 插入一条数据，集合不存在自动创建  

		db.get_collection("inventory").insert_one(
		    {
		        "item": "canvas",
		        "qty": 100,
		        "tags": ["cotton"],
		        "size": {"h": 28, "w": 35.5, "uom": "cm"}
		    })
2. 批量插入，集合不存在自动创建   

		//数据1
		db.get_collection("inventory").insert_many([
		   # MongoDB adds the _id field with an ObjectId if _id is not present
		   { "item": "journal", "qty": 25, "status": "A",
		       "size": { "h": 14, "w": 21, "uom": "cm" }, "tags": [ "blank", "red" ] },
		   { "item": "notebook", "qty": 50, "status": "A",
		       "size": { "h": 8.5, "w": 11, "uom": "in" }, "tags": [ "red", "blank" ] },
		   { "item": "paper", "qty": 100, "status": "D",
		       "size": { "h": 8.5, "w": 11, "uom": "in" }, "tags": [ "red", "blank", "plain" ] },
		   { "item": "planner", "qty": 75, "status": "D",
		       "size": { "h": 22.85, "w": 30, "uom": "cm" }, "tags": [ "blank", "red" ] },
		   { "item": "postcard", "qty": 45, "status": "A",
		       "size": { "h": 10, "w": 15.25, "uom": "cm" }, "tags": [ "blue" ] }
		])
		//数据2
		db.inventory.insert_many([
		        {"item": "journal", "qty": 25, "tags": ["blank", "red"], "dim_cm": [14, 21]},
		        {"item": "notebook", "qty": 50, "tags": ["red", "blank"], "dim_cm": [14, 21]},
		        {"item": "paper", "qty": 100, "tags": ["red", "blank", "plain"], "dim_cm": [14, 21]},
		        {"item": "planner", "qty": 75, "tags": ["blank", "red"], "dim_cm": [22.85, 30]},
		        {"item": "postcard", "qty": 45, "tags": ["blue"], "dim_cm": [10, 15.25]}
		    ])
		//数据3
		db.inventory.insert([{"item": None}, {}])

### 查询数据  
0. 使用 Python
	
		import gridfs
		import pymongo

1. 普通集合查询  

		# 查询全部
		db.get_collection("inventory").find()
		# 查询指定值
		db.get_collection("inventory").find({"status": "D"})
		# or
		db.get_collection("inventory").find({"$or": [{"status": "D"}, {"qty": 75}]})
		# and
		db.get_collection("inventory").find({"$and": [{"status": "D"}, {"qty": 75}]})
		db.get_collection("inventory").find({"status": "D", "qty": 75})
		# 嵌套查询，匹配一个属性
		db.get_collection("inventory").find({"size.h": 14})
		# 嵌套查询，size的所有属性必须匹配，顺序也要和原始文档相同
		db.get_collection("inventory").find({"size": {"h": 14, "w": 21, "uom": "cm"}})
		# 数组查询，匹配数组里面的一个元素
		db.get_collection("inventory").find({"tags": "red"})
		# 数组查询，匹配数组里面的多个元素，顺序可变
		db.get_collection("inventory").find({"tags": ["red", "blank"]})
		# 数组查询，匹配只包含 red 和 blank 的文档
		db.get_collection("inventory").find({"tags": {"$all": ["red", "blank"]}})
		# 数组查询，查询 dim_ct 包含大于25的元素的文档
		db.get_collection("inventory").find({"dim_cm": {"$gt": 25}})
		# 数组查询，查询 dim_cm 包含大于15小于小于20的元素的文档
		db.get_collection("inventory").find({"dim_cm": {"$gt": 15, "$lt": 20}})
		# 数组查询，匹配 dim_cm 里面，一个元素同时满足两个条件的文档 
		db.get_collection("inventory").find({"dim_cm": {"$elemMatch": {"$gt": 22, "$lt": 30}}})
		# 数组查询，匹配数组里面第一个元素，满足条件的文档
		db.get_collection("inventory").find({"dim_cm.1": {"$gt": 25}})
		# 数组查询，匹配数组大小为3的文档
		db.get_collection("inventory").find({"tags": {"$size": 3}})
		# in查询 
		db.get_collection("inventory").find({"status": {"$in": ["A", "D"]}})	
		# and和or查询结合
		db.get_collection("inventory").find({"status": "A", "$or": [{"qty": {"$lt": 30}}, {"item": {"$regex": "^p"}}]})
		# 限制返回字段，只返回 status 和 item 字段
		db.get_collection("inventory").find({"status": "D", "qty": 75}, {"item": 1, "status": 1})
		# 限制返回字段，返回item、size.h以及数组的前两个元素
		db.get_collection("inventory").find({"status": "D"}, {"item": 1, "size.h": 1, "tags": {"$slice": 2}})
		# 空查询，返回字段值是空和不包含该字段的文档 
		db.get_collection("inventory").find({"item": None})
		# 空查询，只返回包含该字段且字段值是空的文档， 10对应的是 Null
		db.get_collection("inventory").find({"item": {"$type": 10}})
		# 字段存在与否查询，返回不包含item字段的文档 
		db.get_collection("inventory").find({"item": {"$exists": False}})

2. 固定大小集合查询  

		# 以插入顺序的逆序返回结果
		db.cappedCollection.find().sort( { $natural: -1 } )
### 更新数据      

1. 更新一条数据。更新第一条匹配的数据，`$set` 设置新的值，`$currentDate` 设置为当前日期。

		db.get_collection("inventory").update_one(
		    {"item": "paper"},
		    {"$set": {"size.uom": "cm", "status": "P"}, "$currentDate": {"lastModified": True}})
2. 更新多条数据，更新所有匹配的数据。
		
		db.get_collection("inventory").update_many(
		    {"item": "paper"},
		    {"$set": {"size.uom": "cm", "status": "P"}, "$currentDate": {"lastModified": True}})
3. 替换整个文档。 

		db.inventory.replace_one(
		    {"item": "paper"},
		    {"item": "paper",
		     "instock": [
		         {"warehouse": "A", "qty": 60},
		         {"warehouse": "B", "qty": 40}
		     ]
		     }
		)

注： 指定upsert选项为True，当文档不存在的时候会插入文档。默认为False。

### 删除数据
 
1. 删除所有(直接删除集合效率更高)。  
 
		db.get_collection("inventory").delete_many({}) 
2. 根据条件删除。

		db.get_collection("inventory").delete_many({"status": "A"})
3. 删除第一个匹配的。

		db.get_collection("inventory").delete_one({"status": "D"})

### 批量操作  

    requests = list();
    requests.append(InsertOne({"name": "x", "age": 23}))
    requests.append(InsertOne({"name": "x", "age": 23}))
    requests.append(InsertOne({"name": "x", "age": 25}))
    requests.append(UpdateOne({"name": "x"}, {"$set": {"age": 25}}))
    requests.append(UpdateMany({"name": "x"}, {"$set": {"age": 24}}))
    requests.append(ReplaceOne({"name": "x"}, {"name": "x", "age": 23, "sex": "man"}))
    requests.append(DeleteOne({"name": "x"}))
    requests.append(DeleteMany({"name": "x"}))
    result = db.get_collection("test").bulk_write(requests)
    print("bulk API", result.bulk_api_result, sep=" : ")
### [文本搜索](https://docs.mongodb.com/manual/text-search/) (需要创建索引)  

1. 插入数据

		db.get_collection("stores").insert_many(
		        [
		            {"name": "Java Hut", "description": "Coffee and cakes"},
		            {"name": "Burger Buns", "description": "Gourmet hamburgers"},
		            {"name": "Coffee Shop", "description": "Just coffee"},
		            {"name": "Clothes Clothes Clothes", "description": "Discount clothing"},
		            {"name": "Java Shopping", "description": "Indonesian goods"}
		        ]
		    )
2. 创建索引，一个集合只允许创建一个文本索引，可以是多个字段。 
	
	    index = IndexModel([("name", pymongo.TEXT), ("description", pymongo.TEXT)], name="name_description")
	    db.get_collection("stores").create_indexes([index])
3. 文本搜索  
		
		# 搜索 name 和 description 包含 java coffee shop三个单词的文本
		db.get_collection("stores").find({"$text": {"$search": "java coffee shop"}})
		# 搜索 name 和 description 包含 java 以及 "coffee shop" 短语的文本
		db.get_collection("stores").find({"$text": {"$search": "java coffee shop"}})  
	    # 排除单词
	    result = db.get_collection("stores").find({"$text": {"$search": "java -coffee shop"}})
		# 相关性评分
	    result = db.get_collection("stores").find(
	        {"$text": {"$search": "java coffee shop"}},
	        {"score": {"$meta": "textScore"}}
	    ).sort([("score", {"$meta": "textScore"})])
### [地理位置搜索](https://docs.mongodb.com/manual/geospatial-queries/)

1. 初始化数据。   

		db.get_collection("places").insert({
		        "name": "Central Park",
		        "location": {
		            "type": "Point",
		            "coordinates": [-73.97, 40.77]
		        },
		        "category": "Parks"
		    })
		    db.get_collection("places").insert({
		        "name": "Sara D. Roosevelt Park",
		        "location": {
		            "type": "Point",
		            "coordinates": [-73.9928, 40.7193]
		        },
		        "category": "Parks"
		    })
		    db.get_collection("places").insert({
		        "name": "Polo Grounds",
		        "location": {
		            "type": "Point",
		            "coordinates": [-73.9375, 40.8303]
		        },
		        "category": "Stadiums"
		    })

2. 创建 `GEOSPHERE` 索引

	    index = IndexModel([("location", pymongo.GEOSPHERE)], name="location_2ds")
	    db.get_collection("places").create_indexes([index])
3. 查询，距离在指定范围之间。

	    result = db.get_collection("places").find({
	        "location": {
	            "$near": {
	                "$geometry": {"type": "Point", "coordinates": [-73.9667, 40.78]},
	                "$minDistance": 1000,
	                "$maxDistance": 5000
	            }
	        }
	    })



