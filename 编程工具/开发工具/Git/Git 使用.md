##   
1. 时间:2017/3/13 22:31:58 
2. 参考：
  
	* [Git book](https://git-scm.com/book/en/v2)
	* [How to Install latest version of Git ( Git 2.x ) on CentOS 7](https://computingforgeeks.com/how-to-install-latest-version-of-git-git-2-x-on-centos-7/)

## 简介  

在Git中所有用来表示项目历史信息的文件，是通过一个40个字符的（40-digit）“对象名”来索引的。

## git模型

1. 工作区：存储修改过的未缓存的文件
2. 暂存区：缓存修改过的文件
3. 本地仓库：提交缓存文件到本地仓库
4. 远程仓库：推送本地仓库文件到远程仓库

工作流程：本地编辑或删除文件之后文件会放在工作区，`git add` 命令会把指定的文件放进缓存区，`git commit` 会把缓存区的文件提交到本地仓库。 `git push` 命令会把本地仓库中的文件推送到远程仓库。

## git client 

* [gitkraken](https://www.gitkraken.com/): 用过的比较好用的客户端工具。  

## 安装 
1.  Centos 7 安装 2.0 版本。

    ```shell
    yum remove git	
    yum install  https://centos7.iuscommunity.org/ius-release.rpm
    yum install  git2u-all
    ```