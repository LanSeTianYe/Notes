时间：2018/10/16 15:13:11   

参考： 

1. [Blue-green Deployments, A/B Testing, and Canary Releases](http://blog.christianposta.com/deploy/blue-green-deployments-a-b-testing-and-canary-releases/)
2. [BlueGreenDeployment](https://martinfowler.com/bliki/BlueGreenDeployment.html)

## 蓝绿部署、AB测试以及金丝雀发布   

### 蓝绿部署 （Green-Blue Deployment）

部署线上环境的一种策略。

构造两个相同的线上环境，一套用于实际的线上环境，一套用于部署新版本的环境。运行实际线上环境的被称为BLue，用于部署新版本的被称为 Green。

当有新版本需要发布的时候，把经过测试的代码部署到Green环境，部署之后进行上线前的最后测试，通过测试之后把实际用户流量切换到Green环境，此时Green环境转换为Blue环境，Blue环境转换为Green环境。此时Green环境运行的是旧版本的代码，不要停止Green环境的项目，以备当Blue环境的出现问题的时候回退版本。

**存在的问题及解决方案：**

* 切换版本之间，数据库数据同步问题。
	* Blue和Green环境使用相同的数据库。
	* 切换环境之前关闭 Blue 环境的写操作，切换到 Green 之后至开启读操作，当项目稳定时再开启写操作。
	* 服务中断，停止 Blue 环境对外提供的服务，当操作完全执行结束之后，备份数据并替换 Green 环境的数据为新数据。切换请求到 Green，此时Blue和Green角色互换。

**优点：**

* 减少出问题的可能性。
* 减少线上部署服务宕机时间。

### A/B Test

测试项目新功能的一种策略。

当项目发布新版版之后，把少部分的流量路由到新版本的项目，其余流量还走旧版本的服务。当新版本的服务稳定之后，把所有的流量切换到新版本的服务上。

不同于蓝绿部署，A/B Test 侧重于测试新版本的功能。蓝绿部署侧重于安全的发布新版本。

**优点：**

* 减少由于新功能Bug影范围。

### Canary Release

新服务发布的一种策略。

在发布新服务时，只更新少部分的服务，观察新服务的运行情况。运行稳定之后就可以逐步替换全部服务。



