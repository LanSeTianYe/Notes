##
时间：2017/5/10 15:16:33
环境：

1. CentOS7.0
2. VMware10.0.1 

##  VMware网络连接模式

 * **桥接模式（Bridge）**：直接将虚拟机添加到局域网中，使虚拟机看起来像网内的一台真实计算机，虚拟网卡和宿主物理网卡之间不存在名义上的从属关系，因而需要局域网内具有多余的IP地址能够提供给虚拟机网卡，如果局域网内严格给每台计算机分配固定的IP，那这种Bridge模式就基本失效。
 * **NAT**：NAT模式下宿主的物理网卡就充当了路由器或交换机的角色，这时VMware会根据宿主的真实IP提供很多Subset IP供虚拟机使用，这样所有的虚拟机都是通过宿主的网络端口进行对Internet的访问，但看起来这些虚拟计算机都合法地访问到了局域网或者Internet，因为他们的IP地址通过NAT技术之后看起来是合法的。
 * **HOST Only**：Host Only模式下虚拟机之间可以相互通信，但虚拟机并不能同局域网内的其他真实计算机直接通信，但该模式下通过宿主访问Internet还是可以的。 

VM的虚拟网卡可以被设置成上述的三种网络连接模式，默认情况下:

 * `VMnet0` 被设置成为Bridge模式.
 * `VMnet1` 被设置为Host Only模式，
 * `VMnet8` 的默认连接方式为NAT模式。
 * `VMnet2-VMnet7和VMnet9`这七块虚拟网卡用户可以自定义，但是在所有的虚拟网卡中仅有一块能被设置为NAT模式，默认情况就是VMnet8。

## 用Net模式进行配置

1. Windows主机修改（ip：192.168.1.68）

	* 在Windows的 `更改适配器模式`里，启用 `VMnet1` 和 `VMnet8`（如果没启用的话）。在当前Windows的网络连接（我的是以太网） `属性` 里面，选中 `VMware Bridge Protocol`，在 `共享` 里面 选中`允许其他网络通过..`， 并在 `家庭网络连接` 下拉列表选中  `VMware Network Adapter VMnet8`。

    * VMnet8 也勾选 `VMware Bridge Protocol`，VMnet8：
	
		* IP地址：192.168.0.1 （可更改，如果有默认值得话可以使用默认）
		* 子网掩码：255.255.255.0
		* 默认网关和DNS不填。

3. 编辑虚拟机网络设置

	在虚拟机的 `编辑->虚拟机网络编辑器` 里面选中 VMnet8, 勾选 `NET模式`，勾选 `将主机虚拟配置器连接到此网络`，勾选`使用本地DHCP服务将IP地址分配给虚拟机`。

	设置子网IP为 `192.168.0.0` 和子网掩码为 `255.255.255.0`。

	点击DHCP设置：设置开始IP(192.168.0.128)和结束IP(192.168.0.254)

	点击NAT设置：设置网关为Windows的VMnet8的IP地址(192.168.0.1)


4. 修改虚拟机

	查看网络信息
	
		ip address

	修改网络配置文件，根据上面看到的名字
 
		//不同机器名字可能不同
		vi /etc/sysconfig/network-scripts/ifcfg-enp2s0
		//修改下面信息
		BOOTPROTO=dhcp
		ONBOOT=true
	重启网络服务

		service network restart

	查看IP地址
	
		ip address

