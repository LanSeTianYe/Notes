时间：2019-04-01 23:05:56 

## git log

git log 显示提交记录。 

## 常用操作 

1. 查看提交历史。

    ```
    git log
    ```

2. 图形化展示提交历史。

    ```
    git log --graph
    ```

3. 显示每个用户的提交历史。

    ```
    git shortlog
    ```
    
4. 最近两次提交的差异。

    ```
    git log -p -2
    ```

5. 查看统计信息，查看每次变更提交的文件列表。（每次变更每个文件的变化信息。新增行数、删除行数等等）。

    ```
    git log --stat
    ```

6. 指定显示格式。

    ```
    git log --pretty=oneline
    ```

7. 显示在后面分支但不在前面分支的提交。

    ```
    git log --no-merges is55..origin/master	
    ```

8. 图像化展示各分支信息。

    ```
    git log --oneline --decorate --graph --all
    ```