时间：2018-09-06 19:58:51

参考： 

## Spring 容器

### Spring 简介

在项目中会有大量的类，类需要被构造成对象才能使用，当类之间的依赖关系十分复杂时，构造对象的过程就会十分复杂，需要先构造对象的依赖，然后构造依赖的依赖，最后完成类的构造。当关系复杂时，构造一个类需要我们清除各个类之间的依赖关系，同时也需要大量的代码，给开发带来了额外的复杂度和工作量。

Spring的核心是容器（Container），容器用来管理实例化的类，以及类的实例化。在Spring里，把被Spring容器管理的类实例称为Bean。对于每一个Bean，我们会有一个基于XML或者注解的描述被称为 `BeanDefinition`，`BeanDefinition` 定义Bean的属性，比如说字段的值，依赖的Bean等等。通过  `BeanDefinition` Spring 可以构造出一个对应的类实例（BeanDefinition 相当于定义了Bean应该怎样初始化）。

Bean初始化的过程中，Spring通过反射给Bean的属性赋值，普通变量Spring会转换成对应的类型。当依赖其它Bean时，Spring会从容器中找出实例化的Bean（Spring提供被依赖Bean先初始化的机制），然后给属性赋值。 此时Spring相当于一个仓库，负责管理Bean，以及Bean的初始化和依赖注入。Spring提供了根据构造函数和setter方法注入的机制。

Spring初始化Bean的过程分为几个阶段，在每个阶段都可以做一些处理，Spring也提供了操作不同过程的切入点，因此我们可以使用Spring灵活的操作Bean的初始化过程。

### Spring Bean 使用 

#### 扩展接口 

1. 销毁bean。等价的注解 `@PreDestroy`

    ```java
    public interface DisposableBean {
        void destroy() throws Exception;		
    }
    ```

2. Bean的属性全部被设置之后调用的方法。 等价的注解 `@PostConstruct`  

    ```java
    public interface InitializingBean {
        void afterPropertiesSet() throws Exception;
    }
    ```

3. 更灵活的Bean处理接口

    ```java
    public interface BeanPostProcessor {
        @Nullable
        default Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
            return bean;
        }
        @Nullable
        default Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
            return bean;
        }
    }
    ```

4. 支持生命周期管理接口，实现接口的类提供生命周期管理方法  

    ```
    public interface Lifecycle {
        void start();
        void stop();
        boolean isRunning();
    }
    ```

5. 属性注入接口  

	* ApplicationContextAware 
	* ApplicationEventPublisherAware
	* BeanClassLoaderAware
	* BeanFactoryAware
	* BeanNameAware
	* BootstrapContextAware
	* LoadTimeWeaverAware
	* MessageSourceAware
	* NotificationPublisherAware
	* ResourceLoaderAware
	* ServletConfigAware
	* ServletContextAware

### Spring 容器扩展点  

Spring提供了一系列插件化的接口，方便开发者扩展容器功能。  

`org.springframework.beans.factory` 包提供基础的管理Bean的功能接口。  
`org.springframework.context` 包提供更灵活的功能。 

1. Bean 初始化前后进行处理，用法可参考 `RequiredAnnotationBeanPostProcessor` 以及 `AutowiredAnnotationBeanPostProcessor`。

    ```java
    public interface BeanPostProcessor {
        @Nullable
        default Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
            return bean;
    
        @Nullable
        default Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
            return bean;
        }
    }
    ```

2. 自定义变更 `BeanDefinition`，再Bean初始化之前进行。

    ```java
    @FunctionalInterface
    public interface BeanFactoryPostProcessor {
        void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory) throws BeansException;
    }
    ```

3. 替换占位符 `PropertySourcesPlaceholderConfigurer`。

4. 使用 `BeanFactory` 自定义Bean初始化逻辑，Spring框架内部有50多种BeanFactory实现。

    ```java
    public interface FactoryBean
        @Nullable
        T getObject() throws Exc
        @Nullable
        Class<?> getObject
        default boolean isSingleton() {
            return true;
        }
    }
    ```