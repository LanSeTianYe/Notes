时间：2018/11/4 21:48:34   

## Linux SSH 登陆 

1. 在本地生成私钥和公钥。

		ssh-keygen -t rsa

2. 把公钥拷贝到服务器上 `root` 用户名。

		ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.0.201

3. 登陆服务器 

		ssh root@192.168.0.201
	