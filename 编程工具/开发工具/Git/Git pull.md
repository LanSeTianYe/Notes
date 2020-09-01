时间：2019/4/1 23:55:28 

## Git poll  

从远程仓库拉取变更。

## 常用操作  

1. 拉取远程分支的提交到当前分支。

		git pull [remote] [remote_branch]
2. 拉取所有分支。

		git pull --all
3. 合并两个不同仓库的分支。

		git pull origin master --allow-unrelated-histories