时间：2018/2/27 17:23:29   

参考：

1. [Maxwell官网](http://maxwells-daemon.io/)  

## 简介  

Maxwell is an application that reads MySQL binlogs and writes row updates to Kafka, Kinesis, RabbitMQ, Google Cloud Pub/Sub, or Redis (Pub/Sub or LPUSH) as JSON。

读取MySQL的binLog，并把数据的更新以JSON的格式发送到控制台、Kafka、Redis、Kinesis、RabbitMQ和Google Cloud Pub/Sub等。

## 把结果输出到控制台  

* 运行及数据变更时的输出结果： 

		$ ./maxwell --user='maxwell' --password='maxwell' --host='127.0.0.1' --producer=stdout

		Using kafka version: 0.11.0.1
		17:43:12,470 WARN  MaxwellMetrics - Metrics will not be exposed: metricsReportingType not configured.
		17:43:13,189 INFO  Maxwell - Maxwell v1.13.1 is booting (StdoutProducer), starting at Position[BinlogPosition[mysql-binlog.000002:140094], lastHeartbeat=1519724588985]
		17:43:13,445 INFO  MysqlSavedSchema - Restoring schema id 1 (last modified at Position[BinlogPosition[mysql-binlog.000002:4732], lastHeartbeat=0])
		17:43:13,613 INFO  BinlogConnectorReplicator - Setting initial binlog pos to: mysql-binlog.000002:140094
		17:43:13,717 INFO  BinaryLogClient - Connected to 127.0.0.1:3306 at mysql-binlog.000002/140094 (sid:6379, cid:50)
		17:43:13,718 INFO  BinlogConnectorLifecycleListener - Binlog connected.
		{"database":"blogger","table":"article_info","type":"update","ts":1519724599,"xid":3384,"commit":true,"data":{"id":"lan2tian2_Win10 guan1bi4Hyper-V.md_905e8da8712389bee6ca7827fc5a8ac1","love_number_":0,"view_number_":5},"old":{"view_number_":4}}


## 应用  

* 把数据变更信息推到Kafka中，在项目中订阅Kafka进行消费，实现数据变更触发项目流程处理。  