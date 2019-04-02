时间：2019/4/2 9:27:51 

## Git diff

比较文件变更。  

## 常用操作 

1. 比较工作区文件和上次提交之间的变更。

		# 所有文件
		git diff
		# 指定文件
		git diff <file_name>...

2. 比较缓存区和上次提交之间的变更。

		# 所有文件
		git diff --cached
		# 指定文件
		git diff --cached <file_name>...

3. 比较工作区和缓存区文件和上次提交之间的变更。

		git diff HEAD
		