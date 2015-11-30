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


