时间：2019/4/1 23:18:31  

## Git branch 

查看和管理分支。

## 常用操作

1. 查看本地分支及最新提交记录。

		git branch -v
2. 查看远程分支及最新提交记录。

		git branch -rv
1. 查看所有分支及最新提交记录。

		git branch -av
2. 依据当前分支创建分支，创建完成之后仍在当前分支。

		git branch new_branch_name
		git branch new_branch_name [local/remote-branch]

4. 依据远程创建新分支，创建完成之后仍在当前分支。

		git branch --track [new_branch] [remote-branch]


