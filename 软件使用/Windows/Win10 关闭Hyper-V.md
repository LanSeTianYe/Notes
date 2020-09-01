时间：2018/2/8 21:16:14   

参考：  

1. [Windows 10 下如何彻底关闭 Hyper-V 服务？](https://www.zhihu.com/question/38841757)  

##  Win10 关闭 Hyper-V  

* 关闭（需要重启电脑才能生效）：

		bcdedit /set hypervisorlaunchtype off

* 开启（需要重启电脑才能生效）：  

		bcdedit /set hypervisorlaunchtype auto