时间：2019-04-01 22:14:35 

## git revert 

git revert  回滚某次提交，如果当前提交和要回滚到的提交中间有多次提交，需要对每一次提交进行回滚操作。如果 `revert` 出错使用 `reset` 命令即可恢复。 

## 常用操作 

1. 回滚某次提交修改的代码。

    ```
    git revert commit_id
    ```
    
2. 回滚某次合并，回滚的时候需要指定主线分支，可以用 `git show` 命令查看。

    ```
    # 保留主分支
    git revert -m 1 commit_id
    # 保留被合并的分支
    git revert -m 2 commit_id
    ```