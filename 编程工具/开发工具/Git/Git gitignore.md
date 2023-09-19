时间 ：2020-10-21 10:46:46

## gitignore 忽略项目的文件

### 创建忽略文件

在 `Git BASH` 下 创建 `.gitignore`文件

```shell
touch .gitignore
```

### 忽略一些文件

```shell
## 忽略HBuider工程文件
*.project
## 忽略Intelij idea工程文件夹
.idea/
## 忽略Intellij idea 工程文件
*.iml
## 忽略日志文件
*.log
## 忽略maven生成的目标文件
target/
```

### 忽略已经加入版本管理的文件

如果某些文件已经被纳入了版本管理中，直接修改.gitignore是无效的。需要先把文件从版本管理的索引中删除，然后修改.gitignore文件，然后提交即可。

```shell
# 第一步：从索引中删除文件
git rm --cached filename
# 第二部：修改 .gitignore文件，添加忽略规则
# 第三步：提交变更
git commit -m 'update .gitignore'
```

