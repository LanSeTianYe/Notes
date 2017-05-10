## ORM框架分析

时间：2017/5/8 21:50:54  
参考文章：  
 
1. [从 iBatis 到 MyBatis](https://www.ibm.com/developerworks/cn/opensource/os-cn-mybatis/)
2. [JPA入门教程 – 终极指南](https://www.javacodegeeks.com/2015/04/jpa%E5%85%A5%E9%97%A8%E6%95%99%E7%A8%8B.html)

## ORM 简介
Object-Relational Mapping 即对象关系映射，把对象以及对象之间的关系映射到数据库表中。

将关系数据库中表的数据映射成为对象，以对象的形式展现，这样开发人员就可以把对数据库的操作转化为对这些对象的操作。因此它的目的是为了方便开发人员以面向对象的思想来实现对数据库的操作。

常用的ORM中间件有：

 * Apache OJB
 * Cayenne 
 * Jaxor 
 * Hibernate 
 * iBatis 
 * jRelationalFramework 
 * mirage 
 * SMYLE 
 * TopLink 
## 常见ORM框架比较

### 1、JPA（Java Persistence API）
Java 持久化API，是一个独立于供应商的、用于映射Java对象和关系型数据库表的规范。使得开发人员可以通过对象的方式操作数据库。使得应用程序的开发者们可以不依赖于他们工作中面对的特定数据库产品，从而开发出可以与不同数据库产品良好工作的CRUD（创建、读取、更新、删除）操作代码。

JPA由三个不同组件构成：

 * 实体（Entities）：JPA中实体是普通Java对象（POJO）。
 * 对象-关系型元数据（Object-relational metadata）：Java类和类的属性与数据库中的表和列的映射关系，可以通过配置文件或注解配置。
 * Java持久化查询语句（Java Persistence Query Language - JPQL)：因为JPA旨在建立不依赖于特定的数据库的抽象层，所以它也提供了一种专有查询语言来代替SQL。 这种由JPQL到SQL语言的转换，为JPA提供了支持不同数据库方言的特性，使得开发者们在实现查询逻辑时不需要考虑特定的数据库类型。

JPA只是一种规范，具体的实现如Hibernate、EclipseLink（toplink）和OpenJPA等。

#### 使用JPA（Hibernate实现）[源码地址](https://www.javacodegeeks.com/wp-content/uploads/2015/02/jpa.zip)

* 依赖

		<properties>
	        <jee.version>7.0</jee.version>
			<h2.version>1.3.176</h2.version>
			<hibernate.version>4.3.8.Final</hibernate.version>
	    </properties>
	
	    <dependencies>
	        <dependency>
	            <groupId>javax</groupId>
	            <artifactId>javaee-api</artifactId>
	            <version>${jee.version}</version>
	            <scope>provided</scope>
	        </dependency>
	        <dependency>
	            <groupId>com.h2database</groupId>
	            <artifactId>h2</artifactId>
	            <version>${h2.version}</version>
	        </dependency>
	        <dependency>
	            <groupId>org.hibernate</groupId>
	            <artifactId>hibernate-entitymanager</artifactId>
	            <version>${hibernate.version}</version>
	        </dependency>
	    </dependencies>

* 配置文件

		<?xml version="1.0" encoding="UTF-8" ?>
		<persistence xmlns="http://java.sun.com/xml/ns/persistence"
		             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		             xsi:schemaLocation="http://java.sun.com/xml/ns/persistence
		 http://java.sun.com/xml/ns/persistence/persistence_1_0.xsd" version="1.0">
		
		    <persistence-unit name="PersistenceUnit" transaction-type="RESOURCE_LOCAL">
				<!-- JPA实现 -->
		        <provider>org.hibernate.ejb.HibernatePersistence</provider>
		
		        <properties>
		            <property name="connection.driver_class" value="org.h2.Driver"/>
		            <property name="hibernate.connection.url" value="jdbc:h2:~/jpa;AUTOCOMMIT=OFF"/>
		            <property name="hibernate.dialect" value="org.hibernate.dialect.H2Dialect"/>
		            <property name="hibernate.hbm2ddl.auto" value="create"/>
		            <property name="hibernate.show_sql" value="true"/>
		            <property name="hibernate.format_sql" value="true"/>
		        </properties>
		    </persistence-unit>
		</persistence>
* 实体注释
		
		@Entity
		@Table(name = "T_PERSON")
		@Inheritance(strategy = InheritanceType.JOINED)
		//@DiscriminatorColumn(name="PERSON_TYPE", discriminatorType = DiscriminatorType.INTEGER)
		public class Person {
			@Id
			@GeneratedValue
			private Long id;
			@Column(name = "FIRST_NAME")
			private String firstName;
			@Column(name = "LAST_NAME")
			private String lastName;
			@OneToOne(fetch = FetchType.EAGER)
			@JoinColumn(name = "ID_CARD_ID")
			private IdCard idCard;
			@OneToMany(mappedBy = "person", fetch = FetchType.LAZY)
			private List<Phone> phones = new ArrayList<Phone>();
		
		 	... ...
			get()&set()
		}
* 查询


		EntityManagerFactory factory = null;
		EntityManager entityManager = null;
		try {
			factory = Persistence.createEntityManagerFactory("PersistenceUnit");
			entityManager = factory.createEntityManager();
			persistPerson(entityManager);
			persistGeek(entityManager);
			loadPersons(entityManager);
			addPhones(entityManager);
			createProject(entityManager);
			queryProject(entityManager);
		} catch (Exception e) {
			LOGGER.log(Level.SEVERE, e.getMessage(), e);
			e.printStackTrace();
		} finally {
			if (entityManager != null) {
				entityManager.close();
			}
			if (factory != null) {
				factory.close();
			}
		}

### 2、Hibernate
Hibernate是一个基于Java的开源持久化中间件，对JDBC做了轻量级的封装。

采用ORM映射机制，负责实现Java对象和关系数据库之间的映射，把sql语句传给数据库，并且把数据库返回的结果封装成对象。内部封装了JDBC访问数据库的操作，向上层应用提供了面向对象的数据库访问API.

使用：
Java实体：

	public class User {  
	    private String id;  
	    private String username;  
	    private String password;  
	
		... ...
		get&set  
	}
映射文件(可以用注解)：

	<hibernate-mapping>  
	    <class name="com.example.hibernate.User">  
	        <id name="id">  
	            <generator class="uuid"/>  
	        </id>  
	        <property name="username"/>  
	        <property name="password"/>  
	    </class>  
	</hibernate-mapping>  
配置文件：
	
	<hibernate-configuration>  
	    <session-factory >  
	        <property name="hibernate.connection.driver_class">com.mysql.jdbc.Driver</property>  
	        <property name="hibernate.connection.url">jdbc:mysql://localhost:3306/test</property>  
	        <property name="hibernate.connection.username">root</property>  
	        <property name="hibernate.connection.password">000000</property>  
	        <property name="hibernate.dialect">org.hibernate.dialect.MySQLDialect</property>  
	          
	        <mapping resource="com/example/hibernate/User.hbm.xml"/></span>  
	    </session-factory>  
	</hibernate-configuration> 

数据操作：

	Configuration cfg = new Configuration().configure();    
	SessionFactory factory = cfg.buildSessionFactory();  
	Session session = null;  
	try{  
	    session = factory.openSession();   
	    session.beginTransaction();  
	    User user = new User();  
	    user.setUsername("用户名");  
	    user.setPassword("123");  
	    session.save(user);  
	    //提交事务  
	    session.getTransaction().commit();  
	}catch(Exception e){  
	    e.printStackTrace();  
	    //回滚事务  
	    session.getTransaction().rollback();  
	}finally{  
	    if(session != null){  
	        if(session.isOpen()){  
	            //关闭session  
	            session.close();  
	        }  
	    }  
	}  

### 3、 iBatis
优点：  

 * 学习成本低，容易上手和金额掌握。
 * 封装了大多数JDBC模版，使得开发者专注于Sql本身，不需要关心驱动注册、连接创建等问题。
 * 支持原生Sql和存储过程。

缺点：

 * 不支持对象关系映射。

### 4、MyBatis
MyBatis的原身是iBatis，通过配置文件的方式把查询结果映射成对象。

User实体

	public class User {
		
		private String id;
		private String userName;
		private String userAge;
		private String address;
	
		... ...
		get & set
	}


映射文件

<!--namespace和id确定了要执行的sql-->
<!-- 命名空间 可以通过命名空间可id，把该sql映射到对应的接口的方法上 -->
	<mapper namespace="com.sun.useMyBatis3.useMyBatis3.model.impl.UserImpl">
	
		<!-- 把列映射到对象的属性上面 -->
		<resultMap id="userResultMap" type="User">
			<id property="id" column="id" />
			<result property="userName" column="userName"/>
			<result property="userAge" column="userAge"/>
		</resultMap>
		
	    <select id="selectUserByID" parameterType="int" resultType="User">
	        select * from `user` where id = #{id}
	    </select>
	    <select id="selectPasswordAndAgeByID" parameterType="int" resultType="hashmap">
	        select id, userName,userAge from `user` where id = #{id}
	    </select>
	    
	    <select id="selectByIdUseResultMap" parameterType="int" resultMap="userResultMap">
	    	 select id, userName,userAge from `user` where id = #{id}
	    </select>
	</mapper>

查询语句

	public interface UserImpl {
		
		public User selectUserByID(int id);
		
		public HashMap<String,Object> selectPasswordAndAgeByID(int id);
		
		public User selectByIdUseResultMap(int id);
	}

查询

	Reader reader = Resources.getResourceAsReader("Configuration.xml"); 
	SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader); 
	SqlSession sqlSession = sqlSessionFactory.openSession();
	UserImpl userImpl = sqlSession.getMapper(UserImpl.class);
    User user1 = userImpl.selectUserByID(1);
	sqlSession.close();
