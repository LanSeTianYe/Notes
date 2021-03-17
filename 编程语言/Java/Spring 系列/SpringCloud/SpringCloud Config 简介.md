时间：2018-09-30 14:19:37

参考： 

1. [SpringCloud 官方文档](https://cloud.spring.io/spring-cloud-static/Finchley.SR1/single/spring-cloud.html#_spring_cloud_config)

## SpringCloud Config 简介

### 基本介绍 

* 简介

    SpringCloud 系列的配置管理中心，使用Git做配置存储仓库以及版本管理，使用 `项目名`、 `环境` 和 `label(分支)` 确定配置位置。提供API接口，可以扩展到其他不同的语言。

    特性：分离配置和具体项目、配置集中管理和配置变更下发。


* 配置文件优先级

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

* 客户端动态刷新配置信息

    ```
    调用 `http:localhost:9040/refresh`
    ```

### 配置

#### 服务端配置

服务端支持占位符和正则表达式，占位符的内容来自客户端，通过占位符可以灵活配置不同项目配置文件位置，以实现一个项目一个仓库或者一个仓库不同目录存储不同项目配置。

```yaml
spring:
  # 配置服务的名字，注册到注册中心
  application:
    name: config-server
  # 安全相关
  security:
    user:
      name: user
      password: 7a7c85ff-b90c-4700-9393-5ea3927b3289
  cloud:
    config:
      server:
        git:
          # Git 仓库地址
          uri: https://github.com/sunfeilong/config-repo
          # 搜索路径
          # search-paths: {application}
```

#### 客户端配置  

```yaml
spring:
  application:
    name: config-client
  cloud:
    config:
      name: ConfigClient
      profile: dev
      # 分支名
      label: test
      uri: http://localhost:9030
      # 服务端提供的用户名/密码
      username: user
      password: 7a7c85ff-b90c-4700-9393-5ea3927b3289
```

