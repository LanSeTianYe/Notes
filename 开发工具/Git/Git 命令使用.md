##   
1. 时间:2017/3/13 22:31:58 
2. 参考：  
	* [常用 Git 命令清单](http://www.ruanyifeng.com/blog/2015/12/git-cheat-sheet.html)

## git模型
  
1. 工作区：存储修改过的未缓存的文件
2. 缓存区：缓存修改过的文件
3. 本地仓库：提交缓存文件到本地仓库
4. 远程仓库：推送本地仓库文件到远程仓库

工作流程：本地编辑或删除文件之后文件会放在工作区，`git add` 命令会把指定的文件放进缓存区，`git commit` 会把缓存区的文件提交到本地仓库。 `git push` 命令会把本地仓库中的文件推送到远程仓库。
 
## 基本命令  


4. 缓存修改

		# 改文件名，并将这个改名放入缓存区
		git mv [original-file] [renames-file]
5. 提交修改
	
		# 把缓存区文件放入本地仓库
		git commit -m ["修改说明"]
		# 提交缓存区指定文件到仓库
		git commmit [file1] [file2] ... -m [message]
		# 提交工作区自上次提交之后的变化，直接到本地仓库
		git commit -a 
		# 提交时显示所有diff信息
		git commit -v
		# 使用一次新的提交代替上一次提交，如果代码没有发生任何变化，则用来改写上一次提交的提交说明
		git commit --amend -m [message]
		# 重做上一次提交，并包含指定文件的心变化
		git commit --amend [file1] [file2] ...
		# 丢弃本次更改(没有提交的更改都返回到没有修改的状态)
		git checkout .

6. 推送修改
	
		# 显示所有远程仓库
		git remote -v
		# 从远程仓库下载更新
		git fetch [remote]
		# 显示指定远程仓库信息
		git remote show [remote]
		# 增加远程仓库
		git remote add [shortname] [url]

7. 标签

		# 列出所有标签
		git tag
		# 新建一个tag在当前commit
		git tag -a [tagName]
		# 新建一个tag在指定提交
		git tag [tagName] [commit]
		# 删除本地tag
		git tag -d [tagName]
		# 删除远程tag
		git push origin :refs/tags/[tagName]
		# 查看tag信息
		git show [tag] 
		# 提交指定tag
		git push [remote] [tag]
		# 提交所有tag
		git push [remote] --tags
		# 新建一个分支，指向某个tag
		git checkout -b [branch] [tag]
8. 分支  

		# 新建一个分支，并且换到新建分支
		git branch - b [branchName]
		# 新建一个分支，执行指定commit
		git branch [branch] [commit]
		# 新建一个分支，与指定的远程分支建立追踪关系
		git branch --track [branch] [remote-branch]

		# 建立追踪关系，在现有分支与指定的远程分支之间
		git branch --set-upstream [branch] [remote-branch]
		# 合并指定分支到当前分支
		git megre -no-ff [branch]
		# 选择一个commit，合并进当前分支
		git cherry-pick [commit]
		# 删除分支
		git branch -d [branchName]
		# 删除远程分支
		git push origin --delete [branchName]
		git branch -dr [remote/branch]
9. 合并分支

		# 合并其他分支到当前分支
		git merge [currBranch] [otherBranch]

