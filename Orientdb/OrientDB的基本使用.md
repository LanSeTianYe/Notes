## 安装
* 直接下载压缩包即可

## `console`简单命令使用
* `console.bat` 即可打开命令行窗口
* `connect remote:127.0.0.1 root 000000` 连接到服务器
* `help` 查看帮助文档
* `help 命令` 查看对应命令的作用  例如：`HELP SELECT`
* `list databases` 查看所有的数据库
* `connect remote:127.0.0.1/Demo root 000000` 连接到指定的数据库
* 创建数据库 `create database remote:127.0.0.1/Demo root 000000 plocal`

## Class操作

1. 创建class `create class Student`
2. 创建属性  `create property Student.name String`

		orientdb {db=Demo}> create property Student.name String
		
		Property created successfully with id=1
3. 查看class的信息 `info class Student`
4. 属性增加约束 `alter property Student.name min 40` 可以约束 min max type 和 是否可以为空等。
5. 查看class记录的信息 `browse class ouser`
6. 展示brows的第n条记录 `display record 0`

## cluster 簇
* 默认情况下，所有的class存储在一个cluster下面，一个class可以依赖多个cluster
1. 查看所有的簇 `clusters`
2. 在创建class的时候会默认创建一个同名的簇，另外可以通过`alter class Student addcluster ClassA` 增加簇
3. 查看簇里面存储的所有信息 `browse cluster ouser`
4. `display record 0` 同上结合 browse使用

5. Record ID 由 `#<cluster-id>:<cluster-position>`组成
6. 根据RID获取数据   `load record #5:1`

## SQL
1. 查询 `select *  from ouser`
2. 从簇中查询 `select * from cluster:ouser`
3. 从RID中查询  `select * from #5:1` 或者 `SELECT FROM [#10:1, #10:30, #10:5]`
4. **where** `SELECT FROM OUser WHERE name LIKE 'l%'`
5. **order by** `SELECT FROM Employee WHERE city='Rome' ORDER BY surname ASC, name ASC`
6. **group by** `SELECT SUM(salary) FROM Employee WHERE age < 40 GROUP BY job`
7. **limit** `SELECT FROM Employee WHERE gender='male' LIMIT 20`
8. **skip** `SELECT FROM Employee WHERE gender='male' SKIP 20 LIMIT 20`
9. **insert**

	    The standard ANSI-93 syntax:
	
	    orientdb> INSERT INTO Employee(name, surname, gender)  VALUES('Jay', 'Miner', 'M')
	
	    The simplified ANSI-92 syntax:
	
	    orientdb> INSERT INTO Employee SET name='Jay', surname='Miner', gender='M'
	
	    The JSON syntax:
	
	    orientdb> INSERT INTO Employee CONTENT {name : 'Jay', surname : 'Miner',gender : 'M'}
10. **update**


	    The standard ANSI-92 syntax:
	
	    orientdb> UPDATE Employee SET local=TRUE WHERE city='London'
	
	    The JSON syntax, used with the MERGE keyword, which merges the changes with the current record:
	
	    orientdb> UPDATE Employee MERGE { local : TRUE } WHERE city='London'
11. **delete**

 		DELETE FROM Employee WHERE city <> 'London'



