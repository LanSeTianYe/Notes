时间：2018/8/24 9:50:16 

参考： 


##  分布式配置管理

### [spring cloud config](https://github.com/spring-cloud/spring-cloud-config)

Spring 官方提供的分布式系统外部配置项目。可以很方便的整合 `Spring Boot` 项目。

官方文档可参考：[官网首页](https://cloud.spring.io/spring-cloud-config/)

#### 特性：
* 服务端：
	* 默认使用基于Git的数据持久化，也可以是配置使用数据库。
	* 基于资源的 HTTP API。
	* 数据加密支持对称和非对称加密。
	* 通过 `@EnableConfigServer` 注解，很容易和 `Spring Boot` 项目整合。
	* 配置更新时间通知。
* 客户端：
	* 通过远程属性源，更行本地环境。
	* 加密解密属性值。
	* 缓存配置数据到本地文件系统。

#### 配置文件优先级

配置文件命名规则: `{application_name}-{profiles}-.[properties|yml]`, 由上到下，下面文件里的相同配置的会覆盖上面的：

* application.yml
* application.properties
* application_name.yml
* application_name.properties
* application_name-profiles.yml
* application_name-profiles.properties

通过server端接口可以直接访问配置文件：

* `/{application}/{profile}[/{label}]`
* `/{application}-{profile}.yml`
* `/{label}/{application}-{profile}.yml`
* `/{application}-{profile}.properties`
* `/{label}/{application}-{profile}.properties`

#### 优缺点
* 基于 `git` 实现配置文件持久化，数据的安全依赖于文件系统安全，数据恢复和备份比较简单。
### [apoolo](https://github.com/ctripcorp/apollo)

Apollo（阿波罗）是携程框架部门研发的分布式配置中心，能够集中化管理应用不同环境、不同集群的配置，配置修改后能够实时推送到应用端，并且具备规范的权限、流程治理等特性，适用于微服务配置管理场景。

#### 特性和功能：  

* WEB可视化管理界面。
	* 演示地址: [http://140.143.100.23:8070/signin](http://140.143.100.23:8070/signin)
	* 用户名/密码：apollo/admin
* 配置划分：环境（dev/pre..）/集群(不同集群的配置)/命名空间。
* 配置修改实时发布。
* 配置修改版本记录。
* 灰度发布，发布变更到部分环境，提供撤销发发布功能。
* 用户权限管理。
* 客户端信息监控配置，参数被那些服务使用。
* 部署简单。
* 依赖Java和MySQL。
* 参数更新之后把参数信息保存到本地文件系统，当服务器宕机时不影响项目运行。

#### 优缺点

* 基于数据库实现配置参数持久化，配置灵活，相对于 `Git` deng 


  
