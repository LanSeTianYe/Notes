时间：2019-06-23 21:10:54 

参考： 

## MySQL 自定义变量 

不使用自定义变量可以解决大部分查询问题。也可以使用内存计算代替自定义变量。不到万不得已不要使用变量。

用户自定义变量在当前连接中有效。不同的客户端到服务端的链接不能共享使用用户自定义变量。

## 变量使用语法 

1. 变量赋值。 

    ```mysql
    SET @var_name := expr
    ```

2. 变量递增

    ```mysql
    SELECT @num := @num + 1 FROM table_name;
    ```

3. 在SQL里面初始化变量。下面这个SQL没有从数据表查询，而是使用SQL构造数据。

    ```
    # 初始化变量
    (SELECT @j := 0 as init_j) AS temp
    # 生成三行 1,2,3
    (SELECT 1 AS id UNION ALL SELECT 2 UNION ALL SELECT 3) AS ids,
    # 全连接 (n*n*n)
    (SELECT @j := 0 as init_j) AS temp,
    (SELECT 1 AS id UNION ALL SELECT 2 UNION ALL SELECT 3) AS ids,
    (SELECT 'Type-A' AS type UNION ALL select 'Type-B' UNION ALL SELECT 'Type-C') AS types
    # (SELECT @j := 0 as init_j) AS temp 先执行，执行完之后才会执行外面的 @j := @j + 1  
    ```

    ```mysql 
    SELECT
    temp.init_j,
    ids.id,
    types.type,
    @j := @j + 1 AS uid
    FROM 
    (SELECT @j := 0 as init_j) AS temp,
    (SELECT 1 AS id UNION ALL SELECT 2 UNION ALL SELECT 3) AS ids,
    (SELECT 'Type-A' AS type UNION ALL select 'Type-B' UNION ALL SELECT 'Type-C') AS types
    ```

