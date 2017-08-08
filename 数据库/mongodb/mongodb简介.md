时间：2017/8/8 10:13:05 


## 安装

### Linux

1.  下载

		curl -O https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.0.6.tgz
2. 解压

		tar -zxvf mongodb-linux-x86_64-3.0.6.tgz
3. 更改环境变量 `sudo vim /etc/profile` 添加如下内容:

		export PATH="/home/llx/software/mongodb-linux-x86_64-3.0.6/bin:$PATH"
4. 刷新环境变量

		source /etc/profile
5. 创建数据目录

		sudo mkdir -p /data/db
5. 启动	

		mongod
6. 启动命令行

		mongo


	