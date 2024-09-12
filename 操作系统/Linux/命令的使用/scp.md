##  
时间：2017/5/10 17:06:10   
参考：

1. [http://man.linuxde.net/scp](http://man.linuxde.net/scp)

## 命令介绍

scp命令用于在Linux下进行远程拷贝文件的命令，scp传输是加密的。可能会稍微影响一下速度。当你服务器硬盘变为只读read only system时，用scp可以帮你把文件移出来。scp还非常不占资源，不会提高多少系统负荷，在这一点上，rsync就远远不及它了。虽然 rsync比scp会快一点，但当小文件众多的情况下，rsync会导致硬盘I/O非常高，而scp基本不影响系统正常使用。

## 语法

	scp (选项) (参数)
## 选项

> -1：使用ssh协议版本1；   
> -2：使用ssh协议版本2；  
> -4：使用ipv4；  
> -6：使用ipv6；  
> -B：以批处理模式运行；  
> -C：使用压缩；  
> -F：指定ssh配置文件；  
> -l：指定宽带限制；  
> -o：指定使用的ssh选项；  
> -P：指定远程主机的端口号；  
> -p：保留文件的最后修改时间，最后访问时间和权限模式；  
> -q：不显示复制进度；  
> -r：以递归方式复制

## 参数

* 源文件：要复制的源文件
* 目标文件：格式为 `user@host:filename` ,filename 包含路径。 

## 使用
* 复制文件到本地目录

	```
	scp root@10.10.10.10:/opt/soft/nginx-0.5.38.tar.gz /opt/soft/
	```

* 复制目录到本地

	```
	scp -r root@10.10.10.10:/opt/soft/mongodb /opt/soft/
	```

* 上传本地文件到远程机器指定目录

	```
	scp /opt/soft/nginx-0.5.38.tar.gz root@10.10.10.10:/opt/soft/scptest
	```

* 上传本地目录到远程机器指定目录

	```
	scp -r /opt/soft/mongodb root@10.10.10.10:/opt/soft/scptest
	```
