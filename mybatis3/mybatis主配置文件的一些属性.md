## 一些属性
* properties  配置一些常用属性

		<!-- properties属性,可以从其他文件加载 -->
		<properties resource="./config/config.properties">
			<property name="username" value="root"/>
			<property name="password" value="000000"/>
		</properties>
config.properties

		url=jdbc\:mysql\://127.0.0.1\:3306/mybatis20151125
		driver=com.mysql.jdbc.Driver

* setting 一些设置

 * `cacheEnabled` boolean 这个配置使全局的映射器启用或禁用
缓存。
 * `lazy LoadingEnabled` boolean 全局启用或禁用延迟加载。当禁用时，所有关联对象都会即时加载。
 * `aggressiveLazyLoading` booelan 当启用时，有延迟加载属性的对象在被调用时将会完全加载任意属性。否则，每种属性将会按需要加载。
 * `multipleResultSetsEnabled` boolean 允许或不允许多种结果集从一个单独的语句中返回（需要适合的驱动）。
 * `useColumnLabel ` boolean 使用列标签代替列名。不同的驱动在这方便表现不同。参考驱动文档或充分测试两种方法来决定所使用的驱动。
 * `useGeneratedKeys` boolean 允许 JDBC 支持生成的键。需要适合的驱动。如果设置为 true 则这个设置强制生成的键被使用，尽管一些驱动拒绝兼容但仍然有效（比如 Derby）。
 * `autoMappingBehavior` boolean 指定 MyBatis 如何自动映射列到字段/属性。PARTIAL 只会自动映射简单，没有嵌套的结果。FULL 会自动映射任意复杂的结果（嵌套的或其他情况）。  
     * NONE
     * PARTIAL
     * FULL 
 * `defaultExecutorType` 配置默认的执行器。SIMPLE 执行器没有什么特别之处。REUSE 执行器重用预处理语句。BATCH 执行器重用语句
和批量更新.
 * `defaultStatementTimeout` 设置超时时间，它决定驱动等待一个数据库响应的时间。任何正整数，默认没有设置。


			<settings>
				<setting name="cacheEnabled" value="true"/>
				<setting name="lazyLoadingEnabled" value="true"/>
				<setting name="multipleResultSetsEnabled" value="true"/> 
				<setting name="useColumnLabel" value="true"/>
				<setting name="useGeneratedKeys" value="false"/>
				<setting name="enhancementEnabled" value="false"/>
				<setting name="defaultExecutorType" value="SIMPLE"/>
				<setting name="defaultStatementTimeout" value="25000"/>
			</settings>
 
* `typeAliases ` 类型别名是为 Java 类型命名一个短的名字。它只和 XML 配置有关，只用来减少类完全限定名的多余部分。

		<!--类的别名-->
	    <typeAliases> 
	        <typeAlias alias="User" type="com.sun.useMyBatis3.useMyBatis3.model.User"/> 
	    </typeAliases> 
 * 内建类型别名

			_byte       byte
			_long       long
			_short      short
			_int        int
			_integer    int
			_double     double
			_float      float
			_boolean    boolean
			string      String
			byte        Byte
			long        Long
			short       Short
			int         Integer
			integer     Integer
			double      Double
			float       Float
			boolean     Boolean
			date        Date
			decimal     BigDecimal
			bigdecimal  BigDecimal 
			object      Object
			map         Map
			hashmap     HashMap
			list        List
			arraylist   ArrayList
			collection  Collection
			iterator    Iterator
* typeHandlers 类型处理器

    > 无论是 MyBatis 在预处理语句中设置一个参数，还是从结果集中取出一个值时，类型处
理器被用来将获取的值以合适的方式转换成 Java 类型。下面这个表格描述了默认的类型处
理器。

		类型处理器              Java 类型           JDBC 类型
		BooleanTypeHandler     Boolean，boolean    任何兼容的布尔值
		ByteTypeHandler        Byte，byte          任何兼容的数字或字节类型
		ShortTypeHandler       Short，short        任何兼容的数字或短整型
		IntegerTypeHandler     Integer，int        任何兼容的数字和整型
		LongTypeHandler        Long，long          任何兼容的数字或长整型
		FloatTypeHandler       Float，float        任何兼容的数字或单精度浮点型
		DoubleTypeHandler      Double，double      任何兼容的数字或双精度浮点型
		BigDecimalTypeHandler  BigDecimal          任何兼容的数字或十进制小数类型
		StringTypeHandler      String              CHAR 和 VARCHAR 类型
		ClobTypeHandler        String              CLOB 和 LONGVARCHAR 类型
		NStringTypeHandler     String              NVARCHAR 和 NCHAR 类型
		NClobTypeHandler       String              NCLOB 类型
		ByteArrayTypeHandler   byte[]              任何兼容的字节流类型
		BlobTypeHandler        byte[]              BLOB 和 LONGVARBINARY 类型
		DateTypeHandler        Date（java.util ）  TIMESTAMP 类型
		DateOnlyTypeHandler    Date（java.util ）  DATE 类型
		TimeOnlyTypeHandler    Date（java.util ）  TIME 类型
		SqlTimestampTypeHandler  Timestamp（java.sql ）  TIMESTAMP 类型
		SqlDateTypeHandler     Date（java.sql ）   DATE 类型
		SqlTimeTypeHandler     Time（java.sql ）   TIME 类型
		ObjectTypeHandler      任意  其他或未指定类型
		EnumTypeHandler        Enumeration 类型    VARCHAR-任何兼容的字符串类型，
		作为代码存储（而不是索引）。

