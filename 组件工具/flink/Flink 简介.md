时间:2020/2/6 16:05:38  

参考： 

1. [官方中文文档](https://ci.apache.org/projects/flink/flink-docs-release-1.9/zh/)  
2. [Flink 在阿里的应用](https://www.iteblog.com/archives/2024.html)

## FLink

### Flink 简介 

Flink 是一种流处理框架。对数据流进行转换和处理。Flink支持并行和分布式的运行数据处理程序。

## Flink 数据流编程模型  

### 抽象层级 

1. SQL: 
2. Tabels API: 
3. Data Stream API/Data Set API: 
4. Stateful Stream Processing: 

### Flink 集群  

* `Flink Master`：一个管理任务提交等。
* `Flink TaskManagers`: 一个或多个负责执行具体的任务。

### 容灾 

通过检查点和流重放实现容灾。


### Flink 应用场景  

#### 事件驱动应用程序  

事件驱动应用相对于传统分层应用来说有一下有点：

2. 组件升级方便，不会有牵一发而动全身的问题。
3. 扩展方便，包含容量和应用规模扩展。
4. 高性能，基于本地资源进行业务处理，结合集群方式提供高吞吐量和低延迟。
5. Flink 提供精确的只消费一次支持，结合 `save point` 实现容错功能。
 
####　数据分析应用  

1. 支持实时的持续不断的数据分析，计算结果被存储在外部存储，或者应用内部。

#### 数据管道应用 

`数据提取 -> 转换 -> 加载` 类的应用被称为数据管道应用。 
1. 
