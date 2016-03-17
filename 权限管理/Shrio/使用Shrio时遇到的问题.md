### 说明
* 创建时间 : 2016-3-8 22:18:55 
* Shrio版本: 

        <dependency>
            <groupId>org.apache.shiro</groupId>
            <artifactId>shiro-all</artifactId>
            <version>1.2.4</version>
        </dependency>
* 内容： 记录使用Shrio的过程中遇到的问题，以及分析


### 简单问题
1. 通过 `.ini` 文件创建 `IniSecurityManagerFactory` 的时候，出现 `.ini` 文件找不到的错误，原因是文件的路径写法有问题。  
错误的写法;

		factory = new IniSecurityManagerFactory("auth.ini");
正确的写法:

		factory = new IniSecurityManagerFactory("classpath:auth.ini");
`IniSecurityManagerFactory` 是创建 `securityManager` 的工厂，其需要一个`.ini`配置文件路径，其支持 `classpath`（类路径）、 `file`（文件系统）、  `url` （网络）三种路径格式，默认是文件系统；

2. 
### 略复杂的问题

### 由深意的问题