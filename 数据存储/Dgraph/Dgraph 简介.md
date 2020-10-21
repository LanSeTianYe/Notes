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

### 定义结构

#### 定义类型

语法类似 GraphQL，定义顶点的类型，顶点拥有的边，边的属性。

定义双向边有两种方法。

* 在添加数据的时候添加双向关系，如同时添加两条边 `A有一个朋友B` 和 `B有一个朋友A`。
* 在定义边类型的的时候指定双向关系，`boss_of: [uid] @reverse .`。生成的反向边的名字是 `~boos_of`。

```
# 人
type Person {
    name         # 姓名
    boss_of      # 他的老板
    works_for    # 他的工作
}

# 公司
type Company {
    name      # 公司的名字
    industry  # 公司的行业
    work_here # 工作地址
}

# 定义边的类型和索引
industry: string @index(term) .
boss_of: [uid] .
name: string @index(exact, term) .
works_for: [uid] .
work_here: [uid] .
```

### 常用命令

1. 数据导入，注意变更alpha和zero的端口。

    ```shell
    dgraph live -f 1million.rdf.gz --alpha localhost:9080 --zero localhost:5080 -c 1
    ```