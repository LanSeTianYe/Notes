## 说明文章参考
时间：2016-3-8 22:52:27 

[开涛的博客](http://jinnianshilongnian.iteye.com/blog/2018936)
## 先学习几个单词
|单词          |词性|        词义                |
|::|::|::|
|authentication| n | 证明，鉴定，身份认证，认证    |
|authenticator | n | 证明者，认证者，密码证明信号  |
|authorization | n | 授权,批准，批准(或授权)的证书|
|authorizer    |   | 核准人，授权人|
|cryptography  | n | 密码使用法，密码系统，密码输 |
|concurrency   | n | 并发(性)                   |
|realm         | n | 领域，范围，王国，部门，界   |
|subject       | n | 主题，话题，学科，科目       |
|principal     | n | 首长,主要演员,主角,当事人    |
|credential    | n | 凭证，凭据                  |

## 开始学习

### 重要的对象 `DefaultSecurityManager`
看一段代码感受一下：

    DefaultSecurityManager securityManager = new DefaultSecurityManager();

    //设置认证器
    ModularRealmAuthenticator authenticator = new ModularRealmAuthenticator();
    authenticator.setAuthenticationStrategy(new AtLeastOneSuccessfulStrategy());
    securityManager.setAuthenticator(authenticator);

    //设置授权器
    ModularRealmAuthorizer authorizer = new ModularRealmAuthorizer();
    authorizer.setPermissionResolver(new WildcardPermissionResolver());
    securityManager.setAuthorizer(authorizer);

    //设置获取数据的域
    JdbcRealm jdbcRealm = new JdbcRealm();
    //数据源
    DruidDataSource dataSource = new DruidDataSource();
    dataSource.setDriverClassName("com.mysql.jdbc.Driver");
    dataSource.setUrl("jdbc:mysql://localhost:3306/shiro");
    dataSource.setUsername("root");
    dataSource.setPassword("000000");
    jdbcRealm.setDataSource(dataSource);
    jdbcRealm.setPermissionsLookupEnabled(true);
    securityManager.setRealms(Arrays.asList(jdbcRealm));

    SecurityUtils.setSecurityManager(securityManager);
    Subject subject =  SecurityUtils.getSubject();
    UsernamePasswordToken token = new UsernamePasswordToken("admin", "admin");
    subject.login(token);

    Assert.isTrue(subject.isAuthenticated());
上面这段代码把，认证器、授权器，数据获取域都赋给了 `SecurityManager`， 然后我们在获取认证和授权数据以及认证和授权的时候就会使用我们设置的累进行，这些东西都统通过 `SecurityManager` 进行调度，我们自定义自己的实现的时候，只需把自定义的认证、授权和数据获取赋给 `SecurityManager` 就可以实现自动的认证，授权。