* plugins MyBatis 允许你在某一点拦截已映射语句执行的调用。默认情况下，MyBatis 允许使用
插件来拦截方法调用

* environments 可以配置多个数据库，多数据库需要指定，environment参数，否则使用默认的

		SqlSessionFactory factory = sqlSessionFactoryBuilder.build(reader, environment);
		SqlSessionFactory  factory  =  sqlSessionFactoryBuilder.build(reader, 
		environment,properties);
	默认

		SqlSessionFactory factory = sqlSessionFactoryBuilder.build(reader);
		SqlSessionFactory factory = sqlSessionFactoryBuilder.build(reader,properties);
简单配置

		<environments default="development">
			<environment id="development">
				<transactionManager type="JDBC">
					<property name="..." value="..."/>
				</transactionManager>
				<dataSource type="POOLED">
					<property name="driver" value="${driver}"/>
					<property name="url" value="${url}"/>
					<property name="username" value="${username}"/>
					<property name="password" value="${password}"/>
				</dataSource>
			</environment>
		</environments>

 *  默认的环境 ID（比如：default=”development”）。
 *  每个 environment 元素定义的环境 ID（比如：id=”development”）。
 *  事务管理器的配置（比如：type=”JDBC”）。
 *  数据源的配置（比如：type=”POOLED”）。


* transactionManager 事务管理  

 * JDBC  –  这个配置直接简单使用了 JDBC 的提交和回滚设置。它依赖于从数据源得
到的连接来管理事务范围。
 * MANAGED  –  这个配置几乎没做什么。它从来不提交或回滚一个连接。而它会让容器来管理事务的整个生命周期（比如 Spring 或 JEE 应用服务器的上下文）。默认情况下它会关闭连接。然而一些容器并不希望这样，因此如果你需要从连接中停止它，将 closeConnection 属性设置为 false。

* dataSsource 数据源 
 * UNPOOLED  –  这个数据源的实现是每次被请求时简单打开和关闭连接。它有一点慢，这是对简单应用程序的一个很好的选择，因为它不需要及时的可用连接。不同的数据库对这个的表现也是不一样的，所以对某些数据库来说配置数据源并不重要，这个配置也是闲置的。UNPOOLED 类型的数据源仅仅用来配置以下 5 种属性
     * driver  –   这是 JDBC 驱动的 Java 类的完全限定名（如果你的驱动包含的有，它也
不是数据源类）。
     *  url –   这是数据库的 JDBC URL 地址。
     *  username –   登录数据库的用户名。
     *  password –  登录数据库的密码。
     *  defaultTransactionIsolationLevel  –   默认的连接事务隔离级别。
作为可选项，你可以传递数据库驱动的属性。要这样做，属性的前缀是以“driver.”开
头的，例如：
     *  driver.encoding=UTF8 这样就会传递以值 “ UTF8 ” 来传递 “ encoding ”属性，它是 通过DriverManager.getConnection(url,driverProperties) 方法传递给数据库驱动

 * POOLED  –  这是 JDBC 连接对象的数据源连接池的实现，用来避免创建新的连接实例时必要的初始连接和认证时间。这是一种当前 Web 应用程序用来快速响应请求很流行的方法。
     * poolMaximumActiveConnections  –   在任意时间存在的活动（也就是正在使用）连接的数量。默认值：10
     *  poolMaximumIdleConnections  –   任意时间存在的空闲连接数。
     *  poolMaximumCheckoutTime  –   在被强制返回之前， 池中连接被检查的时间。默认值：20000 毫秒（也就是 20 秒）
     *  poolTimeToWait  –  这是给连接池一个打印日志状态机会的低层次设置，还有重新尝试获得连接，这些情况下往往需要很长时间（为了避免连接池没有配置时静默失败）。默认值：20000 毫秒（也就是 20 秒）
     *  poolPingQuery –  发送到数据的侦测查询，用来验证连接是否正常工作，并且准备接受请求。默认是“NO  PING  QUERY  SET”，这会引起许多数据库驱动连接由一个错误信息而导致失败。
     * poolPingEnabled  –  这是开启或禁用侦测查询。如果开启，你必须用一个合法的SQL 语句（最好是很快速的）设置 poolPingQuery 属性。默认值：false。
     *  poolPingConnectionsNotUsedFor这是用来配置 poolPingQuery 多次时间被用一次。这可以被设置匹配标准的数据库连接超时时间，来避免不必要的侦测。默认值：0（也就是所有连接每一时刻都被侦测-但仅仅当 poolPingEnabled 为 true 时适用）

 * JNDI  –  这个数据源的实现是为了使用如 Spring 或应用服务器这类的容器，容器可以集中或在外部配置数据源，然后放置一个 JNDI 上下文的引用。这个数据源配置只需要两个属性：

     * `initial_context` 这个属性用来从初始上下文中寻找环境（也就是initialContext.lookup（initial——context））。这是个可选属性，如果被忽略，那么data_source 属性将会直接以 initialContext 为背景再次寻找。
     * `data_source`   这是引用数据源实例位置的上下文的路径。它会以由 initial_context查询返回的环境为背景来查找，如果 initial_context 没有返回结果时，直接以初始上下文为环境来查找。   
    和其他数据源配置相似，它也可以通过名为“env.”的前缀直接向初始上下文发送属性。
比如：
     * env.encoding=UTF8 在初始化之后，这就会以值“UTF8”向初始上下文的构造方法传递名为“encoding”的属性。
* mappers

	    <!-- 对应的Mapper -->
	    <mappers>
	        <mapper resource="com/sun/useMyBatis3/useMyBatis3/model/User.xml"/>
	    </mappers>