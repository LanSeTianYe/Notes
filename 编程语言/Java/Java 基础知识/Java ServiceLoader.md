时间： 2018/9/14 15:32:32 

参考： 

1. java.util.ServiceLoader

## ServiceLoader 

### 简介

服务加载工具类，从 `META-INF/services/` 目录查找接口的实现信息，然后初始化接口的实现类，拿到具体的实例化之后的对象，之后使用接口定义的服务。

### 源码解析 

#### 内部字段 

```java
# 服务提供类配置文件 	
private static final String PREFIX = "META-INF/services/";
# 服务接口
private final Class<S> service
# 类加载器
private final ClassLoader loader;
# 访问控制
private final AccessControlContext acc;
# 服务接口实现者提供列表
private LinkedHashMap<String,S> providers = new LinkedHashMap<>();
# 懒加载实现，需要服务的时候再加载
private LazyIterator lookupIterator;
```

#### 加载过程： 

1. 调用加载方法，创建 ServiceLoader 对象
  
    ```java
    ServiceLoader<Driver> drivers = ServiceLoader.load(Driver.class)    
    public static <S> ServiceLoader<S> load(Class<S> service) {
        ClassLoader cl = Thread.currentThread().getContextClassLoader();
        return ServiceLoader.load(service, cl);
    }
    
    public static <S> ServiceLoader<S> load(Class<S> service, ClassLoader loader){
        return new ServiceLoader<>(service, loader);
    }S
    ```

2. ServiceLoader 创建过程

    ```java
    private ServiceLoader(Class<S> svc, ClassLoader cl) {
        # 验证Service 接口、类加载器判断或初始化、访问控制器判断或初始化
	    service = Objects.requireNonNull(svc, "Service interface cannot be null");
	    loader = (cl == null) ? ClassLoader.getSystemClassLoader() : cl;
	    acc = (System.getSecurityManager() != null) ? AccessController.getContext() : null;
        //重接加载接口定义
	    reload();
	}
    
    //重新加载接口提供者信息
    public void reload() {
        providers.clear();
        # 初始化懒加载器
        lookupIterator = new LazyIterator(service, loader);
    }
    ```

3. 获取接口提供者

    ```java
    # 初始化ServiceLoader
    ServiceLoader<Driver> drivers = ServiceLoader.load(Driver.class);
    # 获取迭代器， ServiceLoader 实现 `Iterable` 接口
    Iterator<Driver> driverIterator = drivers.iterator();
    while (driverIterator.hasNext()) {
        System.out.println(driverIterator.next().getClass().getName());
    }
    
    # drivers.iterator()（ServiceLoader.iterator() 方法实现）
    public Iterator<S> iterator() {
        return new Iterator<S>() {
    	    // 使用外部类的 providers 初始化 knownProviders
            Iterator<Map.Entry<String,S>> knownProviders = providers.entrySet().iterator();
    
            public boolean hasNext() {
                if (knownProviders.hasNext()){
                    return true;
    			}	
                return lookupIterator.hasNext();
            }
    
            public S next() {
                if (knownProviders.hasNext()){
                    return knownProviders.next().getValue();
    			}
                return lookupIterator.next();
            }
    
            public void remove() {
                throw new UnsupportedOperationException();
            }
    
        };
    }
    ```

4. lookupIterator (LazyIterator) 实现解析：

    ```java
    # 字段
    Class<S> service; 	             //服务接口
    ClassLoader loader;				 //类加载器
    Enumeration<URL> configs = null; //所有提供者配置信息
    Iterator<String> pending = null; //服务提供者迭代器
    String nextName = null;			 //下一个服务提供者的名字
    
    # 判断有没有服务提供者
    public boolean hasNext() {
        if (acc == null) {
            return hasNextService();
        } else {
            PrivilegedAction<Boolean> action = new PrivilegedAction<Boolean>() {
                public Boolean run() { return hasNextService(); }
            };
            return AccessController.doPrivileged(action, acc);
        }
    }
    
    #  判断有没有服务
    private boolean hasNextService() {
        if (nextName != null) {
            return true;
        }
        if (configs == null) {
            try {
                String fullName = PREFIX + service.getName();
    		    // 加载所有服务提供者配置文件
                if (loader == null)
                    configs = ClassLoader.getSystemResources(fullName);
                else
                    configs = loader.getResources(fullName);
            } catch (IOException x) {
                fail(service, "Error locating configuration files", x);
            }
        }
        while ((pending == null) || !pending.hasNext()) {
            if (!configs.hasMoreElements()) {
                return false;
            }
            # 从配置信息中解析服务提供者类，找不到返回空
            pending = parse(service, configs.nextElement());
        }
    	//设置下一个服务提供者的类名，next方法使用名字加载和初始化对应的实现类
        nextName = pending.next();
        return true;
    }
    
    # 获取下一个服务提供者
    public S next() {
        if (acc == null) {
            return nextService();
        } else {
            PrivilegedAction<S> action = new PrivilegedAction<S>() {
                public S run() { return nextService(); }
            };
            return AccessController.doPrivileged(action, acc);
        }
    }
    # 获取下一个服务提供者类
    private S nextService() {
        if (!hasNextService())
            throw new NoSuchElementException();
        String cn = nextName;
        nextName = null;
        Class<?> c = null;
        try {
            # 加载类信息
            c = Class.forName(cn, false, loader);
        } catch (ClassNotFoundException x) {
            fail(service,
                 "Provider " + cn + " not found");
        }
        if (!service.isAssignableFrom(c)) {
            fail(service,
                 "Provider " + cn  + " not a subtype");
        }
        try {
            # 初始化类
            S p = service.cast(c.newInstance());
            providers.put(cn, p);
            return p;
        } catch (Throwable x) {
            fail(service,
                 "Provider " + cn + " could not be instantiated",
                 x);
        }
        throw new Error();          // This cannot happen
    }
    ```