时间：2019-04-02 20:07:28 

## git tag 

git tag 打标签。

## 常用操作 

1. 查看标签。

    ```
    git tag 
    ```

2. 查看 `2` 开头的标签。

    ```
    git tag -l '2*'
    ```

3. 在当前分支打标签。

    ```
    git tag -a v1.0.0 -m "first tag"
    ```

4. 指定提交打标签。

    ```
    git tag -a v0.0.1 137d453
    ```

5. 删除本地标签。

    ```
    git tag -d v0.0.1
    ```
    
6. 删除远程标签。

    ```
    git push origin :v0.0.1
    ```