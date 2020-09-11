时间：2020-09-10 15:48:48
参考：

1.[贝壳分布式图数据库选型与实践](https://dbaplus.cn/news-160-3315-1.html)

## DGraph 简介



### 数据类型


|  类型名字    | 描述      |
| ---- | ---- |
| default | 默认类型 |
| int | 有符号64位整数 |
| float | 双精度浮点数 |
| string | 字符串，存储的时候支持多国语言，`name@en` `name@zh` 分别标识英文和中文名<br>查询的时候只能指定一种语言<br>  `eq(name@.:, "name")`   查询所有姓名。 <br>  `eq(name@zh:, "name")` 查询中文姓名。 <br>返回时可以指定返回类型顺序 `name@zh:en` 优先返回中文名。 |
| bool | boolean |
| dateTime | 可以指定时区 |
| geo | 地理坐标类型 |
| password | 加密类型 |
| uid | uid类型，节点标识字段，用于连接节点和节点 |

