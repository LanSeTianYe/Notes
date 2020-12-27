时间：2020-12-27 14:51:51

## GitHub 搜索

1. in 搜索。

    ```
    # 搜索名字
    in:name java
    # 搜索描述
    in:description java
    # 搜索Readme
    in:readme java
    ```
    
2. stars/fork 数量。

    ```
    stars:<=10000 in:name java
    stars:>=10000 in:name java
    stars:8000..10000 in:name java

    fork:<=10000 in:name java
    fork:>=10000 in:name java
    fork:8000..10000 in:name java
    ```

3. size 限制仓库大小，单位KB。

    ```
    size:<=5000
    size:>=5000
    size:5000..6000
    ```

4. 更新时间。

    ```
    pushed:>2020-12-27
    ```
    
5. 开源协议。

    ```
    license:apache-2.0
    ```
    
6. 编程语言。

    ```
    language:java
    ```

7. 指定用户/组织。

    ```
    user:sunfeilong
    org:bittygarden
    ```
    
8. 查询精品仓库。

    ```
    awesome:java
    ```

9. 高亮显示行。

    ```
    https://github.com/bittygarden/tulip/blob/main/src/main/java/com/xiaotian/tulip/compress/lz4/LZ4.java#L30
    https://github.com/bittygarden/tulip/blob/main/src/main/java/com/xiaotian/tulip/compress/lz4/LZ4.java#L30-L39
    ```
    
10. 项目内搜索，进入项目主页按 `t`。