## JPA常用注解
1. 实体

		@Entity 
		public class Users implements Serializable {
		}

2. 表名

		@Entity
		@Table(name = "tableName")
		public class User {
		}

3. 列

		@Column(name = "user_name", length = 255, nullable = true, unique = true)
		private String name;
4. 默认值

		@Column(columnDefinition="int default 1",nullable=false)
		private Integer version;
	
		@Column(columnDefinition="varchar(50) default '1.0'",nullable=false)
		private String version;

5. 主键ID
	
		@Id
		@GeneratedValue
		private Integer id;

6. 时间日期

		@Temporal(TemporalType.DATE)
		private Date birthday;

 * `@Temporal(TemporalType.DATE)` 映射为日期 （只有日期）
 * `@Temporal(TemporalType.TIME)` 映射为日期 （是有时间）
 * `@Temporal(TemporalType.TIMESTAMP)` 映射为日期 datetime （日期+时间）

7. 大数据类型

		@Lob
		private String text;   //text longtext
8. 不持久化的字段

		@Transient
		private String temp; 