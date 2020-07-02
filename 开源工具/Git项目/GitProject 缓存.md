时间：2018/2/28 13:21:56   

## 缓存简介  

把数据存储在内存中，需要的时候直接取出，减少磁盘读取或数据计算，提升效率。

##  [Caffeine](https://github.com/ben-manes/caffeine)  

简介：基于Java8的，高性能，并且接近最优的缓存框架。通过弱引用实现数据自动回收。  

* 访问统计：
 

Demo：

	Cache<String, Object> cache = Caffeine.newBuilder()
            .expireAfterWrite(1, TimeUnit.DAYS)
            .maximumSize(100)
            .build();
    return cache;
## [Ehcache3](https://github.com/ehcache/ehcache3)
  
简介：支持分布式。分层数据存储，直接内存，硬盘。支持缓存数据持久化。

核心类：`CacheManager` 和 `Cache`  
	
	try(CacheManager cacheManager = newCacheManagerBuilder() 
	  .withCache("preConfigured", newCacheConfigurationBuilder(Long.class, String.class, heap(10))) 
	  .build(true)) { 
	  // some code
	}
## [Memcached](https://github.com/memcached/memcached)

简介：适用于分布式系统的高性能、多线程、基于时间的 key/value 缓存。 

## [Redis](https://github.com/antirez/redis)   

简介：key/value 数据库，可以用做分布式缓存，提供订阅机制。以及几种基本的数据类型。