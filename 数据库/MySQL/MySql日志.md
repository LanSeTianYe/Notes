时间： 2017/11/26 9:33:23   
参考：  

1. [https://dev.mysql.com/doc/refman/5.7/en/server-logs.html](https://dev.mysql.com/doc/refman/5.7/en/server-logs.html)  

##   

### 日志类型  

默认情况下任何日志都是没有开启的，除了再Windows上默认开启了error log。  

注： `--` 代表用 [mysqladmin](https://dev.mysql.com/doc/refman/5.7/en/mysqladmin.html) 命令执行。   

1.  Error Log(错误日志）：启动、结束或运行是遇到的问题。相关配置可以再运行时通过改变环境变量进行改变。

	记录数据库启动和关闭过程信息，记录启动过程和运行期间出现的错误，警告和 Note。例如:如果MySql发现一个表需要检查或修复，就会写一条消息到错误日志。

		# 把错误日志输出到控制台，会被 log-error 覆盖
		--console 
		# 开启或关闭错误日志
		log-error=[ON|OFF]
	    # 开启错误日志，并指定错误日志名字
		log-error="fileName"
	    # 关闭或开启输出警告信息，和错误日志输出到同一个文件中
		log_warring=[0|1]
		# 刷新和重命名日志
		mv host_name.err host_name.err-old
		mysqladmin flush-logs
		mv host_name.err-old backup-directory
2. General query log（一般查询日志）:记录建立客户连接和客户端执行的语句。一般查询日志按语句的接收顺序记录日志，可能和执行顺序不同。相关配置可以再运行时通过改变环境变量进行改变。  
3. Slow query log(慢查询日志):记录执行时间超过指定时间的查询语句。相关配置可以再运行时通过改变环境变量进行改变。  
    
		# 日志输出位置配置，和慢查询共用  
	 	--log-output=[TABLE|FILE|NONE]
		# 开启或关闭
	 	general-log=[0|1]
		# 指定日志文件名称  
        general_log_file="fileName"  
		# 开启或关闭
		slow-query-log=[0|1]
		# 指定日志文件名称
		slow_query_log_file="fileName"
		# 慢查询，记录没有使用索引的语句  
		log_queries_not_using_indexes 
		# 重命名日志文件  
		shell> mv host_name.log host_name-old.log
		shell> mysqladmin flush-logs
		shell> mv host_name-old.log backup-directory
    
3. Relay log（中继日志）：从复制的主服务器接受的数据改变。           
3. Binary  log(二进制日志):  记录改变数据的语句（也用于复制）。语句将在语句再执行之后，锁释放之前被写入日志。  
用途：  
	* 复制：用于主从复制，主服务把数据改变的语句发送到从服务器，从服务器执行语句从而使得从服务和主服务的数据同步。  
	* 数据恢复操作：备份回复后，执行 bin log 里面记录的语句，把数据恢复到指定的时间。  

			# 开 bin log(配置文件中 log_bin=mysql-binlog)
			--log-bin[=base_name] 
			# 指定bin log 最大大小
			max_binlog_size
			# bin log 索引文件名字 
			--log-bin-index[=file_name] 
			# bin log 格式 取决于MySql版本  
			binlog_format=[row（事件）|statement（语句）|mixed（前两种混合）]
			# 主从时，从数据库的配置 
			--log-slave-updates
			# 查看二进制日志的内容
			mysqlbinlog log_file | mysql -h server_name 
			# 多少条之后同步到磁盘
			sync_binlog = 1(最安全，但是速度慢)
			# 确保磁盘数据和 bin log同步
			--innodb_support_xa=1  
			# 查看bin log 数据
			show binlog events;
			mysqlbinlog "C:\ProgramData\MySQL\MySQL Server 5.7\Data\DESKTOP-OV8JFOA-bin.000001"
			# 修改 bin log 记录格式
			SET GLOBAL binlog_format = 'STATEMENT'; 
 
5. DDL log (metadata log)（数据定义日志）: 触发器语句已经执行的元数据操作。
	
	记录数据定义产生的操作，如 `alter table` 或 `drop table`，解决数据回复问题。  
	解决 `DROP TABLE t1, t2`，当t1被删除，t2被删除之前，系统挂掉，系统重启之后根据日志t2也会被删除。

        