时间 ： 2017/1/7 20:21:39

参考内容：  

1. [http://blog.csdn.net/cashey1991/article/details/6982809](http://blog.csdn.net/cashey1991/article/details/6982809)
2. [http://blog.csdn.net/cashey1991/article/details/6982761](http://blog.csdn.net/cashey1991/article/details/6982761)
3. [http://itbbs.pconline.com.cn/network/50909078.html](http://itbbs.pconline.com.cn/network/50909078.html)
***************

### 环境
1. win8


### 解决问题
避免局域网里面的APR攻击。
### 解决方法
1. 静态绑定网管和路由器的Mac地址。
	1. 查看电脑当前连接网络的idx,我的是 13. 

			netsh i i show in
		内容

			C:\Users\sunfeilong1993>netsh i i show in
	
			Idx     Met         MTU          状态                名称
			---  ----------  ----------  ------------  ---------------------------
			  1          50  4294967295  connected     Loopback Pseudo-Interface 1
			 13          20        1500  connected     以太网
			114          10        1500  disconnected  本地连接 3

	2. 清空绑定信息, 13是idx。

		 	netsh -c "i i" delete neighbors 13
	3. 进入路由器查看路由器的mac地址。
	4. 静态绑定默认网关和路由mac地址。
			
			netsh -c "i i" add  neighbors 13 192.168.1.1  e4-35-c8-f4-6d-26
	5. 查看绑定信息。 
	 
			arp -a
 	内容

			192.168.1.1           e4-35-c8-f4-6d-26     静态
			192.168.1.73          0c-84-dc-0b-4e-9d     动态
			192.168.1.255         ff-ff-ff-ff-ff-ff     静态
			224.0.0.22            01-00-5e-00-00-16     静态
			224.0.0.251           01-00-5e-00-00-fb     静态
			224.0.0.252           01-00-5e-00-00-fc     静态
			239.255.255.250       01-00-5e-7f-ff-fa     静态
			255.255.255.255       ff-ff-ff-ff-ff-ff     静态