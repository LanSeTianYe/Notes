##   
1. 时间:2017/3/13 22:31:58 
2. 参考：  
	* [常用 Git 命令清单](http://www.ruanyifeng.com/blog/2015/12/git-cheat-sheet.html)

## git模型
1. 工作区：存储修改过的未缓存的文件
2. 缓存区：缓存修改过的文件
3. 本地仓库：提交缓存文件到本地仓库
4. 远程仓库：推送本地仓库文件到远程仓库

## 基本命令
1. 配置

		# 查看配置信息
		git config --list
		# 编辑配置信息
		git config -e [--global]
		# 配置局部或全局用户名
		git config [--global] user.name "sunfeilong1993"
		git config [--global] user.email "1498282352@qq.com"
        # 配置支持长路径文件
		git config --global core.longpaths true
        # 添加或删除远端
	    git remote add remote_name https://github.com/longlongxiao/abc.git
        git remote remove remote_name
2. 项目初始化  

		# 从远程仓库获取，默认名字是最后一个/号后面.git前面的内容
		git clone https://github.com/longlongxiao/XiaoTian.git [projectName]
		# 把当前目录初始化成git项目
		git init
		# 在当前目录下初始化一个项目
		git init [projectName]
3. 查看信息

		# 查看文件变化
		git status -s
		# 显示当前版本历史
		git log
		# 显示提交历史，以及每次提交发生变更的文件
		git log --stat
		# 搜索提交历史，根据关键字
		git log -S [keyword]
		# 显示某个commit之后的所有变动，每个commit占据一行
		git log [tag] HEAD --pretty=format:%s
		# 显示过去的五次提交
		git log -5 --pretty --oneline
		# 树形展示历史
		git --graph
		# 显示所有提交过的用户，按提交次数排序
		git shortlog -sn
		# 显示指定文件在什么时候修改过
		git blame [file]
		# 显示缓存区和工作区的差异
		git diff
		# 显示缓存区和上一次提交的差异
		git diff --cached [file]
		# 显示工作区和当前分支最新提交之间的差异
		git diff HEAD
		# 显示今天写了多少代码
		git diff --shortstat "@{0 day ago}"
		# 显示当前分支最近几次提交
		git reflog
4. 缓存修改

		# 缓存当前目录下所有修改的文件
		git add .
		# 缓存指定文件
		git add [file1] [file2] ...
		# 缓存指定目录下所有修改的文件
		git add [dir]
		
		# 删除工作区文件，并将这次删除放入缓存区
		git rm [file1] [file2] ...	
		# 停止追踪文件，但该文件会保留在工作区
		git rm -cached [file]
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
		# 取回远程仓库的变化，并与本地分之合并
		git pull [remote] [branch]
		# 上传本地分支到远程仓库
		git push [remote] [branch]
		# 强行推送当前分支到远程仓库，即使有冲突
		git push [remote] --force
		# 推送所有分支到远程仓库
		git push [remote] --all
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

		# 列出所有本地分支
		git branch
		# 列出所有远程分支
		git branch -r
		# 列出所有本地分支和远程分支
		git branch -a
		# 显示分支最新版本（和-r、-a结合使用）
		git branch -v
		# 新建一个分支，但依然停留在当前分支
		git branch [branchName]
		# 新建一个分支，并且换到新建分支
		git branch - b [branchName]
		# 新建一个分支，执行指定commit
		git branch [branch] [commit]
		# 新建一个分支，与指定的远程分支建立追踪关系
		git branch --track [branch] [remote-branch]
		# 切换到指定分区，并更新工作区
		git checkout [branchName]
		# 切换到上一个分支
		git branch -
		# 检出分支到新分支
		git checkout -b newbranch branch
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


10. `statsus` 查看工作区状态

	* `-s` : --short 简短形式输出
	* `-b` : --branch 显示分支信息（在简短格式下也可以使用）
	* `--porcelain` : 输出脚本易读的简短形式，在各种Git版本和用户配置保持输出格式一致。
	* `long` : （默认选项），输出完整信息
	* `-v` : --verbos 展示已经添加到本地缓存的文件里面被修改的内容，类似于 `git diff --cached`,
	* `-vv` : 展示没有缓存的文件和缓存文件的被修改的内容，类似于 `git diff`

