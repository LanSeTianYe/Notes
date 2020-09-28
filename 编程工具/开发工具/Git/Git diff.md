时间：2019-04-02 09:27:51 

## git diff 

git diff 比较文件变更。 

## 常用操作 

1. 比较工作区文件和上次提交之间的变更，也可用于查看冲突。

    ```shell
    # 所有文件
    git diff
    # 指定文件
    git diff <file_name>...
    ```

2. 比较缓存区和上次提交之间的变更。

    ```shell
    # 所有文件
    git diff --cached
    # 指定文件
    git diff --cached <file_name>...
    ```

3. 比较工作区和缓存区文件和上次提交之间的变更。

    ```shell
    git diff HEAD
    ```