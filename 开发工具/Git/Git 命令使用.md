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
	

