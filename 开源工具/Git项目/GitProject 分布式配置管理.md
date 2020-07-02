时间：2018/8/24 9:50:16 

参考： 


##  分布式配置管理

### [spring cloud config](https://github.com/spring-cloud/spring-cloud-config)

Spring 官方提供的分布式系统外部配置项目。可以很方便的整合 `Spring Boot` 项目，基于Git的配置，配置文件类似于实际开发环境的配置文件，对于小型项目使用起来相对方便。

官方文档可参考：[官网首页](https://cloud.spring.io/spring-cloud-config/)

#### 特性：
* 服务端：
	* 默认使用基于Git的数据持久化，也可使用数据库等其它数据持久化方式。
	* 基于资源的 HTTP API，支持获取指定环境数据，也可获取整个配置文件。
	* 数据加密支持对称和非对称加密。
	* 通过 `@EnableConfigServer` 注解，很容易和 `Spring Boot` 项目整合。
* 客户端：
	* 通过HTTP接口获取配置信息，客户端可以自己实现实时更新机制（定时拉取等）。
	* 加密解密属性值。
	* 缓存配置数据到本地文件系统，当服务器宕机之后从本地缓存文件读取配置数据。

#### 配置文件优先级

配置文件命名规则: `{application_name}-{profiles}.[properties|yml]`, 由上到下，下面文件里的相同配置的会覆盖上面的：

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
* 基于 `git` 实现配置文件持久化，数据的安全依赖于文件系统安全，数据备份和恢复比较简单。
* 提供获取配置信息的HTTP接口，客户端没有实现自动更新机制，需开发者自己实现。
### [apoolo](https://github.com/ctripcorp/apollo)

Apollo（阿波罗）是携程框架部门研发的分布式配置中心，能够集中化管理应用不同环境、不同集群的配置，配置修改后能够实时推送到应用端，并且具备规范的权限、流程治理等特性，适用于微服务配置管理场景。

大公司，项目很多的情况下使用，分布式部署有一定复杂性，但是部署完之后，基本属于一劳永逸的事情，推荐使用。

#### 特性和功能：  

* WEB可视化管理界面，功能十分完善。
	* 演示地址: [http://140.143.100.23:8070/signin](http://140.143.100.23:8070/signin)
	* 用户名/密码：apollo/admin
* 批量发布配置信息，每次发布为一个版本，支持版本回滚。
* 提供关联功能，公共配置可被其它配置依赖，私有配置只对对应环境有效。
* 灰度发布，只更新指定服务器的配置信息，灰度发布确认成功之后，全量发布即可合并到主版本。
* 提供用户和权限管理。
* 依赖MySQL数据库，通过数据库实现事件发布。集群部署依赖 `Eureka`, 也需要依赖软负载均衡。
* 参数更新之后把参数信息保存到本地文件系统，当服务器宕机时不影响项目运行。
* 配置划分：环境（dev/pre..）/集群(不同集群的配置)/命名空间，三级层次划分，配置灵活。
* 提供基于HTTP的配置信息获取接口，支持跨语言使用。
#### 优缺点

* 基于数据库实现配置参数持久化，提供Web配置界面，相对于 `Git` 更加灵活。
* 自动更新，配置发布之后，客户端通过长连接和事件推动方式更新本地配置。  

### [xxl-conf](https://github.com/xuxueli/xxl-conf)

XXL-CONF 是一个分布式配置管理平台，拥有"强一致性、毫秒级动态推送、多环境、多语言、配置监听、权限控制、版本回滚"等特性。现已开放源代码，开箱即用。

开源时间相对较短，功能不是十分完善。
#### 特性和功能  

* 功能简单，容易理解上手快，目前项目处于发展阶段。
* 通过 `环境 + 项目区分不同` 区分不同环境的不同项目，概念相对清晰。
* 依赖MySQL数据库和Zookeeper，所有配置信息都会存放在Zookeeper中，当配置信息数量较大时Zookeeper服务器对内存要求较高（一般项目的配置信息很难达到很大的量级）。
* 基于 `key-value` 方式的配置，一次只可以更新一个变量，变量创建之后会在Zookeeper上创建对应节点，客户端监听节点变更事件，更新本地配置。
* 通过Zookeeper也可以跨语言使用。 
