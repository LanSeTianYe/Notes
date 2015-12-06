##### SQL 映射文件有很少的几个顶级元素（按照它们应该被定义的顺序）：
* cache   -   配置给定命名空间的缓存。
* cache- ref  –   从其他命名空间引用缓存配置。
* resultMap  –  最复杂，也是最有力量的元素，用来描述如何从数据库结果集中来加
载你的对象。
* sql   –  可以重用的 SQL 块，也可以被其他语句引用。
* insert  –  映射插入语句
* update –  映射更新语句
* delete –  映射删除语句
* select –   映射查询语句

##### select 元素的使用
	<select
		id=”selectPerson”
		parameterType=”int”
		parameterMap=”deprecated”
		resultType=”hashmap”
		resultMap=”personResultMap”
		flushCache=”false”
		useCache=”true”
		timeout=”10000”
		fetchSize=”256”
		statementType=”PREPARED”
		resultSetType=”FORWARD_ONLY”

说明

	<select
		id=”selectPerson”			//用于识别的id
		parameterType=”int”			//参数类型
		parameterMap=”deprecated”	//已废弃
		resultType=”hashmap”		//返回数据的类型
		resultMap=”personResultMap”	//返回map类型的数据，不可和resultType同事使用
		flushCache=”false”			//将其设置为 true，无论语句什么时候被调用，都会导
									  致缓存被清空。默认值：false。
		useCache=”true”				//是否缓存当前语句的结构，默认true
		timeout=”10000”				//查询的超市限制，默认不设置，驱动程序自动处理
		fetchSize=”256”				//每次返回结果的行数，默认不配置
		statementType=”PREPARED”	//STATEMENT,PREPARED 或 CALLABLE 的一种。这会
		                              让 MyBatis使用选择使用 Statement，
		                              PreparedStatement 或 CallableStatement。
		                              默认值：PREPARED。
		resultSetType=”FORWARD_ONLY”  //FORWARD_ONLY|SCROLL_SENSITIVE|
		                                SCROLL_INSENSITIVE中的一种。默认是不设置
		                               （驱动自行处理）。
	>

##### insert update delete语句
	<insert
		id="insertAuthor"
		parameterType="domain.blog.Author"
		flushCache="true"
		statementType="PREPARED"
		keyProperty=""
		useGeneratedKeys=""
		timeout="20000">
	<update
		id="insertAuthor"
		parameterType="domain.blog.Author"
		flushCache="true"
		statementType="PREPARED"
		timeout="20000">
	<delete
		id="insertAuthor"
		parameterType="domain.blog.Author"
		flushCache="true"
		statementType="PREPARED"
		timeout="20000">
