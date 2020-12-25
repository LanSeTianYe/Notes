时间: 2020-12-15 12:20:20

参考：

1. [如何解决 GitHub 提交次数过多 .git 文件过大的问题？](https://www.zhihu.com/question/29769130)

## Git 覆盖远程仓库

解决Git仓库提交记录过大问题。

### 覆盖远程仓库

覆盖之后仓库之前的提交历史会全部清除。

```shell
# 删除.git文件夹
rm -rf .git
# 初始化项目并提交变更
git init && git add . && git commit -m "reset project"
# 添加远程仓库
git remote add origin 远程仓库地址
# 覆盖仓库
git push -f -u origin master
```

如果远程仓库有其他分支，删除其他分支。









