## 一些知识
单向关联和双向关联的区别 :   
单向关联：可以从关联类查出被关联类的信息，不能从被关联类查询到关联类的信息。
双向关联：由于关系是双向的，所以两个相关联的类同时都是关联着者和被关联者，可以从其中一个查询到另一个的信息。

## 总结
1. 在双向关联中，删除关系维护端的会自动解除关联关系，删除关系被维护端需要解除关联关系之后再删除。
2. 在一个代码块内，通过保存关系维护端自动保存关联关系之后，查找被维护端，不能查询到与之关联的关系维护端（如多对多的代码片段），可能是实体存在缓存的缘故。


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

## 具体例子

##### 双向一对一    

* 关系维护端    
    
        @OneToOne
        @JoinColumn(name = "mayor_id")
        private Mayor mayor;
* 关系被维护端

        @OneToOne(mappedBy = "mayor")
        private City city;
* 测试代码片段

        /**
         * 测试双向一对一关联的保存和删除
         */
        @RequestMapping("test/testTwoWayOneToOne")
        @ResponseBody
        public void testTwoWayOneToOne() {
            //重新保存
            City city3 = new City();
            city3.setName("city3");
            Mayor mayor3 = new Mayor();
            mayor3.setName("mayor3");
    
            //保存  先保存被控方，然后把被控方关联到主控方，再保存主控方
            mayorService.saveOrUpdateMayor(mayor3);
            city3.setMayor(mayor3);
            cityService.saveOrUpdateCity(city3);
    
            //解除关联关系
            city3.setMayor(null);
            cityService.saveOrUpdateCity(city3);
    
            //删除
            mayorService.deleteMayor(mayor3);
            cityService.deleteCity(city3);
        }
    
##### 双向一对多
> 在JPA规范中，一对多的双向关系由多端来维护。就是说多端为关系维护端，负责关系的增删改查。一端则为关系被维护端，不能维护关系。  

* 关系维护端    

        @ManyToOne
        @JoinColumn(name = "province_id")
        private Province province;
* 关系被维护端

        @OneToMany(mappedBy = "province")
        private Set<City> citys;
* 测试代码片段

        /**
         * 测试双向一对多的保存和删除
         */
        @RequestMapping("test/testTwoWayOneToMany")
        @ResponseBody
        public void testTwoWayOneToMany() {
            //保存  城市为关系的控制端
            Province province4 = new Province();
            province4.setName("province4");
            provinceService.saveOrUpdateProvince(province4);
    
            City city4 = new City();
            city4.setName("city4");
            city4.setProvince(province4);
            cityService.saveOrUpdateCity(city4);
    
            City city5 = new City();
            city5.setName("city5");
            city5.setProvince(province4);
            cityService.saveOrUpdateCity(city5);
    
            //删除城市
            cityService.deleteCity(city4);
    
            //删除省，需要先删除关联的所有城市
            //provinceService.deleteProvince(province4);
        }
 
##### 双向多对多

* 关系维护端    

        @ManyToMany
        List<Teacher> teachers;
* 关系被维护端

        @ManyToMany(mappedBy = "teachers")
        private List<Student> studentList;
* 测试代码片段

        /**
         * 测试双向多对多的保存和删除
         */
        @RequestMapping("test/testTwoWayManyToMany")
        @ResponseBody
        public void testTwoWayManyToMany() {
            //关系的控制方为学生
            Student student11 = new Student();
            Student student12 = new Student();
            student11.setName("student11");
            student12.setName("student12");
    
            Teacher teacher11 = new Teacher();
            Teacher teacher12 = new Teacher();
            teacher11.setName("teacher12");
            teacher12.setName("teacher12");
    
            //创建关系
            teacherService.saveOrUpdateTeacher(teacher11);
            teacherService.saveOrUpdateTeacher(teacher12);
    
            student11.setTeachers(new ArrayList<Teacher>());
            student11.getTeachers().add(teacher11);
            student11.getTeachers().add(teacher12);
            student12.setTeachers(new ArrayList<Teacher>());
            student12.getTeachers().add(teacher11);
            student12.getTeachers().add(teacher12);
    
            studentService.saveOrUpdateStudent(student11);
            studentService.saveOrUpdateStudent(student12);
    
            //删除
            //可以关联查询到teacher信息
            Student student = studentService.findById(student11.getId());
            //不可以关联查询到学生的信息，可能是由于缓存数据没有更新的缘故
            Teacher teacher = teacherService.findById(teacher11.getId());
    
            //删除学生，自动删除关联关系
            studentService.deleteStudent(student11);
            //删除老师需要先手动删除关联关系
            // ... ...
        }