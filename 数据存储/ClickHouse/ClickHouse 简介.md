参考：

1. [ClickHouse 官方中文文档](https://clickhouse.com/docs/zh/introduction/distinctive-features)
2. [DB-Ranking](https://db-engines.com/en/ranking)
2. [性能](https://benchmark.clickhouse.com/)

## ClickHouse 简介

ClickHouse 是一个 OLAP 数据库。

* 单条数据查询满，使用稀疏索引，定位单条数据慢，但是批量查询快。
* 数据查询分析性能高，适用通过很多数据聚合统计的场景。
* 不支持事务，不能保证数据一致性。
* 支持集群，可扩展性高。
* 查询性能高，不支持数据变更和删除 `Update is not supported by ClickHouse tables`。





