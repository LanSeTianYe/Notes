时间：2019/4/2 10:06:12 

## Git commit  

提交缓存区的变更到本地仓库。

## 常用操作

1. 提交缓存区文件。

		git commit -m "message"

2. 提交缓存区指定文件。

		git commit <file>... -m "message"

3. 显示文件内容变更信息，如 `1 file changed, 4 insertions(+)`。

		git commit -v -m "message" <file>... 
	
	 