* 简单的例子

 * insert
  
			<insert id="insertAuthor"  parameterType="domain.blog.Author">
				insert into Author (id,username,password,email,bio)
				values (#{id},#{username},#{password},#{email},#{bio})
			</insert>
 * update
 
			<update id="updateAuthor" parameterType="domain.blog.Author">
				update Author set
				username = #{username},
				password = #{password},
				email = #{email},
				bio = #{bio}
				where id = #{id}
			</update>
 * delete

			<delete id="deleteAuthor” parameterType="int">
				delete from Author where id = #{id}
			</delete>
* 自动生成主键（MySQl和SqlServer）

		<insert id="insertAuthor" parameterType="domain.blog.Author"
			useGeneratedKeys=”true” keyProperty=”id”>
			insert into Author (username,password,email,bio)
			values (#{username},#{password},#{email},#{bio})
		</insert>
* MyBatis随机生成主键

		<insert id="insertAuthor" parameterType="domain.blog.Auth or">
			<selectKey keyProperty="id" resultType="int" order="BEFORE">
				select CAST(RANDOM()*1000000 as INTEGER) a from SYSIBM.SYSDUMMY1
			</selectKey>
				insert into Author
				(id, username, password, email,bio, favourite_section)
				values
				(#{id}, #{username}, #{password}, #{email}, #{bio},
				#{favouriteSection,jdbcType=VARCHAR})
		</insert>
 * selectKey元素的介绍
         > `keyProperty`  selectKey 语句结果应该被设置的目标属性。  
         > `resultType`  结果的类型。MyBatis 通常可以算出来，但是写上也没有问题。
MyBatis 允许任何简单类型用作主键的类型，包括字符串。  
         > `order` 这可以被设置为 BEFORE 或 AFTER。如果设置为 BEFORE，那
么它会首先选择主键，设置 keyProperty 然后执行插入语句。如果
设置为 AFTER，那么先执行插入语句，然后是 selectKey 元素-这和如 Oracle 数据库相似，可以在插入语句中嵌入序列调用。  
         > `statementType` 和前面的相同，MyBatis 支持 STATEMENT ，PREPARED 和
CALLABLE 语句的映射类型，分别代表 PreparedStatement 和
CallableStatement 类型。

##### sql元素
> 这个元素可以被用来定义可重用的 SQL 代码段，可以包含在其他语句中。

	<sql id=”userColumns”> id,username,password </sql>
 * 使用

		<select id=”selectUsers” parameterType=”int” resultType=”hashmap”>
			select <include refid=”userColumns”/>
			from some_table
			where id = #{id}
		</select>

##### 参数类型
	<select id=”selectUsers” parameterType=”int” resultType=”User”>
		select id, username, password
		from users
		where id = #{id}
	</select>
上面的这个示例说明了一个非常简单的命名参数映射。参数类型被设置为“int”，因此
这个参数可以被设置成任何内容。原生的类型或简单数据类型，比如整型和没有相关属性的
字符串，因此它会完全用参数来替代。然而，如果你传递了一个复杂的对象，那么 MyBatis
的处理方式就会有一点不同。比如：

	<insert id=”insertUser” parameterType=”User” >
		insert into users (id, username, password)
		values (#{id}, #{username}, #{password})
	</insert>
如果 User 类型的参数对象传递到了语句中， id、username和password属性将会被查找，
然后它们的值就被传递到预处理语句的参数中。这点对于传递参数到语句中非常好。但是对于参数映射也有一些其他的特性。首先，参数可以指定一个确定的数据类型。

	#{property,javaType=int,jdbcType=NUMERIC}

javaType 通常可以从参数对象中来确定，除非对象是一个HashMap。那么 javaType 应该被确定来保证使用正确类型处理器。  
**注意**：如果 null 被当作值来传递，对于所有可能为空的列，JDBC Type是需要的。也可以通过阅读 `PreparedStatement.setNull()`方法的 JavaDocs 文档来研究它。  

**自定义类型处理器**

	#{age,javaType=int,jdbcType=NUMERIC,typeHandler=MyTypeHandler}
**限制数值的长度**、

	#{height,javaType=double,jdbcType=NUMERIC,numericScale=2}
**mode部分**  
mode 属性允许你指定 IN，OUT 或 INOUT 参数。如果参数为 OUT 或 INOUT，
参数对象属性的真实值将会被改变，就像你期望你需要你个输出参数。如果 mode 为 OUT
（或 INOUT），而且 jdbcType 为 CURSOR（也就是 Oracle 的 REFCURSOR），你必须指定
一个 resultMap 来映射结果集到参数类型。要注意这里的 javaType 属性是可选的，如果左边
的空白是 jdbcType 的 CURSOR 类型，它会自动地被设置为结果集。

	#{department,
		mode=OUT,
		jdbcType=CURSOR,
		javaType=ResultSet,
		resultMap=departmentResultMap}
MyBatis 也支持很多高级的数据类型，比如结构体，但是当注册 out 参数时你必须告诉语句类型名称

	#{middleInitial, 
		mode=OUT,
		jdbcType=STRUCT,
		jdbcTypeName=MY_TYPE,
		resultMap=departmentResultMap}

**字符串替换**
默认情况下，使用#{}格式，会使Mybatis线预处理Sql语句，然后再设置值，这样做可以避免Sql注入，但是有时候，我们需要传递一个固定的字符串（可以使用${}）：
  
	ORDER BY ${columnName}

##### resultMap（最重要最强大的元素）

	<select id="selectPasswordAndAgeByID" parameterType="int" resultType="hashmap">
        select id, userName,userAge from `user` where id = #{id}
    </select>

> `resultType="hashmap"` 只能查询一行，并把查询的结果放入Map中，可以通过get列名来获取对应列的数据  
> 例如：`result.get("id")`
> resultType可以为对象

###### 如何手动把查询的元素映射到对象上

	<!-- 把列映射到对象的属性上面 -->
	<resultMap id="userResultMap" type="User">
		<id property="id" column="id" />
		<result property="userName" column="userName"/>
		<result property="userAge" column="userAge"/>
	</resultMap>
查询语句

	<select id="selectByIdUseResultMap" parameterType="int" resultMap="userResultMap">
    	 select id, userName,userAge from `user` where id = #{id}
    </select>
这样就把，对应的列手动映射到了对象对应的属性上面了，效果等同于把resultType指定为对象`User`


###### 高级结果映射
resultMap的一些常见属性  

* `constructor`   类在实例化时，用来注入结果到构造方法中
 * `idArg`   ID 参数；标记结果作为 ID 可以帮助提高整体效能
 * `arg`    注入到构造方法的一个普通结果
* `id`   一个 ID 结果；标记结果作为 ID 可以帮助提高整体效能
* `result`   注入到字段或 JavaBean 属性的普通结果
* `association`    一个复杂的类型关联；许多结果将包成这种类型
 * `嵌入结果映射`    结果映射自身的关联，或者参考一个
* `collection`     复杂类型的集
 * `嵌入结果映射`    结果映射自身的集，或者参考一个
* `discriminator`    使用结果值来决定使用哪个结果映射
 * `case`   基于某些值的结果映射
     * `嵌入结果映射`    这种情形结果也映射它本身，因此可以包含很多相
同的元素，或者它可以参照一个外部的结果映射

###### 属性解析
1. id 和 result  

		<id property="id" column="post_id"/>
		<result property="subject" column="post_subject"/>
`id`和`result`都映射一个单独列的值到简单数据类型（字符串，整型，双精度浮点数，日期等）的单独属性或字段。  
`id`表示的结果将是当比较对象实例时用到的标识属性。这帮助来改进整体表现，特别是缓存和嵌入结果映射（也就是联合映射）。  
`id`和`result`的一些属性
 * `property` 映射到列结果的字段或属性。如果匹配的是存在的，和给定名称相同的JavaBeans的属性，那么就会使用。否则MyBatis将会寻找给定名称的字段。这两种情形你可以使用通常点式的复杂属性导航。比如，你可以这样映射一些东西：“username ”，或者映射到一些复杂的东西：“address.street.number”。
 * `column` 从数据库中得到的列名，或者是列名的重命名标签。这也是通常和会传递给 resultSet.getString(columnName) 方法参数中相同的字符串。
 * `javaType` 一个 Java 类的完全限定名，或一个类型别名（参加上面内建类型别名的列表）。如果你映射到一个 JavaBean，MyBatis 通常可以断定类型。然而，如果你映射到的是 HashMap，那么你应该明确地指定javaType来保证所需的行为。
 * `jdbcType` 在这个表格之后的所支持的 JDBC 类型列表中的类型。 JDBC 类型是仅仅需要对插入，更新和删除操作可能为空的列进行处理。这是 JDBC的需要，而不是 MyBatis 的。如果你直接使用 JDBC 编程，你需要指定这个类型,但仅仅对可能为空的值。
 * `typeHandler` 我们在前面讨论过默认的类型处理器。使用这个属性，你可以覆盖默认的类型处理器。这个属性值是类的完全限定名或者是一个类型处理器的实现，或者是类型别名。
         > `JDBC TYPE` BIT  FLOAT  CHAR  TIMESTAMP  OTHER  UNDEFINED TINYINT  REAL  VARCHAR  BINARY  BLOB  NVARCHAR SMALLINT  DOUBLE  LONGVARCHAR  VARBINARY  CLOB  NCHAR INTEGER   NUMERIC  DATE  LONGVARBINARY  BOOLEAN  NCLOB BIGINT  DECIMAL  TIME   NULL  CURSOR
2. 构造方法

		<constructor>
			<idArg column="id" javaType="int"/>
			<arg column=”username” javaType=”String”/>
		</constructor>

    JAVA实体类

			public class User {
			//…
				public User(int id, String username) {
					//…
				} 
			//…
			}
    通过构造方法，初始化对象的属性，注意顺序和类型必须和构造方法的参数一一对应    
    一些属性
 * `column` 同上
 * `javaType` 同上
 * `jdbcType` 同上
 * `typeHandler` 同上 

3. 关联（association） 一个对象的属性包含另外一个对象，只是需要通过关联关系，把对应的结果映射到关联的对象的属性上面。

		<association property="author" column="blog_author_id" javaType=" Author">
			<id property="id" column="author_id"/>
			<result property="username" column="author_username"/>
		</association>
在mybatis中存在两种不同的加载关联的方式
 * **嵌套查询**：通过执行另外一个 SQL 映射语句来返回预期的复杂类型
 * **嵌套结果**：使用嵌套结果映射来处理重复的联合结果的子集

    包含的属性：
    * `property` 同上
    * `column` 同上，注意：要处理复合主键，你可以指定多个列名通过 column=”{prop1=col1,prop2=col2} ” 这种语法来传递给嵌套查询语句。这会引起prop1和prop2以参数对象形式来设置给目标嵌套查询语句。
    * `javaType` 同上
    * `jdbcType` 同上
    * `typeHandler ` 同上

    3.1 关联的嵌套查询 

    > 另外一个映射语句的 ID，可以加载这个属性映射需要的复杂类型。获取的在列属性中指定的列的值将被传递给目标 select 语句作为参数。表格后面有一个详细的示例。

		<resultMap id=”blogResult” type=”Blog”>
			<association property="author" column="blog_author_id" 
			javaType="Author"  select=”selectAuthor”/>
		</resultMap>

		<select id=”selectBlog” parameterType=”int” resultMap=”blogResult”>
			SELECT * FROM BLOG WHERE ID = #{id}
		</select>

		<select id=”selectAuthor” parameterType=”int” resultType="Author">
			SELECT * FROM AUTHOR WHERE ID = #{id}
		</select>
    这里有两个查询语句，执行id=“selectBlog”的查询语句之后，由于指定了resultMap=”blogResult”，所以查询的结果会映射到Blog和Author上面，这样做很简单，但是当遇到1+N问题的时候，由于Author的数量可能有N个所以就会执行1+N个Sql查询，这样会降低效率。  
    MyBatis 能延迟加载这样的查询就是一个好处，因此你可以分散这些语句同时运行的消耗。然而，如果你加载一个列表，之后迅速迭代来访问嵌套的数据，你会调用所有的延迟加载，这样的行为可能是很糟糕的  

    3.2 关联的嵌套结果
    * `resultMap` 这是结果映射的 ID，可以映射关联的嵌套结果到一个合适的对象图中。这是一种替代方法来调用另外一个查询语句。这允许你联合多个表来合成到一个单独的结果集。这样的结果集可能包含重复，数据的重复组需要被分解，合理映射到一个嵌套的对象图。为了使它变得容易， MyBatis 让你“链接”结果映射，来处理嵌套结果。例子会很容易来仿照，这个表格后面也有一个示例。

			<select id="selectBlog" parameterType="int" resultMap="blogResult">
				select
				B.id as blog_id,
				B.title as blog_title,
				B.author_id as blog_author_id,
				A.id as author_id,
				A.username as author_username,
				A.password as author_password,
				A.email as author_email,
				A.bio as author_bio
				From Blog B left outer join Author A on B.author_id = A.id
				where B.id = #{id}
			</select>

        映射结果

			<resultMap id="blogResult" type="Blog">
				<id property=”blog_id” column="id" />
				<result property="title" column="blog_title"/>
				<association property="author" column="blog_author_id"
				javaType="Author"  resultMap=”authorResult”/>
			</resultMap>

			<resultMap id="authorResult" type="Author">
				<id property="id" column="author_id"/>
				<result property="username" column="author_username"/>
				<result property="password" column="author_password"/>
				<result property="email" column="author_email"/>
				<result property="bio" column="author_bio"/>
			</resultMap>
    同样的映射结果，但是不能重用

			<resultMap id="blogResult" type="Blog">
				<id property=”blog_id” column="id" />
				<result property="title" column="blog_title"/>
				<association property="author" column="blog_author_id"
				javaType="Author">
					<id property="id" column="author_id"/>
					<result property="username" column="author_username"/>
					<result property="password" column="author_password"/>
					<result property="email" column="author_email"/>
					<result property="bio" column="author_bio"/>
				</association>
			</resultMap>
4. 集合

		<collection property="posts" ofType="domain.blog.Post">
			<id property="id" column="post_id"/>
			<result property="subject" column="post_subject"/>
			<result property="body" column="post_body"/>
		</collection>

    在一个对象中包含多个另外的元素

		private List<Post> posts;

    such as

		<resultMap id=”blogResult” type=”Blog”>
			<collection property="posts" javaType=”ArrayList” column="blog_id"
						ofType="Post" select=”selectPostsForBlog”/>
		</resultMap>

		<select id=”selectBlog” parameterType=”int” resultMap=”blogResult”>
			SELECT * FROM BLOG WHERE ID = #{id}
		</select>

		<select id=”selectPostsForBlog” parameterType=”int” resultType="Author">
			SELECT * FROM POST WHERE BLOG_ID = #{id}
		</select>