时间：2019-04-01 21:51:44 

## git checkout 

1. 恢复缓存区的文件到上一次提交。 

    ```
    # 恢复指定文件，到上一次提交
    git checkout -- file_name
    # 恢复所有变更的文件，到上一次提交。 
    git checkout -- .
    ```

2. 切换到本地分支。

    ```
    git checkout local_branch_name
    ```

3. 创建本地分支跟踪远程分支，本地分支拉取和推送都对应到跟踪的远程分支。

    ```shell
    # 指定远程分支
    git checkout -b new_branch origin/remote_branch
    # 创建和远程分支名字相同的分支
    git checkout --track origin/remote_branch
    ```

7. 检出标签，此时仓库会处于分离指针头的状态，修改提交之后将处于无分支状态。可以从标签创建新分支，解决这个问题。

    ```shell
    git checkout "tag_name" 
    ```

