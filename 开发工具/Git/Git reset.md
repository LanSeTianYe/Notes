时间：2019/4/1 21:40:08  

## Git Reset 命令

把本地提交历史恢复到指定的提交。  

## 常用操作 

1. 把暂存区的文件移动到工作区。  

		# 取消缓存指定文件
		git reset branch_name <file>...
		# 取消缓存所有的文件
		git reset branch_name .

2. 恢复本地提交历史到指定提交，用于本地提交没有推送到仓库，如果已经推送到远程仓库可以使用 `revert` 

		# 恢复到指定提交，变更的文件放置在缓存区
		git reset --soft commit_id
		# 恢复到指定提交，变更的文件放置在工作区
		git reset --soft commit_id 
		# 恢复到指定提交，删除变更的文件 
		git reset --hard commit_id