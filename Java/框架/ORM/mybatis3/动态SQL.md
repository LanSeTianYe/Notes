## 基本语法元素  

* if     满足条件即添加，可以添加多个
* choose(when,otherwise)    只添加一个，从上向下进行匹配
* trim(where,set)
* foreach

### if  

	<select id="findActiveBlogWithTitleLike" parameterType="Blog" resultType="Blog">
		SELECT * FROM BLOG WHERE state = "ACTIVE"
		<if test="title != null">
			AND title like #{title}
		</if>
	</select>
作用：相当于在where里面增加了一个查询条件，只有传递的title不为空的时候才会添加该条件，当传递的title为空的时候，`title like #{title}`语句不会被添加，此时的查询语句相当于`SELECT * FROM BLOG WHERE state = "ACTIVE"`。意思类似于，在满足神么样的条件下添加该语句到SQL的条件中。
用纯SQL的方式怎么实现动态SQL？
### choose , when, otherwise

	<select id=”findActiveBlogLike” parameterType=”Blog” resultType=”Blog”>
		SELECT * FROM BLOG WHERE state = “ACTIVE‟
		<choose>
			<when test=”title != null”>
				AND title like #{title}
			</when>
			<when test=”author != null and author.name != null”>
				AND title like #{author.name}
			</when>
			<otherwise>
				AND featured = 1
			</otherwise>
		</choose>
	</select>

作用： 从第一个when开始匹配，找到匹配的即停止匹配，没找到则用others里面的。

### trim where set

可能出错的查询语句

	<select id="findActiveBlogLike" parameterType="Blog" resultType="Blog"> 
		SELECT * FROM BLOG WHERE

		<if test=”state != null”>
			state = #{state}
		</if>

		<if test=”title != null”>
			AND title like #{title}
		</if>

		<if test=”author != null and author.name != null”>
			AND title like #{author.name}
		</if>
	</select>
上面的查询语句  


 * 如果所有的if都没有匹配，那么Sql语句就是`SELECT * FROM BLOG WHERE`，这是一个错误的Sql语句。
 * 如果第一个if没有匹配，而第二个或第三个有一个匹配，或者全部匹配，就会产生`SELECT * FROM BLOG WHERE AND ...` 这也是一个错误的Sql语句。

**怎么解决上面的问题？**

* 第一种解决方案 ： where语句可以根据最后匹配的结果个数选择是否插入where，以及去除返回的第一个语句的开头的AND或者OR

		<select id=”findActiveBlogLike” parameterType=”Blog” resultType=”Blog”>
			SELECT * FROM BLOG
			<where>
				<if test=”state != null”>
					state = #{state}
				</if>
				<if test=”title != null”>
					AND title like #{title}
				</if>
				<if test=”author != null and author.name != null”>
					AND title like #{author.name}
				</if>
			</where>
		</select>
* 第二种解决方案，使用 trim

		<select id=”findActiveBlogLike” parameterType=”Blog” resultType=”Blog”>
			SELECT * FROM BLOG
			<trim prefix="WHERE" prefixOverrides="AND |OR ">
				<if test=”state != null”>
					state = #{state}
				</if>
				<if test=”title != null”>
					AND title like #{title}
				</if>
				<if test=”author != null and author.name != null”>
					AND title like #{author.name}
				</if>
			</trim>
		</select>

**更新语句**

* update

		<update id="updateAuthorIfNecessary" parameterType="domain.blog.Author"> 
			update Author
			<set>
				<if test="username != null">username=#{username},</if>
				<if test="password != null">password=#{password},</if>
				<if test="email != null">email=#{email},</if>
				<if test="bio != null">bio=#{bio}</if>
			</set>
			where id=#{id}
		</update>

    set可以消除任意无关的逗号。
 * 使用trim代替set

			<trim prefix="SET" suffixOverrides=",">
			…
			</trim>

##### foreach

	<select id="selectPostIn" resultType="domain.blog.Post">
	SELECT *
		FROM POST P
		WHERE ID in
		<foreach item="item" index="index" collection="list"
			open="(" separator="," close=")">
			#{item}
		</foreach>
	</select>



