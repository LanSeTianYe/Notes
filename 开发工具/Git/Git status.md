时间：2019/4/1 22:49:19  

## Git status 

查看文件状态。

## 选项

* `-s` : --short 简短形式输出。
* `-b` : --branch 显示分支信息。
* `long` : 输出完整信息，（默认选项）。
* `-v` : --verbos 展示已经添加到本地缓存的文件被修改的内容，类似于 `git diff --cached`,

## 常用操作  

1. 查看文件状态。  

		git status [--long]

2. 查看文件状态和简短信息。

		git status -sb

3. 显示已经缓存的文件变更的内容。

		git status -v