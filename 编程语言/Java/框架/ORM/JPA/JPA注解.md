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

## 关联映射用到的注解

1. 一对一注解(OneToOne)
 * `mappedBy` 
     * 有mappedBy的一方为关系被维护端,在四种关联关系OneToOne，OneToMany，ManyToOne和ManyToMany中，只有OneToOne、OneToMany和ManyToMany这三中关联关系有mappedBy属性。 
     * 拥有关联关系的域，如果关系是单向的就不需要。 
     * 假设是双向一对一的话，那么拥有关系的这一方有建立、解除和更新与另一方关系的能力，而另一方没有，只能被动管理；在双向一对多和双向多对多中是一个意思。 
     * 由于JoinTable和JoinColumn一般定义在拥有关系的这一端，而Hibernate又不让mappedBy跟JoinTable和JoinColumn定义在一起，所以mappedBy一定是定义在关系的被拥有方，the owned side，也就是跟定义JoinTable和JoinColumn互斥的一方，它的值指向拥有方中关于被拥有方的字段，可能是一个对象（OneToMany），也可能是一个对象集合（ManyToMany）。 
     * 关系的拥有方负责关系的维护，在关系拥有方建立外键，所以JoinTable和JoinColumn都是定义在关系拥有方。 
     * 另外mappedBy有一个功能就是，加入这个属性之后，可以避免自动生成中间表。 
     * 最后，mappedBy=“xxx”，可以这么理解，mappedBy定义在关系的 **被拥有方** ，mappedBy定义所在的类（不管是单个还是集合的形式）在关系拥有者那一方的名称是“xxx”。
 * `fetch`
     * `FetchType.EAGER`: 被控对象在主控对象加载的时候同时加载.
     * `FetchType.LAZY`(默认): 被控对象在被访问时才加载.
 * `targetEntity` ： Class类型的属性。定义关系类的类型，默认是该成员属性对应的类类型，所以通常不需要提供定义。
 * `cascade` 该属性定义类和类之间的级联关系。定义的级联关系将被容器视为对当前类对象及其关联类对象采取相同的操作， 而且这种关系是递归调用的。默认情况下，JPA 不会将任何持续性操作层叠到关联的目标。
     * `CascadeType.ALL` 针对拥有实体执行的任何持续性操作均层叠到关联的目标.
     * `CascadeType.MERGE` 如果合并了拥有实体，则将 merge 层叠到关联的目标.
     * `CascadeType.PERSIST` 如果持久保存拥有实体，则将 persist 层叠到关联的目标.
     * `CascadeType.REFRESH` 如果刷新了拥有实体，则 refresh 为关联的层叠目标.
     * `CascadeType.REMOVE` 如果删除了拥有实体，则还删除关联的目标.
 * `optional` 用于指定属性是否可以为空,默认为true。

2. 一对多注解(OneToMany)
 * 同上
3. 多对一注解(ManyToOne)
 * 同上
4. 多对多注解(ManyToMany)
 * 同上
5. 添加列(JoinColumn)  
@JoinColumn和@Column类似,描述的不是一个简单字段,而是一个关联字段。
6. 查询的方法 (Fetch)
 * @Fetch(FetchMode.JOIN) 会使用left join查询，只产生一条sql语句
 * @Fetch(FetchMode.SELECT)   会产生N+1条sql语句
 * @Fetch(FetchMode.SUBSELECT)  产生两条sql语句 第二条语句使用id in (…..)查询出所有关联的数据