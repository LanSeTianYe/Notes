时间：2018/5/14 16:33:30   

参考：  

1. [mybatis-generator-gui](https://github.com/zouzg/mybatis-generator-gui)

##    
### 自动生成的基础 Mapper 文件   

	<?xml version="1.0" encoding="UTF-8"?>
	<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
	<mapper namespace="*.UserNotLikeMapper">
	  <resultMap id="BaseResultMap" type="*.UserNotLike">
	    <id column="not_like_id" jdbcType="BIGINT" property="notLikeId" />
	    <result column="user_id" jdbcType="BIGINT" property="userId" />
	    <result column="content_id" jdbcType="BIGINT" property="contentId" />
	    <result column="not_like_type" jdbcType="SMALLINT" property="notLikeType" />
	    <result column="is_active" jdbcType="TINYINT" property="isActive" />
	    <result column="create_time" jdbcType="TIMESTAMP" property="createTime" />
	    <result column="update_time" jdbcType="TIMESTAMP" property="updateTime" />
	  </resultMap>
	</mapper>

### 常用的SQL

* sql sql标签里面可以放任何Sql语句，作为通用模板使用

		<sql id="Base_Column_List">
		    exter_id, union_id, open_id, app_id, user_id
		</sql>

* `ON DUPLICATE KEY UPDATE` 主键已经存在则更新，不存在则新插入。（user_id 是主键）

		<insert id="insertOrUpdateFansCountByUserId" parameterType="java.util.Map">
	        insert into user_exter (user_id,fans_count,follow_count) values (#{userId,jdbcType=BIGINT} , 1 , 0)
	        ON DUPLICATE KEY UPDATE
	        <if test="followStatus == 1">
	             fans_count=fans_count+1
	        </if>
	        <if test="followStatus == 0">
	             fans_count=fans_count-1
	        </if>
	    </insert>
	
	对应的SQL: 

		INSERT INTO user_exter (user_Id, fans_count, follow_count) VALUES (1, 1, 1) ON DUPLICATE KEY UPDATE fans_count = fans_count + 1;
* if

		<update id="updateUserInfo" parameterType="java.util.Map">
		    update user
		    <set>
		      <if test="user.name != null">
		        user_name = #{user.nam,jdbcType=VARCHAR},
		      </if>
		      <if test="user.age != null">
		        union_id = #{user.age,jdbcType=VARCHAR},
		      </if>
		    </set>
		    where user_id = user.userId;
		</update>

* foreach 

		<foreach collection="userIds" item="userId" open="(" close=")" separator=","> #{userId, jdbcType=BIGINT}</foreach>

* choose

		<select id="getDictionaryInfoList" resultType="com.cloudyoung.qqicar.user.vo.DictionaryInfoVo" parameterType="map">
		    SELECT * from user where is_active = 1
		    <choose>
		      <when test="sort=='desc'">
		        order by order_num desc
		      </when>
		      <otherwise>
		        order by order_num asc
		      </otherwise>
		    </choose>
		</select> 

* trim 会自动消除多余的AND
	
		<select id=”findActiveBlogLike” parameterType=”Blog” resultType=”Blog”>
			SELECT * FROM BLOG
			<trim prefix="WHERE" prefixOverrides="AND|OR ">
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

* 批量插入数据之后回显ID，（单条插入类似）

	重点在于 `useGeneratedKeys="true" keyProperty="carId"`, carId是Id对应的字段名字。


		<insert id="batchInsert" parameterType="com.Car" useGeneratedKeys="true" keyProperty="carId">
	    insert into wx_drive_activity_dealer_car (
	      car_id,
	      car_name
	    )
	    values
	    <foreach collection="list" item="car" index="index"
	             separator=",">
	      (
	      #{car.carId, jdbcType=BIGINT},
	      #{car.carName,jdbcType=BIGINT}
	      )
	    </foreach>
	  </insert>

### resultMap

映射查询结果到对应实体：

 	<resultMap id="resultMapId" type="com.sun.Demo">
        <result column="id" jdbcType="INTEGER" property="id"/>
        <result column="name" jdbcType="VARCHAR" property="name"/>
        <result column="address" jdbcType="VARCHAR" property="address"/>
    </resultMap>