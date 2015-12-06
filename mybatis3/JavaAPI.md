## JAVA API 部分

* 通过用的JAVA-WEB项目目录结构

![通用的目录结构图片](http://7xle4i.com1.z0.glb.clouddn.com/mybatismyBatis通用的目录结构.jpg)


### JAVA 对象的创建顺序

	SqlSessionFactoryBuilder->SqlSessionFactory->SqlSession(执行相应的Sql操作)
描述：SqlSessionFactoryBuilder可以通过xml、注解和手动配置来创建SqlSessionFactory

	SqlSessionFactory build(Reader reader)
	SqlSessionFactory build(Reader reader, String environment) 
	SqlSessionFactory build(Reader reader, Properties properties)
	SqlSessionFactory build(Reader reader, String env, Properties props)
	SqlSessionFactory build(Configuration config)

	//Reader 对应的xml配置文件
	//Environment 决定加载哪种环境，包括数据源和事务管理器。在主配置文件中进行配置，通过id进行指定
			<environments default=" development">
				<environment id=" development">
					<transactionManager type="JDBC">
					…
					<dataSource type="POOLED">
					…
				</environment>
				<environment id=" production">
					<transactionManager type="EXTERNAL">
					…
					<dataSource type="JNDI">
					…
				</environment>
			</environments>
	//Properties 把一些值定义在配置文件中，可以在xml文件中以${name}的方式使用
	注意：当一个属性存在多个配置文件中的时候的加载顺序
	1、在 properties 元素体中指定的属性首先被读取		//在主配置文件的<property>标签
	   里面
	2、从 properties 元素的类路径 resource 或 url 指定的属性第二个被读取，可以覆盖已经
	   指定的重复属性
	3、作为方法参数传递的属性最后被读取，可以覆盖已经从 properties 元素体和
	   resource/url 属性中加载的任意重复属性。

穿件具体的SqlSessionFactory的示列

	private static SqlSessionFactory sqlSessionFactory;
	private static Reader reader;
	
	static {
		try{
			//加载配置文件中的配置
			reader = Resources.getResourceAsReader("Configuration.xml");
			//初始SqlSession 工厂类
			sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

### SqlSessionFactory创建SqlSession（6种方法）
1. Transaction （事务）：你想为 session 使用事务或者使用自动提交（通常意味着很多数据库和/或 JDBC 驱动没有事务）？
2. Connection（连接）：你想 MyBatis 获得来自配置的数据源的连接还是提供你自己定义的连接？
3. Execution （执行）： 你想 MyBatis 复用预处理语句和/或批量更新语句（包括插入和删除）？

重载的 openSession()方法签名设置允许你选择这些可选中的任何一个组合。

	SqlSession openSession()
	SqlSession openSession(boolean autoCommit)
	SqlSession openSession(Connection connection)
	SqlSession openSession(TransactionIsolationLevel level)
	SqlSession openSession(ExecutorType execType,
	TransactionIsolationLevel level)
	SqlSession openSession(ExecutorType execType)
	SqlSession openSession(ExecutorType execType, boolean autoCommit)
	SqlSession openSession(ExecutorType execType, Connection connection)
	Configuration getConfiguration();
默认的 openSession()方法没有参数，它会创建有如下特性的 SqlSession：

* 将会开启一个事务（也就是不自动提交）范围
* 连接对象会从由活动环境配置的数据源实例中得到
* 事务隔离级别将会使用驱动或数据源的默认设置
* 预处理语句不会被复用，也不会批量处理更新

**TransactionIsolationLevel**  包含5个级别

* NONE 
* READ_UNCOMMITTED
* READ_COMMITTED
* REPEATABLE_READ
* SERIALIZABLE

**ExecutorType**

* ExecutorType.SIMPLE 这个执行器类型不做特殊的事情。它为每个语句的执行创建一个新的预处理语句
* ExecutorType.REUSE 这个执行器类型会复用预处理语句。
* ExecutorType.BATCH 这个执行器会批量执行所有更新语句，如果 SELECT 在它们中间执行还会标定它们是必须的，来保证一个简单并易于理解的行为

### SqlSession
* 语句执行方法

    这些方法被用来执行定义在 SQL 映射的 XML 文件中的 SELECT，INSERT，UPDATE
和 DELETE 语句。它们都会自行解释，每一句都使用语句的 ID 属性和参数对象，参数可以
是原生类型（自动装箱或包装类），JavaBean，POJO 或 Map。

		Object selectOne(String statement, Object parameter)
		List selectList(String statement, Object parameter)
		int insert(String statement, Object parameter)
		int update(String statement, Object parameter)
		int delete(String statement, Object parameter)
    selectOne 和 selectList 的不同仅仅是 selectOne 必须返回一个对象。如果多余一个，或者
没有返回（或返回了 null ），那么就会抛出异常。如果你不知道需要多少对象，使用 selectList。
如果你想检查一个对象是否存在，那么最好返回统计数（0 或 1）。因为并不是所有语句都需
要参数，这些方法都是有不同重载版本的，它们可以不需要参数对象。

		Object selectOne(String statement)
		List selectList(String statement)
		int insert(String statement)
		int update(String statement)
		int delete(String statement)

    最后，还有查询方法的三个高级版本，它们允许你限制返回行数的范围，或者提供自定
义结果控制逻辑，这通常用于大量的数据集合。

		List selectList(String statement, Object parameter, RowBounds rowBounds)
		void select (String statement, Object parameter, ResultHandler handler)
		void select (String statement, Object parameter, RowBounds rowBounds,ResultHandler handler)
RowBounds 设置跳过多少行，然后保留多少行的信息

* 事务控制方法

    控制事务范围有四个方法。当然，如果你已经选择了自动提交或你正在使用外部事务管理器，这就没有任何效果了。然而，如果你正在使用 JDBC 事务管理员，由 Connection 实例来控制，那么这四个方法就会派上用场：

	void commit()
	void commit(boolean force)
	void rollback()
	void rollback(boolean force)

    默认情况下 MyBatis 不会自动提交事务，除非它侦测到有插入，更新或删除操作改变了
数据库。如果你已经做出了一些改变而没有使用这些方法，那么你可以传递 true 到 commit和 rollback 方法来保证它会被提交 （注意，你不能在自动提交模式下强制 session，或者使用了外部事务管理器时）。很多时候你不用调用 rollback()，因为如果你没有调用 commit 时MyBatis 会替你完成。然而，如果你需要更多对多提交和回滚都可能的 session 的细粒度控制，你可以使用回滚选择来使它成为可能。

* 清理 Session 级的缓存

		void clearCache()

	SqlSession 实例有一个本地缓存在执行 update，commit，rollback 和 close 时被清理。要明确地关闭它（获取打算做更多的工作），你可以调用 clearCache()。

* 确保 SqlSession 被关闭，最好在finally里面关闭

		void close()

### 把对应的查询映射到接口上面，通过接口的方法调用相应的Sql语句


	public interface UserImpl {
		
		public User selectUserByID(int id);
		
		public HashMap<String,Object> selectPasswordAndAgeByID(int id);
		
		public User selectByIdUseResultMap(int id);
	}


### SelectBuilder 在Java代码中嵌入SQL语句的解决方案

需要静态引入  import static org.mybatis.jdbc.SelectBuilder.* ;

	private String selectPersonSql() {
		BEGIN(); // Clears ThreadLocal variable
		SELECT("P.ID, P.USERNAME, P.PASSWORD, P.FULL_NAME");
		SELECT("P.LAST_NAME, P.CREATED_ON, P.UPDATED_ON");
		FROM("PERSON P");
		FROM("ACCOUNT A");
		INNER_JOIN("DEPARTMENT D on D.ID = P.DEPARTMENT_ID");
		INNER_JOIN("COMPANY C on D.COMPANY_ID = C.ID");
		WHERE("P.ID = A.ID");
		WHERE("P.FIRST_NAME like ?");
		OR();
		WHERE("P.LAST_NAME like ?");
		GROUP_BY ("P.ID");
		HAVING("P.LAST_NAME like ?");
		OR();
		HAVING("P.FIRST_NAME like ?");
		ORDER_BY ("P.ID");
		ORDER_BY ("P.FULL_NAME");
		return SQL();
	}

等价于

	"SELECT P.ID, P.USERNAME, P.PASSWORD, P.FULL_NAME, "
	"P.LAST_NAME,P.CREATED_ON, P.UPDATED_ON " +
	"FROM PERSON P, ACCOUNT A " +
	"INNER JOIN DEPARTMENT D on D.ID = P.DEPARTMENT_ID " +
	"INNER JOIN COMPANY C on D.COMPANY_ID = C.ID " +
	"WHERE (P.ID = A.ID AND P.FIRST_NAME like ?) " +
	"OR (P.LAST_NAME like ?) " +
	"GROUP BY P.ID " +
	"HAVING (P.LAST_NAME like ?) " +
	"OR (P.FIRST_NAME like ?) " +
	"ORDER BY P.ID, P.FULL_NAME";

直接拼Sql语句的方法可能在拼接的过程中会出现问题。

### SqlBuilder

	public String insertPersonSql() {
		BEGIN(); // Clears ThreadLocal variable
		INS ERT_ INTO("PERSON");
		VALUES ("ID, FIRST_NAME", "${id}, ${firstName}");
		VALUES ("LAST_NAME", "${lastName}");
		return SQL();
	}