时间：2018/9/19 10:36:24   

参考： 

1. [Spring Framework Documentation](https://docs.spring.io/spring/docs/5.0.9.RELEASE/spring-framework-reference/)
2. [spring-framework](https://github.com/spring-projects/spring-framework)

## Spring 组件类及其使用场景

## BeanDefinition

#### 简介  
Spring对Bean的抽象，描述Bean的定义。Spring 根据 `BeanDefinition` 初始化Bean。

常用类型： 

* RootBeanDefinition
* AnnotatedGenericBeanDefinition
* ScannedGenericBeanDefinition

## BeanDefinitionReader  

#### 简介  
 
读取 BeanDefinition

## BeanPostProcessor  
####  简介  
`BeanPostProcessor` 是Spring定义的一类特殊接口，这类接口的作用是在Bean初始化前后对Bean进行处理，基础接口定义如下：

	public interface BeanPostProcessor {
		//Bean初始化前进行处理
		Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException;
		//Bean初始化后进行处理
		Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException;
	}

Bean 构造过程：todo

扩展接口：

* InstantiationAwareBeanPostProcessor：  

		public interface InstantiationAwareBeanPostProcessor extends BeanPostProcessor {
			
			//Bean 实例化之前
			Object postProcessBeforeInstantiation(Class<?> beanClass, String beanName) throws BeansException;
			
			//Bean 实例化之后
			boolean postProcessAfterInstantiation(Object bean, String beanName) throws BeansException;
		
			//属性设置到Bean之前进行处理
			PropertyValues postProcessPropertyValues(
					PropertyValues pvs, PropertyDescriptor[] pds, Object bean, String beanName)
					throws BeansException;
		
		}
* SmartInstantiationAwareBeanPostProcessor:
		
		public interface SmartInstantiationAwareBeanPostProcessor extends InstantiationAwareBeanPostProcessor {

			//预测Bean类型，用于初始化
			Class<?> predictBeanType(Class<?> beanClass, String beanName) throws BeansException;
		
			//确定候选的构造函数，用于初始化
			Constructor<?>[] determineCandidateConstructors(Class<?> beanClass, String beanName) throws BeansException;

			Object getEarlyBeanReference(Object bean, String beanName) throws BeansException;		
		}

#### 使用场景

## InitializingBean  

#### 简介

Spring 会在Bean的属性设置完成之后调用 `afterPropertiesSet()` 方法。可以使用 `@PostConstruct` 替代。
 
	public interface InitializingBean {	
		void afterPropertiesSet() throws Exception;
	}

#### 使用场景  

* 当Bean的属性设置完成之后执行初始化操作，比如从数据库读取通用数据到缓存。

## DisposableBean

#### 简介  

Spring 会在单例Bean销毁的时候调用 `destroy()` 方法。
	
	public interface DisposableBean {
	
		/**
		 * Invoked by a BeanFactory on destruction of a singleton.
		 * @throws Exception in case of shutdown errors.
		 * Exceptions will get logged but not rethrown to allow
		 * other beans to release their resources too.
		 */
		void destroy() throws Exception;
	
	}
#### 使用场景

* Bean 被销毁的时候释放资源，例如清除缓存等。

## Aware 接口 

#### 简介：
`Aware` 是一类接口的标志，Spring 容器会在初始化Bean的时候检查类是否实现了 `Aware` 类型的接口，如果实现的话会调用对应的 `set` 方法，在 `set` 方法里面我们可以对接收到的属性进行处理。

结合 `BeanPostProcessor` 可以实现自定义的 `Aware` 接口。

Spring内部常用的 Aware 接口：

* EnvironmentAware：设置环境变量
* ResourceLoaderAware：设置资源加载器
* ApplicationEventPublisherAware：设置事件发布工具
* ApplicationContextAware:设置 ApplicationContext

Spring 调用Bean的Set方法的地方 `ApplicationContextAwareProcessor`

	class ApplicationContextAwareProcessor{
	
		public Object postProcessBeforeInitialization(final Object bean, String beanName) throws BeansException {
			invokeAwareInterfaces(bean);
			return bean;
		}
	
		private void invokeAwareInterfaces(Object bean) {
			if (bean instanceof Aware) {
				if (bean instanceof EnvironmentAware) {
					((EnvironmentAware) bean).setEnvironment(this.applicationContext.getEnvironment());
				}
				if (bean instanceof EmbeddedValueResolverAware) {
					((EmbeddedValueResolverAware) bean).setEmbeddedValueResolver(
							new EmbeddedValueResolver(this.applicationContext.getBeanFactory()));
				}
				if (bean instanceof ResourceLoaderAware) {
					((ResourceLoaderAware) bean).setResourceLoader(this.applicationContext);
				}
				if (bean instanceof ApplicationEventPublisherAware) {
					((ApplicationEventPublisherAware) bean).setApplicationEventPublisher(this.applicationContext);
				}
				if (bean instanceof MessageSourceAware) {
					((MessageSourceAware) bean).setMessageSource(this.applicationContext);
				}
				if (bean instanceof ApplicationContextAware) {
					((ApplicationContextAware) bean).setApplicationContext(this.applicationContext);
				}
			}
		}
	}

#### 使用场景  

## 事件和监听器机制 

### 简介

* ApplicationEvent：事件类（实现java原生事件接口）
* ApplicationListener：监听器类（实现Java原生监听器接口）
* ApplicationEventPublisher： 发布事件。

### 应用场景

使用事件机制进系统虚拟机内通信，分离事件发布和事件处理，降低项目之间耦合性。