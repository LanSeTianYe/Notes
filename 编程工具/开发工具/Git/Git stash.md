时间：2019-04-03 17:24:38 

## git stash 

git stash 储藏未提交的文件，储藏没有分支的概念可以被恢复到不同的分支。

## 常用操作 

1. 储藏文件。

    ```
    git stash
    ```

2. 恢复储藏的文件。

    ```
    git stash apply @stash{0}
    ```

3. 查看储藏的文件。

    ```
    git stash list
    ```
