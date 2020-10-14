时间：2020-10-14 10:54:54

## MySQL SQL特殊用法-使用SQL构造数据

有三个表(数据见后面):

```sql
user {            用户表
  name            姓名
  register_time   注册时间
}
merchandise {     商品表
  name            名字
  cerate_time     创建时间
}
order{             订单表
  id               id
  create_time      创建时间
}
```

假设要一次查询出 2020-10-14 到 2020-10-23 每天的注册用户数量，新增的商品数量和新增订单数量。如果使用User表做主表根据日期关联其他表，如果15号没有注册用户，则15号的商品和订单就会查询不出来。用另外两个表做主表也有同样的问题。

解决方案一：查询三个表有数据的日期的交集。然后再关联查询数据。
解决方案二：构建出日期数据，然后关联查询。

下面是完整的SQL：

```SQL
SELECT
temp.date,
(SELECT COUNT(*) FROM `user` WHERE register_time >= CONCAT(temp.date,' 00:00:00') AND register_time <= CONCAT(temp.date,' 23:59:59')) AS userCount,
(SELECT COUNT(*) FROM `merchandise` WHERE create_time >= CONCAT(temp.date,' 00:00:00') AND create_time <= CONCAT(temp.date,' 23:59:59')) AS merchandiseCount,
(SELECT COUNT(*) FROM `order` WHERE create_time >= CONCAT(temp.date,' 00:00:00') AND create_time <= CONCAT(temp.date,' 23:59:59')) AS oederCount
FROM(
	SELECT
	DATE_ADD(DATE_FORMAT('2020-10-14', "%Y-%m-%d"),INTERVAL @j := @j + 1 DAY) AS date
	FROM 
	(SELECT @j := -1 as init_j) AS temp,
	(SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 ) AS temp1,
	(SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 ) AS temp2
	 LIMIT 10
) AS temp
```

### SQL 构建数据

1. 构建列数据。

    ```
    # 一行一列
    SELECT 1;
    # 一行两列
    SELECT 1,2;
    # 一行三列
    SELECT 1,2,3;
    ```

2. 构建列数据。

    ```
    #一行一列
    SELECT 1;
    # 两行一列
    SELECT 1 UNION ALL SELECT 1;
    # 三行一列
    SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1;
    # 四行两列
    SELECT 
    * 
    FROM 
    (SELECT 1 UNION ALL SELECT 1) AS temp1,
    (SELECT 1 UNION ALL SELECT 1) AS temp2
    # 八行三列
    SELECT 
    * 
    FROM 
    (SELECT 1 UNION ALL SELECT 1) AS temp1,
    (SELECT 1 UNION ALL SELECT 1) AS temp2,
    (SELECT 1 UNION ALL SELECT 1) AS temp3
    ```

3. 变量初始化

    ```mysql
    SELECT
        @j := @j + 1  AS id
    FROM 
    (SELECT @j := -1 as init_j) AS temp
    ```

### 附录-完整SQL

```
CREATE TABLE `merchandise`  (
  `id` int(11) NOT NULL,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_bin ROW_FORMAT = Dynamic;

INSERT INTO `merchandise` VALUES (1, 'm_1', '2020-10-14 11:32:32');
INSERT INTO `merchandise` VALUES (2, 'm_2', '2020-10-15 11:32:49');
INSERT INTO `merchandise` VALUES (3, 'm_3', '2020-10-17 11:33:07');
INSERT INTO `merchandise` VALUES (4, 'm_4', '2020-10-14 11:33:40');

CREATE TABLE `order`  (
  `id` int(11) NOT NULL,
  `code` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_bin ROW_FORMAT = Dynamic;

INSERT INTO `order` VALUES (1, 'o_a', '2020-10-15 11:30:59');
INSERT INTO `order` VALUES (2, 'o_b', '2020-10-15 11:31:18');
INSERT INTO `order` VALUES (3, 'o_c', '2020-10-16 11:31:30');
INSERT INTO `order` VALUES (4, 'o_d', '2020-10-17 11:31:48');

CREATE TABLE `user`  (
  `id` int(11) NOT NULL,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `register_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_bin ROW_FORMAT = Dynamic;

INSERT INTO `user` VALUES (1, 'u_a', '2020-10-09 11:29:27');
INSERT INTO `user` VALUES (2, 'u_b', '2020-10-14 11:29:32');
INSERT INTO `user` VALUES (3, 'u_c', '2020-10-16 11:29:37');
INSERT INTO `user` VALUES (4, 'u_d', '2020-10-16 11:29:40');
```