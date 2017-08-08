时间： 2017/8/8 10:41:10 

## 安装

1. 下载

		curl -o apache-drill-1.11.0.tar.gz http://www.apache.org/dyn/closer.cgi/drill/drill-1.11.0/apache-drill-1.11.0.tar.gz
2. 解压

		tar -xvzf apache-drill-1.11.0.tar.gz
3. 进入bin目录，执行下面命令

		./drill-embedded


## 配置mongodb

1. 打开Web页面 `http://localhost:8047/`, 然后选择 `Storage` 选项卡， 在 `Disabled Storage Plugins` 中找到 `mongo`, 然后点击 `Update`, 编辑配置信息。
	
		{
		  "type": "mongo",
		  "connection": "mongodb://localhost:27017/",
		  "enabled": true	
		}
然后点击 `Enable`，然后点击 `Back`。这时在 `Enabled Storage Plugins` 下会出现 `mongo`，此时配置已经结束。
2. 查看是否配置成功,在 `dirll` 命令行， 输入 `show databases;` 命令：

		0: jdbc:drill:zk=local> show databases;
		+---------------------+
		|     SCHEMA_NAME     |
		+---------------------+
		| INFORMATION_SCHEMA  |
		| cp.default          |
		| dfs.default         |
		| dfs.root            |
		| dfs.tmp             |
		| mongo.local         |
		| mongo.test          |
		| sys                 |
		+---------------------+
		8 rows selected (8.934 seconds)
		0: jdbc:drill:zk=local> 
3. 在Web页面查询，进入 `Query` 选项卡：

		//mongo 是mongo数据库的标志，test是数据库名字,person集合（相当于表）
		SELECT * FROM mongo.test.person

	结果：

		_id             name           age
		[B@38027445 	xiaotian 	    24
		[B@2969d226 	longlongxiao 	25



	


