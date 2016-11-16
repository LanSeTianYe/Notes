[JPA 官方文档](http://docs.spring.io/spring-data/jpa/docs/current/reference/html/)
## 核心
### 核心类
1. `Repository`

        public interface Repository<T, ID extends Serializable> {
        }
2. `CrudRepository` 提供增删改查方法

        public interface CrudRepository<T, ID extends Serializable>
            extends Repository<T, ID> {
 
            <S extends T> S save(S entity); 
        
            T findOne(ID primaryKey);       
        
            Iterable<T> findAll();          
        
            Long count();                   
        
            void delete(T entity);          
        
            boolean exists(ID primaryKey);  
        
            // … more functionality omitted.
        }
    
3. `PagingAndSortingRepository` 增加分页查询方法

        public interface PagingAndSortingRepository<T, ID extends Serializable>
          extends CrudRepository<T, ID> {
        
          Iterable<T> findAll(Sort sort);
        
          Page<T> findAll(Pageable pageable);
        }
一个简单的分页查询列子：查询第一页的20条数据

        PagingAndSortingRepository<User, Long> repository = // … get access to a bean
        Page<User> users = repository.findAll(new PageRequest(1, 20));

4. `JpaRepository`

        @NoRepositoryBean
        public interface JpaRepository<T, ID extends Serializable> extends PagingAndSortingRepository<T, ID> {
        
        	/*
        	 * (non-Javadoc)
        	 * @see org.springframework.data.repository.CrudRepository#findAll()
        	 */
        	List<T> findAll();
        
        	/*
        	 * (non-Javadoc)
        	 * @see org.springframework.data.repository.PagingAndSortingRepository#findAll(org.springframework.data.domain.Sort)
        	 */
        	List<T> findAll(Sort sort);
5. 关联查询

        //根据 Address 属性的 ZipCode 属性查找
        List<Person> findByAddress_ZipCode(ZipCode zipCode);

6. 分页排序
           
        //创建分页条件的时候加入排序规则
        public PageRequest(int page, int size, Sort sort);
        Pageable pageable1 = new PageRequest(1, 2, new Sort(Sort.Direction.DESC, FillReportStructure_.tagName.getName()));
7. 限制查询结果 `First` or `Top`

        User findFirstByOrderByLastnameAsc();
        
        User findTopByOrderByAgeDesc();
        
        Page<User> queryFirst10ByLastname(String lastname, Pageable pageable);
        
        Slice<User> findTop3ByLastname(String lastname, Pageable pageable);
        
        List<User> findFirst10ByLastname(String lastname, Sort sort);
        
        List<User> findTop10ByLastname(String lastname, Pageable pageable);



5. 支持的通过名字查找的连接词

|Keyword	|Sample	|JPQL snippet|
|::|::|::|
|And|findByLastnameAndFirstname|… where x.lastname = ?1 and x.firstname = ?2|
|Or|findByLastnameOrFirstname|… where x.lastname = ?1 or x.firstname = ?2|
|Is,Equals|findByFirstname,findByFirstnameIs,findByFirstnameEquals|… where x.firstname = ?1|
|Between|findByStartDateBetween|… where x.startDate between ?1 and ?2|
|LessThan|findByAgeLessThan|… where x.age < ?1|
|LessThanEqual|findByAgeLessThanEqual|… where x.age ⇐ ?1|
|GreaterThan|findByAgeGreaterThan|… where x.age > ?1|
|GreaterThanEqual|findByAgeGreaterThanEqual|… where x.age >= ?1|
|After|findByStartDateAfter|… where x.startDate > ?1|
|Before|findByStartDateBefore|… where x.startDate < ?1|
|IsNull|findByAgeIsNull|… where x.age is null|
|IsNotNull,NotNull|findByAge(Is)NotNull|… where x.age not null|
|Like|findByFirstnameLike|… where x.firstname like ?1|
|NotLike|findByFirstnameNotLike|… where x.firstname not like ?1|
|StartingWith|findByFirstnameStartingWith|… where x.firstname like ?1 (parameter bound with appended %)|
|EndingWith|findByFirstnameEndingWith|… where x.firstname like ?1 (parameter bound with prepended %)|
|Containing|findByFirstnameContaining|… where x.firstname like ?1 (parameter bound wrapped in %)|
|OrderBy|findByAgeOrderByLastnameDesc|… where x.age = ?1 order by x.lastname desc|
|Not|findByLastnameNot|… where x.lastname <> ?1|
|In|findByAgeIn(Collection<Age> ages)|… where x.age in ?1|
|NotIn|findByAgeNotIn(Collection<Age> age)|… where x.age not in ?1|
|True|findByActiveTrue()|… where x.active = true|
|False|findByActiveFalse()|… where x.active = false|
|IgnoreCase|findByFirstnameIgnoreCase|… where UPPER(x.firstame) = UPPER(?1)|