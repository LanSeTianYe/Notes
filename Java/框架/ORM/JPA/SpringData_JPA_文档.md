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
5. 自定义查询接口



