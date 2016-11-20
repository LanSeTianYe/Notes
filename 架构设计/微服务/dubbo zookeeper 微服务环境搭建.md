##

日期：2016-11-20 16:38:36   
环境：  
1. [dubbo-2.8.4](http://pan.baidu.com/s/1sltlR5b)  
2. Spring Boot 项目
##

### 简介
微服务，把 Service 注册到 zookeeper ， 然后需要获取 Service 的地方到 zookeeper 中取出所需的 Service。

同一个 Service 可以在 zookeeper 中注册多个， 当需要获取 service 的时候， zookeeper 会根据一定的策略，调用其中一个。


### 搭建
#### 服务提供端
1. 本地安装dubbo包 ，在 dubbo，所在文件夹里，按住SHIFT 同时点击鼠标右键，选择打开命令行，执行如下代码：

        mvn install:install-file -Dfile=./dubbo-2.8.4.jar -DgroupId=com.alibaba -DartifactId=dubbo -Dpackaging=jar -Dversion=2.8.4

    

1. pom 配置文件中添加如下依赖

        <!--dubbo依赖 开始-->
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>dubbo</artifactId>
        </dependency>
        <dependency>
            <groupId>com.esotericsoftware.kryo</groupId>
            <artifactId>kryo</artifactId>
        </dependency>
        <dependency>
            <groupId>de.javakaffee</groupId>
            <artifactId>kryo-serializers</artifactId>
        </dependency>
        <dependency>
            <groupId>org.apache.zookeeper</groupId>
            <artifactId>zookeeper</artifactId>
        </dependency>
        <dependency>
            <groupId>com.101tec</groupId>
            <artifactId>zkclient</artifactId>
        </dependency>
        <!--dubbo依赖 结束-->

2. 控制 jar 包的版本

        <!--版本号属性-->
        <properties>
        

            <dubbo-version>2.8.4</dubbo-version>
            <kryo-version>2.24.0</kryo-version>
            <kryo-serializers-version>0.26</kryo-serializers-version>
            <zookeeper-version>3.4.8</zookeeper-version>
            <zookeeper-client-version>0.7</zookeeper-client-version>
            <hessian-version>4.0.38</hessian-version>
        
        </properties>

        <!--在项目需要依赖列表里面的jar包的时候，提供版本优先选择-->
        <dependencyManagement>
            <dependencies>
                <!--dubbo依赖(版本控制)   开始-->
                <dependency>
                    <groupId>com.alibaba</groupId>
                    <artifactId>dubbo</artifactId>
                    <version>${dubbo-version}</version>
                    <exclusions>
                        <exclusion>
                            <groupId>org.springframework</groupId>
                            <artifactId>spring</artifactId>
                        </exclusion>
                        <exclusion>
                            <groupId>javax.servlet</groupId>
                            <artifactId>javax.servlet-api</artifactId>
                        </exclusion>
                        <exclusion>
                            <artifactId>commons-codec</artifactId>
                            <groupId>commons-codec</groupId>
                        </exclusion>
                        <exclusion>
                            <groupId>log4j</groupId>
                            <artifactId>log4j</artifactId>
                        </exclusion>
                    </exclusions>
                </dependency>
    
                <dependency>
                    <groupId>de.javakaffee</groupId>
                    <artifactId>kryo-serializers</artifactId>
                    <version>${kryo-serializers-version}</version>
                </dependency>
    
                <dependency>
                    <groupId>org.apache.zookeeper</groupId>
                    <artifactId>zookeeper</artifactId>
                    <version>${zookeeper-version}</version>
                    <exclusions>
                        <exclusion>
                            <groupId>org.slf4j</groupId>
                            <artifactId>slf4j-log4j12</artifactId>
                        </exclusion>
                    </exclusions>
                </dependency>
    
                <dependency>
                    <groupId>com.101tec</groupId>
                    <artifactId>zkclient</artifactId>
                    <version>${zookeeper-client-version}</version>
                    <exclusions>
                        <exclusion>
                            <groupId>org.slf4j</groupId>
                            <artifactId>slf4j-log4j12</artifactId>
                        </exclusion>
                    </exclusions>
                </dependency>
    
                <dependency>
                    <groupId>com.caucho</groupId>
                    <artifactId>hessian</artifactId>
                    <version>${hessian-version}</version>
                </dependency>
    
                <dependency>
                    <groupId>com.esotericsoftware.kryo</groupId>
                    <artifactId>kryo</artifactId>
                    <version>${kryo-version}</version>
                </dependency>
    
                <!--dubbo依赖(版本控制)   结束-->
    
            </dependencies>
        </dependencyManagement>

4. Service 配置 

        @Service
        @com.alibaba.dubbo.config.annotation.Service(protocol = { "dubbo" })
        public class AuthorityResourceServiceImpl implements AuthorityResourceService {
        
            @Autowired
            private AuthorityResourceRepository authorityResourceRepository;
        
            @Override
            @Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
            public List<AuthorityResource> getAllAuthorityResource() {
                return authorityResourceRepository.findAll();
            }
        }
5. 配置文件 `dubbo-provider.xml`

        <?xml version="1.0" encoding="UTF-8"?>
        <beans xmlns="http://www.springframework.org/schema/beans"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:dubbo="http://code.alibabatech.com/schema/dubbo"
               xsi:schemaLocation="http://www.springframework.org/schema/beans
            http://www.springframework.org/schema/beans/spring-beans.xsd
            http://code.alibabatech.com/schema/dubbo
            http://code.alibabatech.com/schema/dubbo/dubbo.xsd">
        
        
            <!-- 提供方应用名称信息，方便dubbo管理页面知道是哪个应用暴露出来的 -->
            <dubbo:application name="xiao_tian_provider" />
        
            <!-- 使用zookeeper注册中心暴露服务地址 -->
            <dubbo:registry address="zookeeper://127.0.0.1:2181" />
        
            <dubbo:protocol name="dubbo" port="20881"  serialization="kryo"/>
        
        

            <!--提供远程服务-->
            <dubbo:service ref="authorityResourceService" interface="com.sun.xiaotian.authority.service.AuthorityResourceService"  loadbalance="leastactive" />
        </beans>

6. 引用配置文件，启动类


        @SpringBootApplication
        @EnableTransactionManagement
        @Controller
        @ImportResource("classpath:dubbo-provider.xml")
        public class RunProjectApplication {
        
            public static void main(String[] args) throws Exception {
                //设置 dubbo 的日志系统
                System.setProperty("dubbo.application.logger", "slf4j");
                SpringApplication.run(RunProjectApplication.class, args);
            }
        
            @RequestMapping("/")
            public String index() {
                return "/view/index.html";
            }
        
            @RequestMapping("/login")
            public String login() {
                return "/view/login/login.html";
            }
        
        }


#### 服务使用端

1. pom 文件， 服务提供端 第1、2步。需要依赖服务提供端。
2. dubbo 配置文件

        <?xml version="1.0" encoding="UTF-8"?>
        <beans xmlns="http://www.springframework.org/schema/beans"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:dubbo="http://code.alibabatech.com/schema/dubbo"
               xsi:schemaLocation="http://www.springframework.org/schema/beans
            http://www.springframework.org/schema/beans/spring-beans.xsd
            http://code.alibabatech.com/schema/dubbo
            http://code.alibabatech.com/schema/dubbo/dubbo.xsd">
        
            <!-- 提供方应用名称信息，方便dubbo管理页面知道是哪个应用暴露出来的 -->
            <dubbo:application name="xiao_tian_consume" />
        
            <!-- 使用zookeeper注册中心暴露服务地址 -->
            <dubbo:registry address="zookeeper://127.0.0.1:2181" />
        
            <!--提供远程服务-->
            <dubbo:reference id="authorityResourceService" interface="com.sun.xiaotian.authority.service.AuthorityResourceService" retries="0" />
        </beans>
3. 引用配置文件，已经测试。

        
        @SpringBootApplication
        @EnableTransactionManagement
        @RestController
        @ImportResource("classpath:dubbo-consume.xml")
        public class RunProjectApplication {
        
            @Autowired
            private AuthorityResourceService authorityResourceService;
        
            @Autowired
            private AuthorityUserAndRoleService authorityUserAndRoleService;
        
        
            public static void main(String[] args) throws Exception {
                //设置 dubbo 的日志系统
                System.setProperty("dubbo.application.logger", "slf4j");
        
                SpringApplication.run(RunProjectApplication.class, args);
            }
        
            @RequestMapping("/test")
            public SystemMessage test() {
                SystemMessage systemMessage = new SystemMessage();
                systemMessage.setData(authorityResourceService.getAllAuthorityResource());
                return systemMessage;
            }
            
        }


#### 启动服务
1. 启动zookeeper。
2. 启动服务提供端。
3. 启动服务调用端。

