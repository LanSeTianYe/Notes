时间：2018/7/31 11:11:32  


## git 代码回滚说明
 
> git 回滚代码有以下两种选择，`reset` 可以销毁提交历史记录， `revert` 会在当前版本执行指定版本的 `commit` 的逆向操作。  

>  两种方式结合使用会解决一切在回滚过程中出现的问题。通常如果 `revert` 出错，只需要执行 `reset` 即可回到出错前的版本。   

###  没有 push 使用 `reset`  

本地已经提交，提交并没有 `push` 服务器，可以选择使用 `reset`。`reset` 可以重置到指定版本，指定版本之后的提交内容会回到未缓存的状态或直接丢弃。
		
	git reset [--soft | --mixed | --hard] c011eb3

reset 的三种模式：(默认是 `--mixed`)

* **mixed**: 保留源码，将 `commit` 和 `index` 信息回退到了某个版本，更改的内容回到未缓存的状态。

* **soft**: 保留源码，回退到 `commit` 信息到某个版本。不涉及index的回退，如果还需要提交，直接 `commit` 即可。

* **hard**: 源码也会回退到某个版本，`commit` 和 `index` 都回回退到某个版本。

### 已经 push 使用 revert

**revert** : 回滚 **某次** 提交，如果 `push` 了多次提交，要对提交的每一个版本进行回滚。

	git revert c011eb3
