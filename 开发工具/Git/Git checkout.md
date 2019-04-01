时间：2019/4/1 21:51:44   

## Git checkout 

1. 恢复删除文件  

		# 恢复指定文件，到上一次提交
		git checkout -- file_name
		# 恢复所有变更的文件，到上一次提交。 
		git checkout .

2. 切换到本地分支。

		git checkout local_branch_name

3. 创建新分支，并切换到指定分支。

		git checkout -b new_branch old_branch

 

