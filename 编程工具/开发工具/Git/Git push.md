时间：2019-04-02 0:03:27 

## git push 

git push 推送分支变化。

## 常用操作 

0. 推送当前分支到远程分支。

    ```
    git push
    ```

1. 推送本地分支到远程仓库对应分支。

    ```
    git push [remote] [local_branch]
    ```

2. 指定推送的远程分支的名字。

    ```
    git push origin local_branch:remote_branch
    ```

2. 推送所有分支。

    ```
    git push --all
    ```

6. 推送并跟踪远程分支。

    ```
    git push -u orgin fetureA:fetureAA			
    ```

5. 删除远程分支。

    ```
    git push origin :remote_branch_name
    ```

6. 推送标签。

    ```
    # 推送指定标签
    git push origin v0.0.1
    # 推送所有标签
    git push origin --tags
    ```

7. 删除远程标签。

    ```
    git push origin :v0.0.1
    ```

8. 覆盖远程分支，当分支变基之后使用。

    ```
    git push -f origin fetureA 
    ```