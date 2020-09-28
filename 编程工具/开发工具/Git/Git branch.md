时间：2019-04-01 23:18:31

## git branch 分支管理

git branch 查看和管理分支。

## 常用操作

1. 查看本地分支及最新提交记录。

    ```shell
    git branch -v
    ```

2. 查看远程分支及最新提交记录。

    ```shell
    git branch -rv
    ```

1. 查看所有分支及最新提交记录。

    ```shell
    git branch -av
    ```

2. 依据当前分支创建分支，创建完成之后仍在当前分支。

    ```shell
    git branch new_branch_name
    git branch new_branch_name [local/remote-branch]
    ```
    
3. 修改分支名字

    ```shell
    # 修改本地分支名字
    git branch -m old_branch_name new_branch_name
    # 删除远程分支
    git push origin :old_branch_name
    # 追踪新的远程分支
    git push --set-upstream origin new_branch_name
    ```
    
4. 依据远程创建新分支，创建完成之后仍在当前分支。

    ```shell
    git branch --track [new_branch] [remote-branch]
    ```

4. 删除本地。

    ```shell
    git branch -d [local_branch_name]
    ```

5. 设置当前分支分支跟踪的远程分支。

    ```shell
    git branch --set-upstream-to=origin/<branch>
    ```

6. 查看已经合并到当前分支的分支。

    ```shell
    git branch --merged
    ```

7. 查看分支跟踪的远程分支。

    ```shell
    git branch -vv
    ```

