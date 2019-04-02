时间：2019/4/1 21:51:44   

## Git checkout 

1. 恢复缓存区的文件到上一次提交。  

		# 恢复指定文件，到上一次提交
		git checkout -- file_name
		# 恢复所有变更的文件，到上一次提交。 
		git checkout -- .

2. 切换到本地分支。

		git checkout local_branch_name

3. 创建新分支，并切换到指定分支。

		git checkout -b new_branch old_branch

4. 创建本地分支跟踪远程分支，本地分支拉取和推送都对应到跟踪的远程分支。

 		git checkout -b local_branch origin/remote_branch

5. 创建本地分支跟踪指定远程分支。

		git checkout --track origin/remote_branch
 

